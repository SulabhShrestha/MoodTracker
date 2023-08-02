import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/views/core/delete_confirmation_dialog.dart';

/// Provides homepage key to all the descended
/// Useful when showing [DeleteConfirmationDialog]
///
/// This will automatically dispose the provider when no longer used
final homePageKeyProvider = StateProvider<GlobalKey>((ref) {
  // Default index, [HomePage]
  return GlobalKey();
});
