import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

// All providers are defined at feature level using Riverpod.
// This file handles any imperative initialization needed at startup.

Future<void> configureDependencies() async {
  // Additional setup if needed (e.g., Firebase, analytics, etc.)
  // Riverpod providers are lazily initialized — no manual registration needed.
}