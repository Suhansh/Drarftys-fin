import '/custom/loader_custom_widget.dart';
import '/screen/setting/notification_setting/notification_setting_provider.dart';
import '/util/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({Key? key}) : super(key: key);

  @override
  _NotificationSettingScreen createState() => _NotificationSettingScreen();
}

class _NotificationSettingScreen extends State<NotificationSettingScreen> {

  late NotificationSettingProvider notificationSettingProvider;
  @override
  void initState() {
    super.initState();
    Provider.of<NotificationSettingProvider>(context,listen: false).callApiForGetNotificationData();
  }

  @override
  Widget build(BuildContext context) {
    notificationSettingProvider =     Provider.of<NotificationSettingProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Text("Notification")),
              centerTitle: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: true,
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    notificationSettingProvider.callApiForSaveNotification(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 25),
                    child: SvgPicture.asset("images/right.svg"),
                  ),
                )
              ],
            ),
            backgroundColor: Color(Constants.bgblack),
            resizeToAvoidBottomInset: true,
            body: ModalProgressHUD(
              inAsyncCall: notificationSettingProvider.showSpinner,
              opacity: 1.0,
              color: Colors.transparent.withOpacity(0.2),
              progressIndicator: const CustomLoader(),
              child: LayoutBuilder(
                builder:
                    (BuildContext context, BoxConstraints viewportConstraints) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    // color: Colors.transparent,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                notificationSettingProvider.muteAllNotification = !notificationSettingProvider.muteAllNotification;
                                if (kDebugMode) {
                                  print(notificationSettingProvider.muteAllNotification);
                                }
                                if (notificationSettingProvider.muteAllNotification == true) {
                                  notificationSettingProvider.postAndComment = false;
                                  notificationSettingProvider.likeToggle = false;
                                  notificationSettingProvider.commentToggle = false;
                                  notificationSettingProvider.followingAndFollowers = false;
                                  notificationSettingProvider.followingRequest = false;
                                }
                              });
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Mute All Notifications",
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
                                  value: notificationSettingProvider.muteAllNotification,
                                  onToggle: (val) {
                                    setState(() {
                                      notificationSettingProvider.muteAllNotification =
                                          !notificationSettingProvider.muteAllNotification;
                                      if (kDebugMode) {
                                        print(notificationSettingProvider.muteAllNotification);
                                      }
                                      if (notificationSettingProvider.muteAllNotification == true) {
                                        notificationSettingProvider.postAndComment = false;
                                        notificationSettingProvider.likeToggle = false;
                                        notificationSettingProvider.commentToggle = false;
                                        notificationSettingProvider.followingAndFollowers = false;
                                        notificationSettingProvider.followingRequest = false;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            subtitle: Text(
                              "You want receive any kind of\nnotification from the app.",
                              style: TextStyle(
                                  color: Color(Constants.greytext),
                                  fontSize: 14,
                                  fontFamily: Constants.appFont),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Divider(
                            color: Color(Constants.greytext),
                            thickness: 1,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              notificationSettingProvider.postAndComment = !notificationSettingProvider.postAndComment;
                              if (notificationSettingProvider.muteAllNotification == true) {
                                notificationSettingProvider.muteAllNotification = false;
                              }
                            });
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Posts & Comments",
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
                                value: notificationSettingProvider.postAndComment,
                                onToggle: (val) {
                                  setState(() {
                                    notificationSettingProvider.postAndComment = !notificationSettingProvider.postAndComment;
                                    if (notificationSettingProvider.muteAllNotification == true) {
                                      notificationSettingProvider.muteAllNotification = false;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          subtitle: Text(
                            "You want receive posts or comments\nrelated notification from the app",
                            style: TextStyle(
                                color: Color(Constants.greytext),
                                fontSize: 14,
                                fontFamily: Constants.appFont),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              notificationSettingProvider.likeToggle = !notificationSettingProvider.likeToggle;
                              if (notificationSettingProvider.muteAllNotification == true) {
                                notificationSettingProvider.muteAllNotification = false;
                              }
                            });
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Likes",
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
                                value: notificationSettingProvider.likeToggle,
                                onToggle: (val) {
                                  setState(() {
                                    notificationSettingProvider.likeToggle = !notificationSettingProvider.likeToggle;
                                    if (notificationSettingProvider.muteAllNotification == true) {
                                      notificationSettingProvider.muteAllNotification = false;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              notificationSettingProvider.commentToggle = !notificationSettingProvider.commentToggle;
                              if (notificationSettingProvider.muteAllNotification == true) {
                                notificationSettingProvider.muteAllNotification = false;
                              }
                            });
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Comments",
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
                                value: notificationSettingProvider.commentToggle,
                                onToggle: (val) {
                                  setState(() {
                                    notificationSettingProvider.commentToggle = !notificationSettingProvider.commentToggle;
                                    if (notificationSettingProvider.muteAllNotification == true) {
                                      notificationSettingProvider.muteAllNotification = false;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Divider(
                            color: Color(Constants.greytext),
                            thickness: 1,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              notificationSettingProvider.followingAndFollowers = !notificationSettingProvider.followingAndFollowers;
                              if (notificationSettingProvider.muteAllNotification == true) {
                                notificationSettingProvider.muteAllNotification = false;
                              }
                            });
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(left: 0),
                                child: Text(
                                  "Following & Followers",
                                  style: TextStyle(
                                      color: Color(Constants.whitetext),
                                      fontSize: 16,
                                      fontFamily: Constants.appFont),
                                ),
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
                                value: notificationSettingProvider.followingAndFollowers,
                                onToggle: (val) {
                                  setState(() {
                                    notificationSettingProvider.followingAndFollowers =
                                        !notificationSettingProvider.followingAndFollowers;
                                    if (notificationSettingProvider.muteAllNotification == true) {
                                      notificationSettingProvider.muteAllNotification = false;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          subtitle: Text(
                            "You want receive following & followers\nrelated notification from the app.",
                            style: TextStyle(
                                color: Color(Constants.greytext),
                                fontSize: 14,
                                fontFamily: Constants.appFont),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              notificationSettingProvider.followingRequest = !notificationSettingProvider.followingRequest;
                              if (notificationSettingProvider.muteAllNotification == true) {
                                notificationSettingProvider.muteAllNotification = false;
                              }
                            });
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Following Request",
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
                                value: notificationSettingProvider.followingRequest,
                                onToggle: (val) {
                                  setState(() {
                                    notificationSettingProvider.followingRequest = !notificationSettingProvider.followingRequest;
                                    if (notificationSettingProvider.muteAllNotification == true) {
                                      notificationSettingProvider.muteAllNotification = false;
                                    }
                                  });
                                },
                              ),
                            ],
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
