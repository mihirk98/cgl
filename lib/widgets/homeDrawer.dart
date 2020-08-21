import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/models/item.dart';
import 'package:cgl/models/user.dart';
import 'package:cgl/providers/userProvider.dart';
import 'package:cgl/screens/family/page.dart';
import 'package:cgl/widgets/progressIndicator.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class HomeDrawer extends StatelessWidget {
  final User userProvider;
  HomeDrawer(this.userProvider);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          color: secondaryColor,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      trailing: Icon(
                        Icons.people,
                        color: textColor,
                      ),
                      title: Text(
                        familyString,
                        style: itemTextStyle,
                      ),
                      onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProvider(
                                user: User(
                                  userProvider.mobileNumber,
                                  userProvider.countryCode,
                                  userProvider.document,
                                  userProvider.token,
                                ),
                                child: FamilyPage()),
                          ),
                        ),
                      },
                    ),
                    ListTile(
                      trailing: Icon(
                        Icons.file_download,
                        color: textColor,
                      ),
                      title: Text(
                        downloadString,
                        style: itemTextStyle,
                      ),
                      onTap: () => {
                        showProgressIndicatorDialog(context),
                        getBackedUpItems(
                                userProvider.document,
                                userProvider.countryCode +
                                    "-" +
                                    userProvider.mobileNumber)
                            .then(
                          (_) => {
                            hideProgressIndicatorDialog(context),
                            Navigator.pop(context),
                          },
                        ),
                      },
                    ),
                    ListTile(
                      trailing: Icon(
                        Icons.close,
                        color: textColor,
                      ),
                      title: Text(
                        closeString,
                        style: itemTextStyle,
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  ListTile(
                    trailing: Icon(
                      Icons.share,
                      color: textColor,
                    ),
                    title: Text(
                      shareString,
                      style: itemTextStyle,
                    ),
                    onTap: () => Share.share(
                        appTitleString +
                            " " +
                            "(" +
                            appDescription +
                            ")" +
                            " - " +
                            'https://play.google.com/store/apps/details?id=cambio.mihirkathpalia.cgl',
                        subject: shareEmailSubjectString),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
