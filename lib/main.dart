import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/library/library_screen.dart';

void main() {
  runApp(const ProviderScope(child: EasyReaderApp()));
}

class EasyReaderApp extends StatelessWidget {
  const EasyReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyReader',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9C6A24)),
      ),
      home: const LibraryScreen(),
    );
  }
}
