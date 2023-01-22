import 'package:flutter/material.dart';
import '/util/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedCornerAppButton extends StatelessWidget {
  const RoundedCornerAppButton(
      {Key? key, required this.btnLabel, required this.onPressed})
      : super(key: key);
  final btnLabel;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5.0,
        primary: Color(Constants.buttonbg),
        textStyle: const TextStyle(color: Colors.white),
      ),
      child: Container(
        height: ScreenUtil().setHeight(50),
        alignment: Alignment.center,
        child: Text(
          btnLabel,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: Constants.appFont,
              fontWeight: FontWeight.w900,
              fontSize: 16.0),
        ),
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}
