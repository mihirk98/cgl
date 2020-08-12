import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/screens/family/controller.dart';
import 'package:flutter/material.dart';

showExitConfirmationDialog(
    final controller, String family, String user, BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () => null,
        child: Dialog(
          child: Container(
            color: secondaryColor,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                  color: secondaryColorDark,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Center(
                        child: Text(
                          exitFamilyString,
                          style: appBarTitleStyle,
                        ),
                      ),
                      Center(
                        child: StreamBuilder<Object>(
                            stream: controller.backUpVisibilityStream,
                            initialData: false,
                            builder: (context, snapshot) {
                              if (snapshot.data) {
                                return IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: secondaryColorDark,
                                  ),
                                  onPressed: () {},
                                );
                              } else {
                                return IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: textColor,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamBuilder<bool>(
                          stream: controller.backUpStatusStream,
                          initialData: false,
                          builder: (context, snapshot) {
                            if (snapshot.data) {
                              return Text(
                                listBackedUpString,
                                maxLines: 5,
                                style: appBarTitleStyle,
                              );
                            } else {
                              return StreamBuilder<bool>(
                                stream: controller.backUpVisibilityStream,
                                initialData: false,
                                builder: (context, snapshot) {
                                  if (snapshot.data) {
                                    return Text(
                                      listBackingUpString,
                                      maxLines: 5,
                                      style: itemTextStyle,
                                    );
                                  } else {
                                    return Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              listBackUpString,
                                              maxLines: 10,
                                              style: itemTextStyle,
                                            ),
                                          ),
                                        ),
                                        RaisedButton(
                                          color: secondaryColorLight,
                                          onPressed: () => backUpItemsFunc(
                                              family, user, context),
                                          child: Icon(
                                            Icons.backup,
                                            color: textColor,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: secondaryColorLight,
                  child: StreamBuilder<Object>(
                      stream: controller.backUpVisibilityStream,
                      initialData: false,
                      builder: (context, snapshot) {
                        if (snapshot.data) {
                          return Container();
                        } else {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 8.0, 8.0, 16.0),
                                child: Text(
                                  exitFamilyConfirmationString,
                                  style: itemTextStyle,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    child: FlatButton(
                                      color: redColor,
                                      padding: EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      child: Text(
                                        noString,
                                        style: textStyle,
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      color: primaryColorDark,
                                      padding: EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      child: Text(
                                        yesString,
                                        style: textStyle,
                                      ),
                                      onPressed: () =>
                                          exitFamilyFunc(family, user, context),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
