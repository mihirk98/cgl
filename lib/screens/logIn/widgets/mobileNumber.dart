// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/screens/logIn/controller.dart';

class MobileNumberWidget extends StatefulWidget {
  final controller;
  const MobileNumberWidget({Key key, this.controller}) : super(key: key);
  @override
  _MobileNumberWidgetState createState() =>
      _MobileNumberWidgetState(controller);
}

class _MobileNumberWidgetState extends State<MobileNumberWidget> {
  String dialCode = "";
  final controller;
  _MobileNumberWidgetState(this.controller);

  final mobileNumberController = TextEditingController();

  @override
  void initState() {
    controller.dialCodeStream.listen((updatedDialCode) {
      setState(() {
        dialCode = updatedDialCode;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
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
                    controller: mobileNumberController,
                    keyboardType: TextInputType.phone,
                    style: textStyle,
                    decoration: InputDecoration(
                      hintText: mobileNumberHintString,
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
                    ),
                  ),
                ),
              ),
              RaisedButton(
                color: whiteColor,
                child: Icon(
                  Icons.done,
                  color: textColor,
                ),
                onPressed: () =>
                    verifyMobileNumber(context, mobileNumberController.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
