// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:cgl/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:cgl/screens/home/page.dart';
import 'package:cgl/components/setFamilyDialog.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/widgets/progressIndicator.dart';
import 'package:cgl/widgets/snackBar.dart';
import 'package:cgl/models/user.dart';

String dialCode = "", mobileNumber = "", verificationId = "";
bool otpStatus = false, timeOutStatus = false;

final otpStatusStreamController = StreamController<bool>();
Stream<bool> get otpStatusStream => otpStatusStreamController.stream;

class LogInController {
  final dialCodeStreamController = StreamController<String>.broadcast();
  Stream<String> get dialCodeStream => dialCodeStreamController.stream;

  final dialCodeUpdateStreamController = StreamController<String>();
  Sink<String> get dialCodeSink => dialCodeUpdateStreamController.sink;
  Stream<String> get dialCodeUpdateStream =>
      dialCodeUpdateStreamController.stream;

  LogInController() {
    dialCodeUpdateStream.listen((updatedDialCode) {
      dialCode = updatedDialCode;
      dialCodeStreamController.add(dialCode);
    });
  }

  void dispose() {
    dialCodeStreamController.close();
    dialCodeUpdateStreamController.close();
    otpStatusStreamController.close();
  }
}

verifyMobileNumber(BuildContext context, String number) {
  if (number.length == 10) {
    if (dialCode == "")
      showSnackBar(context, selectCountryCodeSnackBarString, 5);
    else {
      if (otpStatus == false) {
        mobileNumber = number;
        showProgressIndicatorDialog(context);
        sendOTP(context);
      } else {
        showSnackBar(context, otpSentString, 2);
      }
    }
  } else
    showSnackBar(context, mobileNumberLengthString, 5);
}

sendOTP(BuildContext context) async {
  final PhoneVerificationCompleted verified =
      (AuthCredential authResult) async {
    FirebaseAuth.instance.signInWithCredential(authResult);
    createUserStatus(context, dialCode, mobileNumber);
  };

  final PhoneVerificationFailed verificationfailed =
      (AuthException authException) {
    showSnackBar(
        context, otpVerificationErrorString + "${authException.message}", 5);
  };

  final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
    hideProgressIndicatorDialog(context);
    otpStatusStreamController.add(true);
    otpStatus = true;
    showSnackBar(context, otpSentString, 2);
    verificationId = verId;
  };

  final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
    timeOutStatus = true;
    showSnackBar(context, enterOTPString, 2);
    verificationId = verId;
  };

  await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: dialCode + mobileNumber,
      timeout: const Duration(seconds: 30),
      verificationCompleted: verified,
      verificationFailed: verificationfailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout);
}

verifyOTP(BuildContext context, String otp) {
  if (otpStatus) {
    if (timeOutStatus) {
      signInWithOTP(context, otp);
    } else {
      showSnackBar(context, autoRetrievalAttemptString, 5);
    }
  } else {
    showSnackBar(context, verifyNumberBeforeOTPString, 5);
  }
}

signInWithOTP(BuildContext context, String smsCode) async {
  showProgressIndicatorDialog(context);
  if (smsCode.length == 6) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    try {
      await FirebaseAuth.instance.signInWithCredential(authCreds);
      createUserStatus(context, dialCode, mobileNumber);
    } on PlatformException catch (e) {
      hideProgressIndicatorDialog(context);
      showSnackBar(context, e.toString(), 5);
    }
  } else {
    hideProgressIndicatorDialog(context);
    showSnackBar(context, incorrectOTPString, 2);
  }
}

familyStatus(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String document = prefs.getString("document") ?? null;
  if (document == null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetFamilyDialog(),
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProvider(
          user: User(
            mobileNumber,
            dialCode,
            document,
            prefs.getString("token"),
          ),
          child: HomePage(),
        ),
      ),
    );
  }
}

Future<void> createUserStatus(
    BuildContext context, String dialCode, String mobileNumber) async {
  await createUser(context, dialCode, mobileNumber).then((status) => {
        if (status)
          {
            familyStatus(context),
          }
        else
          {
            createUserStatus(context, dialCode, mobileNumber),
          }
      });
}
