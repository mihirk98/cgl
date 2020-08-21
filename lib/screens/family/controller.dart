// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cgl/components/setFamilyDialog.dart';
import 'package:cgl/models/family.dart';
import 'package:cgl/screens/family/dialogs/exitConfirmationDialog.dart';
import 'package:cgl/models/item.dart';

final backUpVisibilityUpdateStreamController =
    StreamController<bool>.broadcast();
Sink<bool> get backUpVisibilitySink =>
    backUpVisibilityUpdateStreamController.sink;
Stream<bool> get backUpVisibilityUpdateStream =>
    backUpVisibilityUpdateStreamController.stream;

final backUpStatusUpdateStreamController = StreamController<bool>.broadcast();
Sink<bool> get backUpStatusSink => backUpStatusUpdateStreamController.sink;
Stream<bool> get backUpStatusUpdateStream =>
    backUpStatusUpdateStreamController.stream;

class FamilyController {
  //BackUp Visbility
  final backUpVisibilityStreamController = StreamController<bool>.broadcast();
  Stream<bool> get backUpVisibilityStream =>
      backUpVisibilityStreamController.stream;

  //BackUp Status
  final backUpStatusStreamController = StreamController<bool>.broadcast();
  Stream<bool> get backUpStatusStream => backUpStatusStreamController.stream;

  FamilyController() {
    backUpVisibilityUpdateStream.listen((updatedVisibility) {
      backUpVisibilityStreamController.add(updatedVisibility);
    });
    backUpStatusUpdateStream.listen((updatedStatus) {
      backUpStatusStreamController.add(updatedStatus);
    });
  }

  void dispose() {
    backUpVisibilityStreamController.close();
    backUpVisibilityUpdateStreamController.close();
    backUpStatusStreamController.close();
    backUpStatusUpdateStreamController.close();
  }
}

exitFamilyDialog(
    final controller, String family, String user, BuildContext context) {
  showExitConfirmationDialog(controller, family, user, context);
}

exitFamilyFunc(String family, String user, BuildContext context) async {
  await exitFamily(family, user).then(
    (_) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetFamilyDialog(),
      ),
    ),
  );
}

backUpItemsFunc(String family, String user, BuildContext context) async {
  backUpVisibilitySink.add(true);
  await backUpItems(family, user).then((_) {
    backUpVisibilitySink.add(false);
    backUpStatusSink.add(true);
  });
}
