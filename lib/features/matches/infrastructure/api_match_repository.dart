import 'package:dio/dio.dart';
import '../domain/match.dart';
import '../domain/match_repository.dart';

// API implementation of MatchRepository using Firebase Function Proxy
class ApiMatchRepository implements MatchRepository {
  final Dio _dio;
  // URL of the deployed Firebase Function proxy
  final String _proxyUrl =
      'https://us-central1-onlysports-e9b57.cloudfunctions.net/footballDataProxy';

  ApiMatchRepository(this._dio) {
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
      _proxyUrl,
      data: {
        'path': targetPath, // e.g., "/competitions/PL/matches"
        'params': queryParams, // e.g., { "status": "SCHEDULED" }
      },
    );
  }

  @override
  Future<List<Match>> getUpcomingMatches({
    String? league,
    String? team,
    DateTime? date,
  }) async {
    // Use competition code (e.g., 'PL') or ID based on API needs
    const competitionCode = 'PL'; // Example: Premier League code
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
        return matchesJson.map((json) => Match.fromJson(json)).toList();
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
    String? league,
    String? team,
    DateTime? date,
  }) async {
    const competitionCode = 'PL'; // Example
    final targetPath = '/competitions/$competitionCode/matches';
    final queryParams = {
      'status': 'FINISHED',
      // TODO: Add date filtering params if needed
    };

    try {
      final response = await _callProxy(targetPath, queryParams);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> matchesJson = response.data['matches'] ?? [];
        return matchesJson.map((json) => Match.fromJson(json)).toList();
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
  Future<Match?> getMatchDetails(String matchId) async {
    final targetPath = '/matches/$matchId';
    // No query params needed for fetching by ID usually

    try {
      final response = await _callProxy(targetPath, null);

      if (response.statusCode == 200 && response.data != null) {
        // Assuming proxy forwards the direct match object or nested object correctly
        // Adjust based on actual response structure forwarded by proxy
        return Match.fromJson(response.data);
        // Or if nested: return Match.fromJson(response.data['match']);
      } else if (response.statusCode == 404) {
        print('Match details not found (404) for ID: $matchId');
        return null;
      } else {
        print(
          'Proxy Error (Details): Status ${response.statusCode}, Data: ${response.data}',
        );
        throw Exception('Failed to load match details via proxy');
      }
    } on DioException catch (e) {
      print('DioError calling proxy (Details): $e');
      throw Exception(
        'Network error fetching match details via proxy: ${e.message}',
      );
    } catch (e) {
      print('Error processing proxy response (Details): $e');
      throw Exception('Failed to process match details data via proxy');
    }
  }
}
