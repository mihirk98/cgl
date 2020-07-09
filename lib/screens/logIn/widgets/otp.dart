// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cgl/screens/logIn/controller.dart';
import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';

class OTPWidget extends StatefulWidget {
  @override
  _OTPWidgetState createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  bool otpWidgetState = false;
  final otpController = TextEditingController();

  @override
  void initState() {
    otpStatusStream.listen((updatedOtpStatus) {
      setState(() {
        otpWidgetState = updatedOtpStatus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextField(
                    enabled: otpWidgetState,
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    decoration: InputDecoration(
                      hintText: otpHintString,
                      hintStyle: hintTextStyle,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: hintTextColor,
                          width: 1,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: textColor,
                          width: 2,
                        ),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: whiteColor,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              RaisedButton(
                color: whiteColor,
                child: Icon(
                  Icons.arrow_forward,
                  color: textColor,
                ),
                onPressed: () => verifyOTP(context, otpController.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
