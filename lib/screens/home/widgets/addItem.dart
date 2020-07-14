import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/constants/units.dart';
import 'package:cgl/models/item.dart';
import 'package:flutter/material.dart';

class AddItemWidget extends StatefulWidget {
  const AddItemWidget({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final controller;

  @override
  _AddItemWidgetState createState() => _AddItemWidgetState(controller);
}

class _AddItemWidgetState extends State<AddItemWidget> {
  final controller;
  _AddItemWidgetState(this.controller);
  final addItemController = TextEditingController();
  int quantity = 1;
  String unit = "unit/s";

  @override
  void initState() {
    controller.unitStream.listen((updatedUnit) {
      setState(() {
        unit = updatedUnit;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    addItemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      color: secondaryColorLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: TextField(
                controller: addItemController,
                keyboardType: TextInputType.text,
                style: textStyle,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
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
          GestureDetector(
            onTap: () =>
                showQuantityDialog(context, controller, quantity, unit),
            child: FractionallySizedBox(
              heightFactor: 1,
              child: Container(
                color: whiteColor,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                      child: Text(
                        "x",
                        style: textStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder<Object>(
                          initialData: 1,
                          stream: controller.quantityStream,
                          builder: (context, snapshot) {
                            quantity = snapshot.data;
                            return Text(
                              snapshot.data.toString(),
                              style: textStyle,
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            heightFactor: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              color: primaryColorLight,
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: textColor,
                ),
                onPressed: () => {
                  setState(
                    () {
                      addItem(context, addItemController.text, quantity, unit);
                      addItemController.text = "";
                    },
                  ),
                  controller.quantitySink.add(1),
                  controller.unitSink.add("unit/s"),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  showQuantityDialog(
      BuildContext context, final controller, int quantity, String unit) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return QuantityDialog(
            controller: controller, quantity: quantity, unit: unit);
      },
    );
  }
}

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

  @override
  void initState() {
    selectedUnit = unit;
    quantityValue = quantity.toDouble();
    quantityValueInt = quantity;
    super.initState();
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
                    "Quantity",
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
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
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
                style: textStyle.apply(
                  color: whiteColor,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (quantityValue.toInt() > 1) {
                          quantityValue =
                              (quantityValue.toInt() - 1).toDouble();
                          quantityValueInt = quantityValue.toInt();
                        }
                      });
                    },
                    icon: Icon(
                      Icons.remove,
                      color: textColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (quantityValue.toInt() <= 999) {
                          quantityValue =
                              (quantityValue.toInt() + 1).toDouble();
                          quantityValueInt = quantityValue.toInt();
                        }
                      });
                    },
                    icon: Icon(
                      Icons.add,
                      color: textColor,
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
                  divisions: 100,
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
