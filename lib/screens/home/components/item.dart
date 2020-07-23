import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/models/item.dart';
import 'package:cgl/screens/home/dialogs/itemMenuDialog.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final bool status;
  final String name, family, unit;
  final int quantity;
  ItemWidget(this.status, this.name, this.quantity, this.unit, this.family);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showItemMenuDialog(context, name, quantity, family, status, unit);
      },
      child: Container(
        color: status ? backgroundColor : whiteColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          style: status
                              ? itemTextStyle.apply(
                                  decoration: TextDecoration.lineThrough,
                                )
                              : itemTextStyle,
                        ),
                      ),
                    ),
                    Text(
                      " x" + quantity.toString(),
                      style: hintTextStyle,
                    ),
                    unit == 'unit/s'
                        ? Container()
                        : Text(
                            " " + unit,
                            style: hintTextStyle,
                          ),
                  ],
                ),
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
      ),
    );
  }
}

showItemMenuDialog(BuildContext context, String name, int quantity,
    String family, bool status, String unit) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ItemMenuDialog(
          name: name,
          quantity: quantity,
          family: family,
          status: status,
          unit: unit);
    },
  );
}
