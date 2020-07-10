// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cgl/constants/styles.dart';

showSnackBar(BuildContext context, String text, int duration) {
  Scaffold.of(context).hideCurrentSnackBar();
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: snackbarTextStyle,
      ),
      duration: Duration(seconds: duration),
    ),
  );
}
