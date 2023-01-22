import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/util/constants.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreen createState() => _AboutScreen();
}

class _AboutScreen extends State<AboutScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          backgroundColor: Color(Constants.bgblack),
          appBar: AppBar(
            title: Container(
                margin: const EdgeInsets.only(left: 0), child: const Text("About")),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: true,
          ),
          body: Container(
            margin: const EdgeInsets.only(
                left: 15, right: 15, top: 0, bottom: 60),
            child: Center(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height:
                      MediaQuery.of(context).size.height * 0.75,
                  alignment: Alignment.center,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Container(
                        margin:
                            const EdgeInsets.only(top: 10, bottom: 10),
                        child: SvgPicture.asset(
                          "images/main_logo.svg",
                          width: ScreenUtil().setWidth(80),
                          height: ScreenUtil().setHeight(80),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10),
                          child: SvgPicture.asset(
                            "images/app_name_text.svg",
                            width: ScreenUtil().setWidth(30),
                            height: ScreenUtil().setHeight(30),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "App Version 2.0.0",
                          maxLines: 1,
                          style: TextStyle(
                              color: Color(Constants.greytext),
                              fontFamily: Constants.appFont,
                              fontSize: 14),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Copyright © 2021 Acoustic. All Rights Reserved",
                            style: TextStyle(
                                color: Color(Constants.greytext),
                                fontFamily: Constants.appFont,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          )),
    );
  }

}
