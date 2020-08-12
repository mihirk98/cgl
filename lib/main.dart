// Flutter imports:
import 'package:cgl/constants/styles.dart';
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

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  handleNotifications() {
    final FirebaseMessaging fcm = FirebaseMessaging();
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        //ToDo
      },
      onLaunch: (Map<String, dynamic> message) async {
        //Todo
      },
      onResume: (Map<String, dynamic> message) async {
        // ToDo
      },
    );
  }

  @override
  void initState() {
    handleNotifications();
    super.initState();
  }

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
      backgroundColor: secondaryColorLight,
      body: Center(
        child: Text(
          welcomeString,
          style: splashTextStyle,
        ),
      ),
    );
  }
}
