import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/widgets/progressIndicator.dart';
import 'package:cgl/models/item.dart';
import 'package:cgl/screens/home/components/item.dart';
import 'package:cgl/screens/home/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemsWidget extends StatelessWidget {
  const ItemsWidget({
    Key key,
    @required this.family,
    @required this.controller,
  }) : super(key: key);

  final String family;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection("lists")
            .document(family)
            .collection("items")
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Item> items = [];
          List<Item> checkedItems = [];
          List<Item> allItems = [];
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return showProgressIndicator();
            default:
              for (var itemData in snapshot.data.documents) {
                Item item = Item(
                  itemData.documentID,
                  itemData["date"],
                  itemData["status"],
                  itemData["quantity"],
                  itemData["unit"],
                );
                if (item.status == 0) {
                  items.add(item);
                } else if (item.status == 1) {
                  checkedItems.add(item);
                }
                allItems.add(item);
              }
              //Adding All Items to controller
              controller.allItemsSink.add(allItems);
              if (items.length == 0 && checkedItems.length == 0) {
                return Center(
                  child: Text(
                    noItemsString,
                    style: subTitleTextStyle,
                  ),
                );
              }
              return buildItemsList(items, checkedItems);
          }
        },
      ),
    );
  }

  SingleChildScrollView buildItemsList(
      List<Item> items, List<Item> checkedItems) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (_, index) {
              return ItemWidget(
                false,
                items[index].name,
                items[index].quantity,
                items[index].unit,
                family,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 0.5,
                width: MediaQuery.of(context).size.width * 0.95,
                color: hintTextColor,
              );
            },
          ),
          FutureBuilder(
            future: getCheckedVisibility(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container();
                default:
                  return StreamBuilder<Object>(
                    stream: controller.checkedVisibilityStream,
                    initialData: snapshot.data,
                    builder: (context, snapshot) {
                      if (snapshot.data) {
                        if (checkedItems.length == 0) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                noCheckedItems,
                                style: subTitleTextStyle,
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: <Widget>[
                            checkedItems.length == 0
                                ? Container()
                                : Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 20, 16, 16),
                                      child: Text(
                                        checkedString,
                                        style: titleTextStyle,
                                      ),
                                    ),
                                  ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: checkedItems.length,
                              itemBuilder: (_, index) {
                                return ItemWidget(
                                  true,
                                  checkedItems[index].name,
                                  checkedItems[index].quantity,
                                  checkedItems[index].unit,
                                  family,
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              checkedItemsHiddenString,
                              style: subTitleTextStyle,
                            ),
                          ),
                        );
                      }
                    },
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
