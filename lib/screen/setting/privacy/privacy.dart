import '/custom/loader_custom_widget.dart';
import '/screen/setting/privacy/privacy_provider.dart';
import '/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/screen/followandinvite.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '/screen/setting/privacy/blockeduser.dart';
import 'package:provider/provider.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyScreen createState() => _PrivacyScreen();
}

class _PrivacyScreen extends State<PrivacyScreen> {
  late PrivacyProvider privacyProvider;

  @override
  void initState() {
    super.initState();
    Provider.of<PrivacyProvider>(context, listen: false).callApiForGetPrivacy();
  }

  @override
  Widget build(BuildContext context) {
    privacyProvider = Provider.of<PrivacyProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title:
                  Container(margin: const EdgeInsets.only(left: 10), child: const Text("Privacy")),
              centerTitle: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: true,
            ),
            backgroundColor: Color(Constants.bgblack),
            resizeToAvoidBottomInset: true,
            // key: _scaffoldKey,
            body: ModalProgressHUD(
              inAsyncCall: privacyProvider.showSpinner,
              opacity: 1.0,
              color: Colors.transparent.withOpacity(0.2),
              progressIndicator: const CustomLoader(),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints viewportConstraints) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 0, right: 10),
                    color: Colors.transparent,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          onTap: () {
                            Constants.checkNetwork().whenComplete(() => privacyProvider
                                .callApiForSetPrivacy(context));
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Set Account as Private",
                                style: TextStyle(
                                    color: Color(Constants.whitetext),
                                    fontSize: 16,
                                    fontFamily: Constants.appFont),
                              ),
                              FlutterSwitch(
                                height: 25,
                                width: 45,
                                borderRadius: 30,
                                padding: 5.5,
                                duration: const Duration(milliseconds: 400),
                                activeColor: Color(Constants.lightbluecolor),
                                activeToggleColor: Color(Constants.bgblack),
                                inactiveToggleColor: Color(Constants.bgblack),
                                inactiveColor: Color(Constants.greytext),
                                toggleSize: 15,
                                value: privacyProvider.isPrivate,
                                onToggle: (val) {
                                  Constants.checkNetwork().whenComplete(() => privacyProvider
                                      .callApiForSetPrivacy(context));
                                },
                              ),
                            ],
                          ),
                          subtitle: Text(
                            "Your profile will be set as private profile",
                            style: TextStyle(
                                color: Color(Constants.greytext),
                                fontSize: 14,
                                fontFamily: Constants.appFont),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
                          child: Divider(
                            // height:50,
                            color: Color(Constants.greytext),
                            thickness: 1,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                          height: ScreenUtil().setHeight(45),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const BlockedUserScreen()));
                            },
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset("images/block.svg"),
                                Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    "Blocked Users",
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
                          margin: const EdgeInsets.only(left: 20, right: 20, top: 0),
                          height: ScreenUtil().setHeight(45),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const FollowAndInviteScreen()));
                            },
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset("images/follow.svg"),
                                Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    "Follow and Invite Friends",
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
                  );
                },
              ),
            )),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}
