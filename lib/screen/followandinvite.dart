import 'package:flutter/foundation.dart';

import '/apiservice/Api_Header.dart';
import '/apiservice/Apiservice.dart';
import '/custom/loader_custom_widget.dart';
import '/model/followandinvtelist.dart';
import '/util/constants.dart';
import '/util/preference_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '/screen/userprofile.dart';
import 'package:share/share.dart';
import 'package:dio/dio.dart';

class FollowAndInviteScreen extends StatefulWidget {
  const FollowAndInviteScreen({Key? key}) : super(key: key);

  @override
  _FollowAndInviteScreen createState() => _FollowAndInviteScreen();
}

class _FollowAndInviteScreen extends State<FollowAndInviteScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  bool isOnline = true;

  List<FollowInviteData> followInviteList = <FollowInviteData>[];

  bool noData = true;
  bool showData = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  String? shareUrl = '';

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    PreferenceUtils.init();
    if (mounted) {
      Constants.checkNetwork().whenComplete(() => callApiForFollowandInvite());
      Constants.checkNetwork().whenComplete(() => callApiForSetting());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text("Follow & Invite Friends"),
              ),
              centerTitle: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: true,
            ),
            backgroundColor: Color(Constants.bgblack),
            resizeToAvoidBottomInset: true,
            key: _scaffoldKey,
            body: RefreshIndicator(
              color: Color(Constants.lightbluecolor),
              backgroundColor: Colors.white,
              onRefresh: callApiForFollowandInvite,
              key: _refreshIndicatorKey,
              child: ModalProgressHUD(
                inAsyncCall: showSpinner,
                opacity: 1.0,
                color: Colors.transparent.withOpacity(0.2),
                progressIndicator: const CustomLoader(),
                child: LayoutBuilder(
                  builder: (BuildContext context,
                      BoxConstraints viewportConstraints) {
                    return Stack(
                      children: <Widget>[
                        SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 0, right: 10),
                            color: Colors.transparent,
                            child: Column(
                              children: <Widget>[
                                Visibility(
                                  visible: showData,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20, top: 25),
                                    child: ListView.separated(
                                      itemCount: followInviteList.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 10.0,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserProfileScreen(
                                                          userId:
                                                              followInviteList[
                                                                      index]
                                                                  .id,
                                                        )));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              CachedNetworkImage(
                                                alignment: Alignment.center,
                                                imageUrl:
                                                    followInviteList[index]
                                                            .imagePath! +
                                                        followInviteList[index]
                                                            .image!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF36446b),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                50)),
                                                    border: Border.all(
                                                      color: Color(Constants
                                                          .lightbluecolor),
                                                      width: 3.0,
                                                    ),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor:
                                                        const Color(0xFF36446b),
                                                    child: CircleAvatar(
                                                      radius: 30,
                                                      backgroundImage:
                                                          imageProvider,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CustomLoader(),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(
                                                        "images/no_image.png"),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Container(
                                                  color: Colors.transparent,
                                                  margin: const EdgeInsets.only(
                                                      left: 10, top: 5),
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          followInviteList[
                                                                  index]
                                                              .name!,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  Constants
                                                                      .whitetext),
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  Constants
                                                                      .appFont),
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        margin: const EdgeInsets
                                                            .only(top: 5),
                                                        child: Text(
                                                          followInviteList[
                                                                      index]
                                                                  .followersCount
                                                                  .toString() +
                                                              " Followers",
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  Constants
                                                                      .greytext),
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  Constants
                                                                      .appFont),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: InkWell(
                                                  onTap: () {
                                                    Share.share('$shareUrl');
                                                  },
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 15),
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0,
                                                                  right: 10),
                                                          alignment:
                                                              Alignment.center,
                                                          height: ScreenUtil()
                                                              .setHeight(35),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  8),
                                                            ),
                                                            color: Color(
                                                                Constants
                                                                    .buttonbg),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5,
                                                                    right: 5),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SvgPicture.asset(
                                                                    "images/follow.svg"),
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 2),
                                                                  child: Text(
                                                                    "Follow",
                                                                    style: TextStyle(
                                                                        color: Color(Constants
                                                                            .whitetext),
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            Constants.appFont),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: noData,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: ScreenUtil().setHeight(80),
                                        margin: const EdgeInsets.only(
                                            top: 20.0,
                                            left: 15.0,
                                            right: 15,
                                            bottom: 0),
                                        child: Text(
                                          "No Data Available !",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: Constants.appFont,
                                              fontSize: 20),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )),
      ),
    );
  }

  void sharePost(int index) {
    setState(() {
      showSpinner = true;
    });
    Share.share("").whenComplete(() {
      setState(() {
        showSpinner = false;
      });
    });
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  Future<void> callApiForFollowandInvite() async {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).getfollowlist().then((response) {
      if (response.success == true) {
        followInviteList.clear();
        setState(() {
          showSpinner = false;
        });
        setState(() {
          if (response.data!.isNotEmpty) {
            followInviteList.addAll(response.data!);
            noData = false;
            showData = true;
          }
        });
      } else {
        setState(() {
          showSpinner = false;
          noData = true;
          showData = false;
        });
      }
    }).catchError((Object obj) {
      final snackBar = SnackBar(
        content: const Text('Server Error'),
        backgroundColor: Color(Constants.redtext),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // _scaffoldKey.currentState!.showSnackBar(snackBar);
      setState(() {
        showSpinner = false;
        noData = true;
        showData = false;
      });
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  Future<void> callApiForSetting() async {
    await RestClient(ApiHeader().dioData()).settingRequest().then((response) {
      if (response.success == true) {
        if (kDebugMode) {
          print("Setting true");
        }
        shareUrl = response.data!.shareUrl;
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print("error:$obj.");
        print(obj.runtimeType);
      }

      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          if (kDebugMode) {
            print(res);
          }

          var responsecode = res.statusCode;

          if (responsecode == 401) {
            if (kDebugMode) {
              print(responsecode);
              print(res.statusMessage);
            }
          } else if (responsecode == 422) {
            if (kDebugMode) {
              print("code:$responsecode");
            }
          }

          break;
        default:
      }
    });
  }
}
