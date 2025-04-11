import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'app/app.dart'; // Import our main App widget

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Wrap the entire application in a ProviderScope
  runApp(
    const ProviderScope(
      child: MyApp(), // Use our custom App widget
    ),
  );
}

// The default MainApp widget is no longer needed as MyApp handles the MaterialApp setup.
