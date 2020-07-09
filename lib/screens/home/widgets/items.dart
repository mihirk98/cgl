import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/misc/progressIndicator.dart';
import 'package:cgl/models/item.dart';
import 'package:cgl/screens/home/components/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemsWidget extends StatelessWidget {
  const ItemsWidget({
    Key key,
    @required this.family,
  }) : super(key: key);

  final String family;

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
                );
                if (item.status == 0) {
                  items.add(item);
                } else {
                  checkedItems.add(item);
                }
              }
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
                status: false,
                index: index,
                name: items[index].name,
                quantity: items[index].quantity,
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
          checkedItems.length == 0
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Text(
                        "Checked",
                        style: titleTextStyle,
                      ),
                    ),
                    Container(
                      color: whiteColor,
                      child: IconButton(
                        icon: Icon(
                          Icons.minimize,
                          color: hintTextColor,
                        ),
                        onPressed: () => null,
                      ),
                    ),
                  ],
                ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: checkedItems.length,
            itemBuilder: (_, index) {
              return ItemWidget(
                status: true,
                index: index,
                name: checkedItems[index].name,
                quantity: checkedItems[index].quantity,
              );
            },
          ),
        ],
      ),
    );
  }
}
