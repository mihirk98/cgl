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
  final addItemFocusNode = new FocusNode();
  String addItemText = "";
  int quantity = 1;
  String unit = "unit/s";
  List<Item> allItems = [];
  OverlayState overlayState;
  OverlayEntry overlayEntry;
  bool overlayStatus = false;
  final LayerLink textFieldLayerLink = LayerLink();
  GlobalKey textFieldKey = GlobalKey();

  bool containsCaseInsensitive(String name) {
    if (name.contains(addItemText))
      return true;
    else if (name.toLowerCase().contains(addItemText))
      return true;
    else if (name.contains(addItemText.toLowerCase()))
      return true;
    else if (name.toLowerCase().contains(addItemText.toLowerCase()))
      return true;
    return false;
  }

  String capitalItem(String item) {
    var itemBuffer = new StringBuffer();
    for (int i = 0; i < item.length; i++) {
      if (i == 0) {
        itemBuffer.write(item[i].toUpperCase());
      } else if (item[i - 1] == " ") {
        itemBuffer.write(item[i].toUpperCase());
      } else {
        itemBuffer.write(item[i]);
      }
    }
    return itemBuffer.toString();
  }

  createOverlay(BuildContext context) {
    RenderBox renderBox = textFieldKey.currentContext.findRenderObject();
    var size = renderBox.size;
    double height = MediaQuery.of(context).size.height * 0.2;
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        height: height,
        child: CompositedTransformFollower(
          link: textFieldLayerLink,
          offset: Offset(0.0, -(height + 6)),
          child: Material(
            color: secondaryColor,
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: allItems.length,
              itemBuilder: (_, index) {
                return containsCaseInsensitive(allItems[index].name)
                    ? ListTile(
                        title: Text(
                          allItems[index].name,
                          style: itemTextStyle.apply(
                            color: whiteColor,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            addItemController.text = allItems[index].name;
                          });
                          overlayStatus = false;
                          overlayEntry.remove();
                        },
                      )
                    : Container();
              },
              separatorBuilder: (BuildContext context, int index) {
                return containsCaseInsensitive(allItems[index].name)
                    ? Container(
                        height: 0.5,
                        width: MediaQuery.of(context).size.width * 0.95,
                        color: hintTextColor,
                      )
                    : Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    addItemController.addListener(addItemTextListener);
    addItemFocusNode.addListener(addItemFocusListener);
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
    WidgetsBinding.instance.addPostFrameCallback((_) => createOverlay(context));
    super.initState();
  }

  void addItemFocusListener() {
    if (allItems.length != 0) {
      if (addItemFocusNode.hasFocus) {
        overlayStatus = true;
        overlayState.insert(overlayEntry);
      } else if (overlayStatus) {
        overlayStatus = false;
        overlayEntry.remove();
      }
    }
  }

  void addItemTextListener() {
    if (allItems.length != 0) {
      if (addItemText != addItemController.text) {
        addItemText = addItemController.text;
        if (overlayStatus) {
          overlayStatus = false;
          overlayEntry.remove();
        }
        for (Item item in allItems) {
          if (containsCaseInsensitive(item.name)) {
            overlayStatus = true;
            overlayState.insert(overlayEntry);
            break;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    addItemController.dispose();
    addItemFocusNode.dispose();
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
              child: CompositedTransformTarget(
                link: textFieldLayerLink,
                child: TextField(
                  key: textFieldKey,
                  controller: addItemController,
                  focusNode: addItemFocusNode,
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
                      addItem(context, capitalItem(addItemController.text),
                          quantity, unit);
                      addItemController.text = "";
                    },
                  ),
                  FocusScope.of(context).unfocus(),
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
