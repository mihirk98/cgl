// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cgl/models/user.dart';

class UserProvider extends InheritedWidget {
  final User user;

  UserProvider({
    Key key,
    @required Widget child,
    @required this.user,
  }) : super(key: key, child: child);

  static User of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<UserProvider>()).user;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
