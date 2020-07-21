import 'package:cgl/models/family.dart';
import 'package:flutter/material.dart';

exitFamilyFunc(String family, String user, BuildContext context) async {
  int status = await exitFamily(family, user);
  switch (status) {
    case 2:
      print(status);
  }
}
