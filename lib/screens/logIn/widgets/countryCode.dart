// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/constants/countryCodes.dart';

class CountryCodeWidget extends StatelessWidget {
  final controller;
  CountryCodeWidget(this.controller);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Card(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
              child: Text(
                selectCountryCodeString,
                style: hintTextStyle,
              ),
            ),
            StreamBuilder<String>(
                stream: controller.dialCodeStream,
                initialData: "",
                builder: (context, snapshot) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:
                              snapshot.data == "" ? whiteColor : secondaryColor,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '${snapshot.data}',
                        style: textStyle,
                      ),
                    ),
                  );
                }),
            Container(
              color: secondaryColor,
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: textColor,
                ),
                onPressed: () => countryCodeDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  countryCodeDialog(BuildContext context) {
    setCountryCode(String dialCode) {
      controller.dialCodeSink.add(
        dialCode,
      );
      Navigator.pop(context);
    }

    ListTile countryCodeListTile(int index) {
      return ListTile(
        title: Text(
          countryCodes[index]['dial_code'] + " " + countryCodes[index]['name'],
          style: textStyle,
        ),
        onTap: () => setCountryCode(
          countryCodes[index]["dial_code"],
        ),
      );
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          backgroundColor: secondaryColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                color: secondaryColorDark,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      countryCodesString,
                      style: appBarTitleStyle,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: textColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: countryCodes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return countryCodeListTile(index);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
