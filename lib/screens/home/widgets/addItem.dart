import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/models/item.dart';
import 'package:cgl/screens/home/dialogs/quantityDialog.dart';
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
  FocusNode addItemFocus = new FocusNode();
  int quantity = 1;
  String unit = "unit/s";
  List<Item> allItems = [];

  OverlayEntry allItemsOverlayEntry;
  final LayerLink allItemsLayerLink = LayerLink();

  OverlayEntry createAllItemsOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
        builder: (context) => Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: this.allItemsLayerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                child: Material(
                  elevation: 4.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: allItems.length,
                    itemBuilder: (_, index) {
                      if (allItems.length == 0)
                        return Text("Hi");
                      else
                        return Text(allItems[index].name);
                    },
                  ),
                ),
              ),
            ));
  }

  @override
  void initState() {
    addItemFocus.addListener(addItemFocusListener);
    controller.allItemsStream.listen((updatedAllItems) {
      setState(() {
        allItems = updatedAllItems;
      });
    });
    controller.unitStream.listen((updatedUnit) {
      setState(() {
        unit = updatedUnit;
      });
    });
    super.initState();
  }

  void addItemFocusListener() {
    if (addItemFocus.hasFocus) {
      this.allItemsOverlayEntry = this.createAllItemsOverlayEntry();
      Overlay.of(context).insert(this.allItemsOverlayEntry);
    } else {
      this.allItemsOverlayEntry.remove();
    }
  }

  @override
  void dispose() {
    addItemController.dispose();
    addItemFocus.dispose();
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
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: TextField(
                controller: addItemController,
                focusNode: addItemFocus,
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
