// Dart imports:
import 'dart:async';

class ActionStatusSingleton {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ActionStatusSingleton _singleton =
      new ActionStatusSingleton._internal();
  ActionStatusSingleton._internal();

  //This is what's used to retrieve the instance through the app
  static ActionStatusSingleton getInstance() => _singleton;

  void initialize() {
    actionVisibilityUpdateStream.listen((updatedVisibility) {
      actionVisibilityStreamController.add(updatedVisibility);
    });
    descriptionUpdateStream.listen((updatedDescription) {
      descriptionStreamController.add(updatedDescription);
    });
  }

  //This tracks the current action status
  bool actionStatus = false;

  //This is how we'll allow subscribing to action changes
  final actionVisibilityStreamController = StreamController<bool>.broadcast();
  Stream<bool> get actionVisibilityStream =>
      actionVisibilityStreamController.stream;

  final actionVisibilityUpdateStreamController = StreamController<bool>();
  Sink<bool> get actionVisibilitySink =>
      actionVisibilityUpdateStreamController.sink;
  Stream<bool> get actionVisibilityUpdateStream =>
      actionVisibilityUpdateStreamController.stream;

  final descriptionStreamController = StreamController<String>.broadcast();
  Stream<String> get descriptionStream => descriptionStreamController.stream;

  final descriptionUpdateStreamController = StreamController<String>();
  Sink<String> get descriptionSink => descriptionUpdateStreamController.sink;
  Stream<String> get descriptionUpdateStream =>
      descriptionUpdateStreamController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    actionVisibilityStreamController.close();
    actionVisibilityUpdateStreamController.close();
    descriptionStreamController.close();
    descriptionUpdateStreamController.close();
  }
}
