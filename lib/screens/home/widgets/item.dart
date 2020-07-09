import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/styles.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    @required this.status,
    @required this.index,
    @required this.name,
    Key key,
  }) : super(key: key);

  final bool status;
  final int index;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: hintTextColor,
          ),
          top: BorderSide(
            width: index == 1 ? 0 : 0.5,
            color: hintTextColor,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              name,
              style: itemTextStyle,
            ),
            Theme(
              data: ThemeData(unselectedWidgetColor: secondaryColorDark),
              child: Checkbox(
                activeColor: secondaryColorLight,
                onChanged: (bool value) {},
                value: status,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
