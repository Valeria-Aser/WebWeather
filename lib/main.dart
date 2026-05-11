// ignore_for_file: avoid_print

import 'package:easy_weather/pages/spash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  print("Welcome to the Easy Weather app");
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: SplashScreen(),
        // debugShowCheckedModeBanner: true,
      ),
    ),
  );
}
