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
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: textColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(8, 16, 8, 24),
                        padding: EdgeInsets.all(8),
                        child: TextField(
                          controller: nameController,
                          minLines: 1,
                          maxLines: 5,
                          keyboardType: TextInputType.text,
                          style: textStyle,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20),
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
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(8),
                                        itemCount: quantityShortcutList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Card(
                                            color: primaryColorLight,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              margin: const EdgeInsets.all(8),
                                              child: Center(
                                                child: FlatButton(
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
                            child: Card(
                              color: primaryColor,
                              elevation: 4,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.all(4),
                                alignment: Alignment.center,
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
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(8),
                                        itemCount: unitsList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Card(
                                            color: primaryColorLight,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              margin: const EdgeInsets.all(8),
                                              child: Center(
                                                child: FlatButton(
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
                            child: Card(
                              color: primaryColor,
                              elevation: 4,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.all(4),
                                alignment: Alignment.center,
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
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Listener(
                              onPointerDown: (_) {
                                minusButtonPressed = true;
                                decreaseQuantityWhilePressed();
                              },
                              onPointerUp: (_) {
                                minusButtonPressed = false;
                              },
                              child: Card(
                                color: secondaryColorLight,
                                elevation: 4,
                                child: Container(
                                  padding: EdgeInsets.all(32),
                                  child: Icon(
                                    Icons.remove,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                            Listener(
                              onPointerDown: (_) {
                                addButtonPressed = true;
                                increaseQuantityWhilePressed();
                              },
                              onPointerUp: (_) {
                                addButtonPressed = false;
                              },
                              child: Card(
                                color: secondaryColorLight,
                                elevation: 4,
                                child: Container(
                                  padding: EdgeInsets.all(32),
                                  child: Icon(
                                    Icons.add,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: primaryColor,
                            inactiveTrackColor: primaryColorLight,
                            trackShape: RoundedRectSliderTrackShape(),
                            trackHeight: 4.0,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            thumbColor: secondaryColor,
                            overlayColor: secondaryColorLight,
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
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 24, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      deleteItem(family, name);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Delete",
                      style: itemTextStyle.apply(color: redColor),
                    ),
                  ),
                  FlatButton(
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
                      "Save",
                      style: itemTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
