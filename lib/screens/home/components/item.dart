import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/misc/snackBar.dart';
import 'package:cgl/models/item.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final bool status;
  final String name;
  final int quantity;
  ItemWidget(this.status, this.name, this.quantity);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: itemMenu,
      offset: Offset(1, 0),
      onSelected: (selected) => {
        if (selected == 0)
          {
            increaseQuantity(context, name),
          }
        else if (selected == 1)
          {
            decreaseQuantity(context, name, quantity),
          }
        else if (selected == 2)
          {
            deleteItem(context, name),
            showSnackBar(context, itemDeletedString, 1),
          }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem(
          value: 0,
          child: Center(
            child: Icon(
              Icons.add,
              color: textColor,
            ),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Center(
            child: Icon(
              Icons.remove,
              color: textColor,
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Center(
            child: Text(
              'Delete',
              style: subTitleTextStyle.apply(color: redColor),
            ),
          ),
        ),
      ],
      child: Container(
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
      ),
    );
  }
}
