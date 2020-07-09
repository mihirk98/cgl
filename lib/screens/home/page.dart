// Flutter imports:
import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/misc/progressIndicator.dart';
import 'package:cgl/models/item.dart';
import 'package:cgl/models/user.dart';
import 'package:cgl/providers/userProvider.dart';
import 'package:cgl/screens/home/widgets/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User userProvider = UserProvider.of(context);
    String family = userProvider.document;
    return WillPopScope(
      onWillPop: () => null,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            appTitleString,
            style: appBarTitleStyle,
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              ItemsWidget(family: family),
            ],
          ),
        ),
      ),
    );
  }
}

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

  Column buildItemsList(List<Item> items, List<Item> checkedItems) {
    return Column(
      children: <Widget>[
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (_, index) {
            return ItemWidget(
                status: false, index: index, name: items[index].name);
          },
        ),
        checkedItems.length == 0
            ? Container()
            : Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Checked",
                    style: titleTextStyle,
                  ),
                ),
              ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: checkedItems.length,
          itemBuilder: (_, index) {
            return ItemWidget(
                status: true, index: index, name: checkedItems[index].name);
          },
        ),
      ],
    );
  }
}
