import 'package:flutter/material.dart';
import '/util/constants.dart';

class ApplicationToolbar extends StatelessWidget with PreferredSizeWidget {
  ApplicationToolbar({Key? key, required this.appbarTitle}) : super(key: key);
  final String appbarTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Text(
        appbarTitle,
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: Constants.appFont),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
