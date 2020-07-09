import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/models/item.dart';
import 'package:flutter/material.dart';

class AddItemWidget extends StatefulWidget {
  const AddItemWidget({
    Key key,
  }) : super(key: key);

  @override
  _AddItemWidgetState createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  final addItemController = TextEditingController();

  @override
  void dispose() {
    addItemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryColorLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4),
              child: TextField(
                controller: addItemController,
                keyboardType: TextInputType.text,
                style: textStyle,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(4),
                  hintText: addItemString,
                  hintStyle: hintTextStyle,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: hintTextColor,
                      width: 1,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: textColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            color: primaryColorLight,
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: textColor,
              ),
              onPressed: () => setState(() {
                addItem(context, addItemController.text);
                addItemController.text = "";
              }),
            ),
          ),
        ],
      ),
    );
  }
}
