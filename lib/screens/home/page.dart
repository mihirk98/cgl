// Flutter imports:
import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/misc/progressIndicator.dart';
import 'package:cgl/models/item.dart';
import 'package:cgl/models/user.dart';
import 'package:cgl/providers/userProvider.dart';
import 'package:cgl/screens/home/components/item.dart';
import 'package:cgl/screens/home/widgets/addItem.dart';
import 'package:cgl/screens/home/widgets/items.dart';
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
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ItemsWidget(family: family),
              AddItemWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
