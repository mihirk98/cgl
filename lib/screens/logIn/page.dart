// Flutter imports:
import 'package:cgl/widgets/actionStatus.dart';
import 'package:cgl/widgets/internetStatus.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cgl/screens/logIn/controller.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/screens/logIn/widgets/countryCode.dart';
import 'package:cgl/screens/logIn/widgets/mobileNumber.dart';
import 'package:cgl/screens/logIn/widgets/otp.dart';
import 'package:cgl/constants/colors.dart';

class LogInPage extends StatelessWidget {
  final LogInController controller = LogInController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => null,
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          title: Text(
            logInString,
            style: appBarTitleStyle,
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CountryCodeWidget(controller),
                    MobileNumberWidget(controller: controller),
                    OTPWidget(),
                  ],
                ),
              ),
              Column(
                children: [
                  ActionStatusWidget(),
                  InternetStatusWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
