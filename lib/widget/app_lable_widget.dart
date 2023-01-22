import 'package:flutter/material.dart';
import '/util/constants.dart';

class AppLableWidget extends StatelessWidget {
  const AppLableWidget({Key? key, required this.title}) : super(key: key);
  final title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
      child: Text(
        title,
        style: Constants.kAppLabelWidget,
      ),
    );
  }
}
