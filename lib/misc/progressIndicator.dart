// Flutter imports:
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cgl/constants/colors.dart';

SizedBox showProgressIndicator() {
  return SizedBox.expand(
    child: Center(
      child: Text(
        loadingString,
        style: appBarTitleStyle,
      ),
    ),
  );
}

void showProgressIndicatorDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Material(
        color: hintTextColor.withOpacity(0.2),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Card(
              color: whiteColor,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    loadingString,
                    style: appBarTitleStyle,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

void hideProgressIndicatorDialog(BuildContext context) {
  Navigator.pop(context);
}
