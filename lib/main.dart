// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';

// Project imports:
import 'package:cgl/components/setFamilyDialog.dart';
import 'package:cgl/screens/home/page.dart';
import 'package:cgl/providers/userProvider.dart';
import 'package:cgl/screens/logIn/page.dart';
import 'constants/colors.dart';
import 'constants/strings.dart';
import 'models/user.dart';

void main() => runApp(MainPage());

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        Locale('en'),
      ],
      debugShowCheckedModeBanner: false,
      title: appTitleString,
      theme: buildThemeData(context),
      home: buildHome(),
    );
  }

  ThemeData buildThemeData(BuildContext context) {
    return ThemeData(
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: textColor,
            displayColor: textColor,
            fontFamily: fontString,
          ),
      accentColor: secondaryColor,
      textSelectionHandleColor: secondaryColor,
      cursorColor: secondaryColor,
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      primaryColorDark: primaryColorDark,
    );
  }

  FutureBuilder<User> buildHome() {
    return FutureBuilder(
      future: getUser(),
      builder: (buildContext, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.mobileNumber == null) {
            return LogInPage();
          } else if (snapshot.data.document == null) {
            return SetFamilyDialog();
          }
          //ToDo Add Home Page
          return UserProvider(
            user: snapshot.data,
            child: HomePage(),
          );
        } else {
          return buildSplashScaffold();
        }
      },
    );
  }

  Scaffold buildSplashScaffold() {
    return Scaffold(
      backgroundColor: primaryColor,
      body:
          //ToDo Add Logo
          Container(),
    );
  }
}

Future<String> notificationToken(String mobileNumber) async {
  final FirebaseMessaging fcm = FirebaseMessaging();
  if (Platform.isIOS) {
    //ToDo IOS token upload
  } else {
    return await fcm.getToken();
  }
  return null;
}
