import 'package:flutter/material.dart';
import '/util/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLanguageScreen extends StatefulWidget {
  const AppLanguageScreen({Key? key}) : super(key: key);

  @override
  _AppLanguageScreen createState() => _AppLanguageScreen();
}

class _AppLanguageScreen extends State<AppLanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Container(
                margin: const EdgeInsets.only(left: 0), child: const Text("App Language")),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: true,
          ),
          backgroundColor: Color(Constants.bgblack),
          resizeToAvoidBottomInset: true,
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: ScreenUtil().setHeight(80),
                      margin: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15, bottom: 0),
                      child: Text(
                        "Coming Soon...",
                        style: TextStyle(
                            color: Colors.white, fontFamily: Constants.appFont, fontSize: 20),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }
}
