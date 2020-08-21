// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:cgl/actionStatusSingleton.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/widgets/progressIndicator.dart';
import 'package:cgl/models/item.dart';

ActionStatusSingleton actionStatus = ActionStatusSingleton.getInstance();

class HomeController {
  //Checked Visbility
  final checkedVisibilityStreamController = StreamController<bool>.broadcast();
  Stream<bool> get checkedVisibilityStream =>
      checkedVisibilityStreamController.stream;

  final checkedVisibilityUpdateStreamController = StreamController<bool>();
  Sink<bool> get checkedVisibilitySink =>
      checkedVisibilityUpdateStreamController.sink;
  Stream<bool> get checkedVisibilityUpdateStream =>
      checkedVisibilityUpdateStreamController.stream;

  //Quantity
  final quantityStreamController = StreamController<int>.broadcast();
  Stream<int> get quantityStream => quantityStreamController.stream;

  final quantityUpdateStreamController = StreamController<int>();
  Sink<int> get quantitySink => quantityUpdateStreamController.sink;
  Stream<int> get quantityUpdateStream => quantityUpdateStreamController.stream;

  //Unit
  final unitStreamController = StreamController<String>();
  Stream<String> get unitStream => unitStreamController.stream;

  final unitUpdateStreamController = StreamController<String>();
  Sink<String> get unitSink => unitUpdateStreamController.sink;
  Stream<String> get unitUpdateStream => unitUpdateStreamController.stream;

  //Items
  final allItemsStreamController = StreamController<List<Item>>.broadcast();
  Stream<List<Item>> get allItemsStream => allItemsStreamController.stream;

  final allItemsUpdateStreamController = StreamController<List<Item>>();
  Sink<List<Item>> get allItemsSink => allItemsUpdateStreamController.sink;
  Stream<List<Item>> get allItemsUpdateStream =>
      allItemsUpdateStreamController.stream;

  HomeController() {
    checkedVisibilityUpdateStream.listen((updatedVisibility) {
      checkedVisibilityStreamController.add(updatedVisibility);
    });
    quantityUpdateStream.listen((updatedQuantity) {
      quantityStreamController.add(updatedQuantity);
    });
    unitUpdateStream.listen((updatedUnit) {
      unitStreamController.add(updatedUnit);
    });
    allItemsUpdateStream.listen((allItems) {
      allItemsStreamController.add(allItems);
    });
  }

  void dispose() {
    checkedVisibilityStreamController.close();
    checkedVisibilityUpdateStreamController.close();
    quantityStreamController.close();
    quantityUpdateStreamController.close();
    unitStreamController.close();
    unitUpdateStreamController.close();
    allItemsStreamController.close();
    allItemsUpdateStreamController.close();
  }
}

Future<bool> getCheckedVisibility() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  bool checkedVisbility = pref.getBool("checkedVisbility") ?? true;
  return checkedVisbility;
}

Future<void> setCheckedVisibility(bool visbilityValue) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool("checkedVisbility", visbilityValue);
}

Future<void> sendNotification(
  bool familyMembersExists,
  BuildContext context,
  List<String> familyMembersList,
  List<bool> familyMembersNotifyStatusList,
  String mobileNumber,
  String notifyMessage,
) async {
  if (familyMembersExists) {
    showProgressIndicatorDialog(context);
    List<String> familyMembersNotifyList = [];
    for (int i = 0; i < familyMembersList.length; i++) {
      if (familyMembersNotifyStatusList[i] == true) {
        if (familyMembersList[i] != mobileNumber) {
          familyMembersNotifyList.add(familyMembersList[i]);
        }
      }
    }
    actionStatus.descriptionSink.add(sendingNotificationString);
    actionStatus.actionVisibilitySink.add(true);
    final HttpsCallable httpsCallable = new CloudFunctions(region: "asia-east2")
        .getHttpsCallable(functionName: 'notifyFamily');
    httpsCallable.call(<String, dynamic>{
      'familyMembers': familyMembersNotifyList,
      'message': notifyMessage,
    }).then(
        (_) => {
              actionStatus.descriptionSink.add(notificationSentString),
            }, onError: (e) {
      actionStatus.descriptionSink.add(notificationFailString);
    }).then((_) => {
          Future.delayed(const Duration(milliseconds: 5000), () {
            actionStatus.actionVisibilitySink.add(false);
          }),
        });
    hideProgressIndicatorDialog(context);
    Navigator.pop(context);
  }
}
