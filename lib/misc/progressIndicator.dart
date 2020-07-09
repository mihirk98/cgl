// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cgl/constants/colors.dart';

SizedBox showProgressIndicator() {
  return SizedBox.expand(
    child: Center(
      child: CircularProgressIndicator(),
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
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    },
  );
}

void hideProgressIndicatorDialog(BuildContext context) {
  Navigator.pop(context);
}
