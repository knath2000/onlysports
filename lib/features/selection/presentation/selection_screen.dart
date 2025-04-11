import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../matches/domain/match.dart'
    show CompetitionRef; // Only import CompetitionRef
import '../domain/user_selection.dart';
import '../../matches/presentation/screens/match_list_screen.dart'; // For navigation
import '../../../shared/widgets/shared_loading_indicator.dart'; // Import shared loading
import '../../../shared/widgets/shared_error_message.dart'; // Import shared error

class SelectionScreen extends ConsumerStatefulWidget {
  const SelectionScreen({super.key});

  @override
  ConsumerState<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends ConsumerState<SelectionScreen> {
  CompetitionRef? _selectedLeague; // Store the selected league object

  @override
  Widget build(BuildContext context) {
    final asyncLeagues = ref.watch(availableLeaguesProvider);
    final selectionNotifier = ref.read(
      selectionRepositoryProvider,
    ); // For saving

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select League'),
        automaticallyImplyLeading: false, // No back button
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: asyncLeagues.when(
            data: (leagues) {
              if (leagues.isEmpty) {
                return const Text('No leagues available to select.');
                // TODO: Add a retry button?
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Dropdown for League Selection
                  DropdownButton<CompetitionRef>(
                    value: _selectedLeague,
                    hint: const Text('Choose a league...'),
                    isExpanded: true,
                    items:
                        leagues.map((league) {
                          return DropdownMenuItem<CompetitionRef>(
                            value: league,
                            child: Text(league.name), // Display league name
                          );
                        }).toList(),
                    onChanged: (CompetitionRef? newValue) {
                      setState(() {
                        _selectedLeague = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 30),

                  // Save Button
                  ElevatedButton(
                    onPressed:
                        _selectedLeague == null
                            ? null // Disable if no league is selected
                            : () async {
                              if (_selectedLeague != null) {
                                final selection = UserSelection(
                                  selectedLeagueId:
                                      _selectedLeague!.id
                                          .toString(), // Assuming ID is int, API might use string codes like 'PL'
                                  selectedLeagueName: _selectedLeague!.name,
                                );
                                try {
                                  await selectionNotifier.saveSelection(
                                    selection,
                                  );
                                  ref.invalidate(
                                    userSelectionProvider,
                                  ); // Refresh user selection state
                                  // Navigate to main screen, replacing this one
                                  if (mounted) {
                                    // Check if widget is still in tree
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const MatchListScreen(),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  // Show error to user
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Error saving selection: $e',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                    child: const Text('Save & Continue'),
                  ),
                ],
              );
            },
            // Use shared loading indicator
            loading: () => const SharedLoadingIndicator(),
            // Use shared error message widget with retry callback
            error:
                (error, stack) => SharedErrorMessage(
                  error: 'Failed to load available leagues: $error',
                  onRetry: () => ref.refresh(availableLeaguesProvider),
                ),
          ),
        ),
      ),
    );
  }
}
