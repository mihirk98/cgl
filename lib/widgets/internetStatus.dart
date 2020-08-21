// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/internetStatusSingleton.dart';

class InternetStatusWidget extends StatefulWidget {
  @override
  _InternetStatusWidgetState createState() => _InternetStatusWidgetState();
}

class _InternetStatusWidgetState extends State<InternetStatusWidget> {
  StreamSubscription internetConnectionChangeStream;
  bool internetStatusVisbility = false;

  void checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          internetStatusVisbility = false;
        });
      } else {
        setState(() {
          internetStatusVisbility = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        internetStatusVisbility = true;
      });
    }
  }

  void connectionChanged(dynamic hasConnection) {
    if (!hasConnection) {
      setState(() {
        internetStatusVisbility = true;
      });
    } else {
      setState(() {
        internetStatusVisbility = false;
      });
    }
  }

  @override
  initState() {
    InternetStatusSingleton connectionStatus =
        InternetStatusSingleton.getInstance();
    internetConnectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    checkInternet();
    super.initState();
  }

  @override
  void dispose() {
    internetConnectionChangeStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: internetStatusVisbility,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              color: redColor,
              child: Text(
                internetStatusString,
                style: snackbarTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
