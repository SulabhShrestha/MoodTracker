import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/views/continue_with_page/continue_with.dart';

/// Provides deleteDataPage key to all the descended
/// Useful for navigating to [ContinueWithPage] after account deletion
///
/// This will automatically dispose the provider when no longer used
final dataDeletePageKeyProvider = StateProvider.autoDispose<GlobalKey>((ref) {
  // Default index, [HomePage]
  return GlobalKey();
});
