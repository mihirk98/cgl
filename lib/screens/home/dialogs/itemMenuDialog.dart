import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/quantityShortcuts.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/constants/units.dart';
import 'package:cgl/models/item.dart';
import 'package:flutter/material.dart';

class ItemMenuDialog extends StatefulWidget {
  final String name, family, unit;
  final int quantity;
  final bool status;
  const ItemMenuDialog(
      {Key key,
      @required this.name,
      @required this.quantity,
      @required this.family,
      @required this.status,
      @required this.unit})
      : super(key: key);
  @override
  _ItemMenuDialogState createState() =>
      _ItemMenuDialogState(name, quantity, family, status, unit);
}

class _ItemMenuDialogState extends State<ItemMenuDialog> {
  final String name, family, unit;
  final int quantity;
  final bool status;
  _ItemMenuDialogState(
      this.name, this.quantity, this.family, this.status, this.unit);
  String selectedUnit;
  TextEditingController nameController = TextEditingController();
  double quantityValue;
  int quantityValueInt;

  bool addButtonPressed = false, minusButtonPressed;
  bool loopActive = false;

  void increaseQuantityWhilePressed() async {
    if (loopActive) return;
    loopActive = true;
    while (addButtonPressed) {
      setState(() {
        if (quantityValue.toInt() <= 999) {
          quantityValue = (quantityValue.toInt() + 1).toDouble();
          quantityValueInt = quantityValue.toInt();
        }
      });
      await Future.delayed(Duration(milliseconds: 200));
    }
    loopActive = false;
  }

  void decreaseQuantityWhilePressed() async {
    if (loopActive) return;
    loopActive = true;
    while (minusButtonPressed) {
      setState(() {
        if (quantityValue.toInt() > 1) {
          quantityValue = (quantityValue.toInt() - 1).toDouble();
          quantityValueInt = quantityValue.toInt();
        }
      });
      await Future.delayed(Duration(milliseconds: 200));
    }
    loopActive = false;
  }

  @override
  void initState() {
    selectedUnit = unit;
    quantityValue = quantity.toDouble();
    quantityValueInt = quantity;
    nameController.text = name;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.7,
        child: Material(
          color: secondaryColor,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                color: secondaryColorDark,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      editItemString,
                      style: appBarTitleStyle,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: textColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          color: hintTextColor.withOpacity(0.8),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Material(
                            color: transparentColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  color: transparentColor,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.all(8),
                                    child: TextField(
                                      autofocus: true,
                                      controller: nameController,
                                      maxLines: 5,
                                      keyboardType: TextInputType.text,
                                      style: textStyle,
                                      decoration: InputDecoration(
                                        fillColor: secondaryColorLight,
                                        filled: true,
                                        contentPadding: EdgeInsets.all(20),
                                        hintText: addItemString,
                                        hintStyle: hintTextStyle,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                            color: secondaryColorLight,
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                            color: secondaryColorLight,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "Tap anywhere outside the box\nwhen done editing",
                                    style: appBarTitleStyle.apply(
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: secondaryColorLight,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(width: 1, color: secondaryColorLight),
                  ),
                  child: Text(
                    nameController.text,
                    style: textStyle,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      width: 0.25, color: hintTextColor),
                                  top: BorderSide(
                                      width: 0.25, color: hintTextColor),
                                ),
                              ),
                              child: FlatButton(
                                padding: EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                color: primaryColor,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: Container(
                                          color: secondaryColor,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: ListView.builder(
                                            itemCount:
                                                quantityShortcutList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                margin: index + 1 ==
                                                        quantityShortcutList
                                                            .length
                                                    ? EdgeInsets.all(0)
                                                    : EdgeInsets.fromLTRB(
                                                        0, 0, 0, 1),
                                                child: FlatButton(
                                                  color: primaryColorLight,
                                                  padding: EdgeInsets.all(16),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      quantityValue =
                                                          quantityShortcutList[
                                                                  index]
                                                              .toDouble();
                                                      quantityValueInt =
                                                          quantityValue.toInt();
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'x${quantityShortcutList[index]}',
                                                    maxLines: 2,
                                                    style: itemTextStyle,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  'x' + '$quantityValueInt',
                                  maxLines: 2,
                                  style: textStyle.apply(
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left:
                                      BorderSide(width: 0.25, color: textColor),
                                  top: BorderSide(
                                      width: 0.25, color: hintTextColor),
                                ),
                              ),
                              child: FlatButton(
                                padding: EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                color: primaryColor,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: Container(
                                          color: secondaryColor,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: ListView.builder(
                                            itemCount: unitsList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                margin: index + 1 ==
                                                        unitsList.length
                                                    ? EdgeInsets.all(0)
                                                    : EdgeInsets.fromLTRB(
                                                        0, 0, 0, 1),
                                                child: FlatButton(
                                                  color: primaryColorLight,
                                                  padding: EdgeInsets.all(16),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedUnit =
                                                          unitsList[index];
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    '${unitsList[index]}',
                                                    maxLines: 2,
                                                    style: itemTextStyle,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  selectedUnit,
                                  maxLines: 2,
                                  style: textStyle.apply(
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Listener(
                              onPointerDown: (_) {
                                minusButtonPressed = true;
                                decreaseQuantityWhilePressed();
                              },
                              onPointerUp: (_) {
                                minusButtonPressed = false;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: secondaryColorLight,
                                  border: Border(
                                    right: BorderSide(
                                        width: 0.25, color: hintTextColor),
                                    top: BorderSide(
                                        width: 0.25, color: hintTextColor),
                                    bottom: BorderSide(
                                        width: 0.25, color: hintTextColor),
                                  ),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Icon(
                                  Icons.remove,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Listener(
                              onPointerDown: (_) {
                                addButtonPressed = true;
                                increaseQuantityWhilePressed();
                              },
                              onPointerUp: (_) {
                                addButtonPressed = false;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: secondaryColorLight,
                                  border: Border(
                                    left: BorderSide(
                                        width: 0.25, color: hintTextColor),
                                    top: BorderSide(
                                        width: 0.25, color: hintTextColor),
                                    bottom: BorderSide(
                                        width: 0.25, color: hintTextColor),
                                  ),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Icon(
                                  Icons.add,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        color: secondaryColorLight,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: primaryColor,
                            inactiveTrackColor: primaryColorLight,
                            trackShape: RoundedRectSliderTrackShape(),
                            trackHeight: 4.0,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            thumbColor: primaryColorDark,
                            overlayColor: primaryColor,
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 28.0),
                            tickMarkShape: RoundSliderTickMarkShape(),
                            activeTickMarkColor: secondaryColor,
                            inactiveTickMarkColor: secondaryColorLight,
                          ),
                          child: Slider(
                            value: quantityValue,
                            min: 1,
                            max: 1000,
                            divisions: 200,
                            onChanged: (value) {
                              setState(
                                () {
                                  quantityValue = value.toInt().toDouble();
                                  quantityValueInt = quantityValue.toInt();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        color: redColor,
                        onPressed: () {
                          deleteItem(family, name);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          deleteString,
                          style: itemTextStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        color: primaryColorDark,
                        onPressed: () {
                          if (name == nameController.text) {
                            if (quantity != quantityValueInt ||
                                unit != selectedUnit) {
                              editQuantity(
                                  family, name, quantityValueInt, selectedUnit);
                            }
                          } else {
                            replaceItem(family, name, nameController.text,
                                quantityValueInt, status, selectedUnit);
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          saveString,
                          style: itemTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
