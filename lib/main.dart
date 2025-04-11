import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive Flutter
import 'app/app.dart'; // Import our main App widget
import 'features/favorites/domain/favorite.dart'; // Import Favorite model
import 'features/matches/domain/match.dart'; // Import Match model & related

Future<void> main() async {
  // Make main async
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(FavoriteAdapter());
  Hive.registerAdapter(MatchAdapter());
  Hive.registerAdapter(CompetitionRefAdapter());
  Hive.registerAdapter(TeamRefAdapter());
  Hive.registerAdapter(ScoreAdapter());
  Hive.registerAdapter(ScoreTimeAdapter());

  // Open Hive Boxes
  await Hive.openBox<Favorite>('favoritesBox');
  await Hive.openBox<Match>('matchesBox');

  // Wrap the entire application in a ProviderScope
  runApp(
    const ProviderScope(
      child: MyApp(), // Use our custom App widget
    ),
  );
}

// The default MainApp widget is no longer needed as MyApp handles the MaterialApp setup.
