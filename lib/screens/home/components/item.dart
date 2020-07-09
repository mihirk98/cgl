import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/models/item.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    @required this.status,
    @required this.index,
    @required this.name,
    @required this.quantity,
    Key key,
  }) : super(key: key);

  final bool status;
  final int index;
  final String name;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: status ? backgroundColor : whiteColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  name,
                  style: status
                      ? itemTextStyle.apply(
                          decoration: TextDecoration.lineThrough,
                        )
                      : itemTextStyle,
                ),
                Text(
                  " x" + quantity.toString(),
                  style: hintTextStyle,
                ),
              ],
            ),
            Theme(
              data: ThemeData(unselectedWidgetColor: secondaryColorDark),
              child: Checkbox(
                activeColor: secondaryColorLight,
                onChanged: (bool value) {
                  setItemStatus(context, name, status);
                },
                value: status,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
