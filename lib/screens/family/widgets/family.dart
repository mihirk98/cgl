import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/screens/family/controller.dart';
import 'package:flutter/material.dart';

class FamilyWidget extends StatelessWidget {
  const FamilyWidget({
    Key key,
    @required this.family,
    @required this.mobileNumber,
  }) : super(key: key);

  final String family, mobileNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Card(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
              child: Text(
                family,
                style: itemTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: redColor,
                ),
                onPressed: () async =>
                    exitFamilyFunc(family, mobileNumber, context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
