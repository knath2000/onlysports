import 'package:flutter/material.dart';

/// A simple centered circular progress indicator.
class SharedLoadingIndicator extends StatelessWidget {
  const SharedLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
