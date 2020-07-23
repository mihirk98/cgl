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
    return Card(
      margin: EdgeInsets.fromLTRB(8, 8, 8, 16),
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Center(
                  child: Text(
                    quantityString,
                    style: appBarTitleStyle,
                  ),
                ),
                Center(
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
              ],
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
                          color: whiteColor,
                          border: Border.all(
                            color: primaryColor,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          'x' + quantity.toString(),
                          maxLines: 2,
                          style: textStyle.apply(
                            color: primaryColor,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            Container(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: primaryColor,
                  inactiveTrackColor: primaryColorLight,
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 4.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: secondaryColor,
                  overlayColor: secondaryColorLight,
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
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: () {
                  controller.quantitySink.add(quantityValueInt);
                  controller.unitSink.add(selectedUnit);
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Save",
                  style: itemTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
