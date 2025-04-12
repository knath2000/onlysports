import 'dart:async'; // Import async for StreamController
import 'package:dio/dio.dart';
import 'package:hive/hive.dart'; // Import Hive
import '../domain/match.dart';
import '../domain/match_repository.dart';

// API implementation of MatchRepository using Firebase Function Proxy
class ApiMatchRepository implements MatchRepository {
  final Dio _dio;
  // Relative path to the Vercel Serverless Function proxy
  final String _proxyPath = '/api/footballDataProxy';
  late final Box<Match> _matchesBox; // Hive box instance

  ApiMatchRepository(this._dio) {
    _matchesBox = Hive.box<Match>('matchesBox'); // Get the opened box
    // No need to set base URL or auth token here anymore,
    // as the proxy function handles that.
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true, // Log request body to see what's sent to proxy
        responseBody: false,
      ),
    );
  }

  // Helper function to call the proxy
  Future<Response<dynamic>> _callProxy(
    String targetPath,
    Map<String, dynamic>? queryParams,
  ) async {
    return await _dio.post(
      _proxyPath, // Use the relative path for Vercel proxy
      data: {
        'path': targetPath, // e.g., "/competitions/PL/matches"
        'params': queryParams, // e.g., { "status": "SCHEDULED" }
      },
    );
  }

  @override
  Future<List<Match>> getUpcomingMatches({
    String? leagueId, // Updated parameter name
    // String? team,
    DateTime? date,
  }) async {
    // Use the provided leagueId if available, otherwise default (or handle error)
    final competitionCode =
        leagueId ??
        'PL'; // Default to PL if none selected? Or throw error? Let's default for now.
    // TODO: Consider how to handle the case where leagueId is null - maybe fetch top leagues?
    final targetPath = '/competitions/$competitionCode/matches';
    final queryParams = {
      'status': 'SCHEDULED',
      // TODO: Add date filtering params if needed based on 'date' input
      // 'dateFrom': '...',
      // 'dateTo': '...',
    };

    try {
      final response = await _callProxy(targetPath, queryParams);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> matchesJson = response.data['matches'] ?? [];
        // Assuming the proxy correctly forwards the 'matches' list
        final matches =
            matchesJson.map((json) => Match.fromJson(json)).toList();
        // Save fetched matches to Hive cache
        for (var match in matches) {
          _matchesBox.put(match.id, match);
        }
        return matches;
      } else {
        print(
          'Proxy Error (Upcoming): Status ${response.statusCode}, Data: ${response.data}',
        );
        throw Exception('Failed to load upcoming matches via proxy');
      }
    } on DioException catch (e) {
      print('DioError calling proxy (Upcoming): $e');
      throw Exception(
        'Network error fetching upcoming matches via proxy: ${e.message}',
      );
    } catch (e) {
      print('Error processing proxy response (Upcoming): $e');
      throw Exception('Failed to process upcoming matches data via proxy');
    }
  }

  @override
  Future<List<Match>> getPreviousMatches({
    String? leagueId, // Updated parameter name
    // String? team,
    DateTime? date,
  }) async {
    final competitionCode = leagueId ?? 'PL'; // Default to PL if none selected?
    // TODO: Consider how to handle the case where leagueId is null
    final targetPath = '/competitions/$competitionCode/matches';
    final queryParams = {
      'status': 'FINISHED',
      // TODO: Add date filtering params if needed
    };

    try {
      final response = await _callProxy(targetPath, queryParams);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> matchesJson = response.data['matches'] ?? [];
        final matches =
            matchesJson.map((json) => Match.fromJson(json)).toList();
        // Save fetched matches to Hive cache
        for (var match in matches) {
          _matchesBox.put(match.id, match);
        }
        return matches;
      } else {
        print(
          'Proxy Error (Previous): Status ${response.statusCode}, Data: ${response.data}',
        );
        throw Exception('Failed to load previous matches via proxy');
      }
    } on DioException catch (e) {
      print('DioError calling proxy (Previous): $e');
      throw Exception(
        'Network error fetching previous matches via proxy: ${e.message}',
      );
    } catch (e) {
      print('Error processing proxy response (Previous): $e');
      throw Exception('Failed to process previous matches data via proxy');
    }
  }

  @override
  Stream<Match?> getMatchDetails(String matchId) {
    // Use a StreamController to manage emitting cached and fetched data
    final controller =
        StreamController<
          Match?
        >.broadcast(); // Use broadcast if stream might be listened to multiple times
    int? matchIdInt;

    try {
      matchIdInt = int.parse(matchId);
    } catch (e) {
      print("Error parsing matchId '$matchId' to int: $e");
      controller.addError(ArgumentError('Invalid matchId format: $matchId'));
      controller.close();
      return controller.stream;
    }

    // --- Stream Logic ---
    Future<void> fetchAndEmit() async {
      // 1. Emit cached value immediately if it exists
      final cachedMatch = _matchesBox.get(matchIdInt);
      if (cachedMatch != null) {
        if (!controller.isClosed) controller.add(cachedMatch);
      }

      // 2. Fetch from API
      final targetPath = '/matches/$matchIdInt';
      try {
        final response = await _callProxy(targetPath, null);

        if (response.statusCode == 200 && response.data != null) {
          final fetchedMatch = Match.fromJson(response.data);
          // 3. Save to Hive
          await _matchesBox.put(fetchedMatch.id, fetchedMatch);
          // 4. Emit fetched value

          if (!controller.isClosed) controller.add(fetchedMatch);
        } else if (response.statusCode == 404) {
          print('Match details not found (404) for ID: $matchIdInt');
          // If not found via API and wasn't cached, emit null
          if (cachedMatch == null && !controller.isClosed) controller.add(null);
        } else {
          print(
            'Proxy Error (Details): Status ${response.statusCode}, Data: ${response.data}',
          );
          if (!controller.isClosed) {
            controller.addError(
              Exception(
                'Failed to load match details via proxy (Status: ${response.statusCode})',
              ),
            );
          }
        }
      } on DioException catch (e) {
        print('DioError calling proxy (Details): $e');
        if (!controller.isClosed) {
          controller.addError(
            Exception(
              'Network error fetching match details via proxy: ${e.message}',
            ),
          );
        }
      } catch (e) {
        print('Error processing proxy response (Details): $e');
        if (!controller.isClosed) {
          controller.addError(
            Exception('Failed to process match details data via proxy'),
          );
        }
      } finally {
        // Close the controller only if no listeners remain or after a final value/error
        // For simplicity here, we might rely on the listener cancelling,
        // but closing after fetch ensures completion if no cache existed.
        // A more robust solution might involve reference counting or timeouts.
        // If we emitted something, we might keep it open for potential future updates.
        // If we only emitted cache or nothing, closing might be okay.
        // Let's close it for now if we haven't added a non-null value recently.
        // This logic needs refinement based on desired stream behavior (live updates vs. one-shot fetch).
        // For now, let's assume it's a fetch-and-complete stream.
        if (!controller.isClosed) controller.close();
      }
    }

    // Start the fetch process asynchronously
    fetchAndEmit();

    // Return the stream for the UI to listen to
    return controller.stream;
  }

  @override
  Future<List<CompetitionRef>> getAvailableLeagues() async {
    // Target the /competitions endpoint
    const targetPath = '/competitions';
    // Usually no query params needed, but check API docs if filtering is possible/needed
    // e.g., filter by plan: TIER_ONE for free tier
    final queryParams = {
      'plan': 'TIER_ONE', // Example: Filter for free tier leagues if supported
    };

    try {
      final response = await _callProxy(targetPath, queryParams);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> competitionsJson =
            response.data['competitions'] ?? [];
        // Map the response to CompetitionRef objects
        // Filter out leagues without an ID or name, as they might be invalid/unusable
        return competitionsJson
            .map((json) => CompetitionRef.fromJson(json))
            .where(
              (comp) =>
                  comp.name.isNotEmpty,
            ) // Basic validation
            .toList();
      } else {
        print(
          'Proxy Error (Leagues): Status ${response.statusCode}, Data: ${response.data}',
        );
        throw Exception('Failed to load available leagues via proxy');
      }
    } on DioException catch (e) {
      print('DioError calling proxy (Leagues): $e');
      throw Exception(
        'Network error fetching available leagues via proxy: ${e.message}',
      );
    } catch (e) {
      print('Error processing proxy response (Leagues): $e');
      throw Exception('Failed to process available leagues data via proxy');
    }
  }
}
