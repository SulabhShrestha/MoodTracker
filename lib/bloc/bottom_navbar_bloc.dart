import 'dart:async';

class BottomNavBarBloc {
  // true: show navbar, false: hide navbar
  final StreamController<bool> _streamController = StreamController();

  Stream<bool> get counterStream => _streamController.stream;

  StreamSink<bool> get counterSink => _streamController.sink;
}
