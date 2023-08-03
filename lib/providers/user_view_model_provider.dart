import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/view_models/user_view_model.dart';

// This will store first day of  week
final userViewModelProvider = Provider<UserViewModel>((ref) {
  return UserViewModel();
});
