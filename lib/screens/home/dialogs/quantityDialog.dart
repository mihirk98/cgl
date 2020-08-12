import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/quantityShortcuts.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/constants/units.dart';
import 'package:flutter/material.dart';

class QuantityDialog extends StatefulWidget {
  const QuantityDialog(
      {Key key,
      @required this.controller,
      @required this.quantity,
      @required this.unit})
      : super(key: key);

  final controller;
  final int quantity;
  final String unit;
  @override
  _QuantityDialogState createState() =>
      _QuantityDialogState(controller, quantity, unit);
}

class _QuantityDialogState extends State<QuantityDialog> {
  final controller;
  final int quantity;
  final String unit;
  _QuantityDialogState(this.controller, this.quantity, this.unit);
  String selectedUnit;
  double quantityValue;
  int quantityValueInt;
  final quantityShortcutKey = new GlobalKey();

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
    super.initState();
  }

  quantityShortcutClick(int quantity) {
    setState(() {
      quantityValue = quantity.toDouble();
      quantityValueInt = quantity;
    });
    Scrollable.ensureVisible(quantityShortcutKey.currentContext);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: secondaryColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
              color: secondaryColorDark,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    quantityString,
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  Container(
                    key: quantityShortcutKey,
                    width: MediaQuery.of(context).size.width * 0.2,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.fromLTRB(4, 16, 4, 4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(
                        color: primaryColor,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      'x' + '$quantityValueInt',
                      maxLines: 2,
                      style: textStyle.apply(
                        color: whiteColor,
                      ),
                    ),
                  ),
                  for (int quantity in quantityShortcutList)
                    GestureDetector(
                      onTap: () => quantityShortcutClick(quantity),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.fromLTRB(4, 16, 4, 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: secondaryColorLight,
                          border: Border.all(
                            color: secondaryColorLight,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          'x' + quantity.toString(),
                          maxLines: 2,
                          style: textStyle.apply(
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Row(
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
                            right:
                                BorderSide(width: 0.25, color: hintTextColor),
                            top: BorderSide(width: 0.25, color: hintTextColor),
                            bottom:
                                BorderSide(width: 0.25, color: hintTextColor),
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
                            left: BorderSide(width: 0.25, color: hintTextColor),
                            top: BorderSide(width: 0.25, color: hintTextColor),
                            bottom:
                                BorderSide(width: 0.25, color: hintTextColor),
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
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: secondaryColorLight,
                border: Border(
                  bottom: BorderSide(width: 0.25, color: hintTextColor),
                ),
              ),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: primaryColor,
                  inactiveTrackColor: primaryColorLight,
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 4.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: primaryColorDark,
                  overlayColor: primaryColor,
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
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
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: secondaryColorLight,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: unitsList
                        .map((unit) => RadioListTile(
                              title: Text(
                                unit,
                                style: textStyle,
                              ),
                              groupValue: selectedUnit,
                              value: unit,
                              onChanged: (selectedUnitVal) {
                                setState(() {
                                  selectedUnit = selectedUnitVal;
                                });
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    color: primaryColorDark,
                    onPressed: () {
                      controller.quantitySink.add(quantityValueInt);
                      controller.unitSink.add(selectedUnit);
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
          ],
        ),
      ),
    );
  }
}
