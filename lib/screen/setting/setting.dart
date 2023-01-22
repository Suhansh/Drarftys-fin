import '/screen/login_screen.dart';
import '/util/constants.dart';
import '/util/preference_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'privacy/privacy.dart';
import 'notification_setting/notificationsetting.dart';
import 'app_language/applanguge.dart';
import 'terms_of_use/termsofuse.dart';
import 'privacy_policy/privacypolicy.dart';
import 'about.dart';
import 'report_problem/reportproblem.dart';

class SettingsScreen extends StatefulWidget {
  final userId;
  const SettingsScreen({Key? key, this.userId}) : super(key: key);

  @override
  _SettingsScreen createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title:
                  Container(margin: const EdgeInsets.only(left: 10), child: const Text("Settings")),
              centerTitle: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: true,
            ),
            backgroundColor: Color(Constants.bgblack),
            resizeToAvoidBottomInset: true,

            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewportConstraints) {
                return Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 0, right: 10),
                        color: Colors.transparent,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                              height: ScreenUtil().setHeight(45),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const PrivacyScreen()));
                                },
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset("images/security.svg"),
                                    Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        "Privacy",
                                        style: TextStyle(
                                            color: Color(Constants.whitetext),
                                            fontSize: 18,
                                            fontFamily: Constants.appFont),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                              height: ScreenUtil().setHeight(45),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const NotificationSettingScreen()));
                                },
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset("images/notification_white.svg"),
                                    Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        "Notification",
                                        style: TextStyle(
                                            color: Color(Constants.whitetext),
                                            fontSize: 18,
                                            fontFamily: Constants.appFont),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                              height: ScreenUtil().setHeight(45),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const AppLanguageScreen()));
                                },
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset("images/translation.svg"),
                                    Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        "App Language",
                                        style: TextStyle(
                                            color: Color(Constants.whitetext),
                                            fontSize: 18,
                                            fontFamily: Constants.appFont),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                              height: ScreenUtil().setHeight(45),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const TermsOfUseScreen()));
                                },
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset("images/accept.svg"),
                                    Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        "Terms of Use",
                                        style: TextStyle(
                                            color: Color(Constants.whitetext),
                                            fontSize: 18,
                                            fontFamily: Constants.appFont),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                              height: ScreenUtil().setHeight(45),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const PrivacyPolicyScreen()));
                                },
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset("images/policy.svg"),
                                    Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        "Policy",
                                        style: TextStyle(
                                            color: Color(Constants.whitetext),
                                            fontSize: 18,
                                            fontFamily: Constants.appFont),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                              height: ScreenUtil().setHeight(45),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const AboutScreen()));
                                },
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset("images/about.svg"),
                                    Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        "About",
                                        style: TextStyle(
                                            color: Color(Constants.whitetext),
                                            fontSize: 18,
                                            fontFamily: Constants.appFont),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                              height: ScreenUtil().setHeight(45),
                              child: InkWell(
                                onTap: () {
                                  if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => ReportProblemScreen(
                                              userId: widget.userId,
                                            )));
                                  } else {
                                    Constants.toastMessage("Please! Login To Enter");
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset("images/report.svg"),
                                    Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        "Report a Problem",
                                        style: TextStyle(
                                            color: Color(Constants.whitetext),
                                            fontSize: 18,
                                            fontFamily: Constants.appFont),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                              height: ScreenUtil().setHeight(45),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Are you sure?'),
                                      content: const Text('Do you want Logout?'),
                                      actions: <Widget>[
                                        IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            icon: const Text("NO")),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => const LoginScreen()),
                                                  (route) => false);
                                              PreferenceUtils.setBool(
                                                  Constants.isLoggedIn, false);
                                              PreferenceUtils.clear();
                                            },
                                            icon: const Text("YES"))
                                      ],
                                    ),
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset("images/logout.svg"),
                                    Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        "Logout",
                                        style: TextStyle(
                                            color: Color(Constants.whitetext),
                                            fontSize: 18,
                                            fontFamily: Constants.appFont),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // new Container(child: Body())
                  ],
                );
              },
            )),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}
