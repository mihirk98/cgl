// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cgl/actionStatusSingleton.dart';
import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/styles.dart';

class ActionStatusWidget extends StatefulWidget {
  @override
  _ActionStatusWidgetState createState() => _ActionStatusWidgetState();
}

class _ActionStatusWidgetState extends State<ActionStatusWidget> {
  bool actionVisbility = false;
  String actionDescription = "";

  @override
  initState() {
    ActionStatusSingleton actionStatus = ActionStatusSingleton.getInstance();
    actionStatus.actionVisibilityStream.listen((updatedVisbility) {
      if (updatedVisbility) {
        setState(() {
          actionVisbility = true;
        });
      } else {
        setState(() {
          actionVisbility = false;
        });
      }
    });
    actionStatus.descriptionStream.listen((updatedActionDescription) {
      setState(() {
        actionDescription = updatedActionDescription;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: actionVisbility,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              color: textColor,
              child: Text(
                actionDescription,
                maxLines: 10,
                style: snackbarTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
