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
        loadingText,
        style: textStyle,
      ),
    ),
  );
}

void showProgressIndicatorDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SizedBox.expand(
        child: Container(
          color: hintTextColor,
          child: Text(
            loadingText,
            style: appBarTitleStyle,
          ),
        ),
      );
    },
  );
}

void hideProgressIndicatorDialog(BuildContext context) {
  Navigator.pop(context);
}
