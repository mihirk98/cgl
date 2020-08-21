// Flutter imports:

import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/widgets/actionStatus.dart';
import 'package:cgl/widgets/homeDrawer.dart';

import 'package:cgl/widgets/internetStatus.dart';
import 'package:cgl/widgets/progressIndicator.dart';
import 'package:cgl/models/item.dart';
import 'package:cgl/models/user.dart';
import 'package:cgl/providers/userProvider.dart';
import 'package:cgl/screens/family/page.dart';
import 'package:cgl/screens/home/controller.dart';
import 'package:cgl/screens/home/dialogs/familyNotifyDialog.dart';
import 'package:cgl/screens/home/widgets/addItem.dart';
import 'package:cgl/screens/home/widgets/items.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    User userProvider = UserProvider.of(context);
    String family = userProvider.document;
    return WillPopScope(
      onWillPop: () => null,
      child: Scaffold(
        backgroundColor: backgroundColor,
        drawer: HomeDrawer(userProvider),
        appBar: AppBar(
          title: Text(
            appTitleString,
            style: appBarTitleStyle,
          ),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return FamilyNotifyDialog(
                      mobileNumber: userProvider.countryCode +
                          "-" +
                          userProvider.mobileNumber,
                      family: userProvider.document,
                    );
                  },
                );
              },
              icon: Icon(
                Icons.notifications,
                color: textColor,
              ),
            ),
            FutureBuilder(
              future: getCheckedVisibility(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container();
                  default:
                    bool checkedVisibilityValue;
                    if (snapshot.data) {
                      checkedVisibilityValue = true;
                    } else {
                      checkedVisibilityValue = true;
                    }
                    return IconButton(
                      onPressed: () {
                        if (checkedVisibilityValue) {
                          checkedVisibilityValue = false;
                        } else {
                          checkedVisibilityValue = true;
                        }
                        setCheckedVisibility(checkedVisibilityValue);
                        controller.checkedVisibilitySink
                            .add(checkedVisibilityValue);
                      },
                      icon: Icon(
                        Icons.minimize,
                        color: textColor,
                      ),
                    );
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ActionStatusWidget(),
              ItemsWidget(family: family, controller: controller),
              AddItemWidget(controller: controller),
              InternetStatusWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
