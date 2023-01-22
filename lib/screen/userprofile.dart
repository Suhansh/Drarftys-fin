import 'dart:convert';
import '/apiservice/Api_Header.dart';
import '/apiservice/Apiservice.dart';
import '/custom/loader_custom_widget.dart';
import '/model/single_user_model.dart';
import '/model/report_reason.dart';
import '/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:dio/dio.dart';
import 'chat/chat_screen.dart';
import 'login_screen.dart';
import 'own_post/ownpost.dart';

class UserProfileScreen extends StatefulWidget {
  final int? userId;

  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfileScreen createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  bool isRememberMe = false;
  bool showSpinner = false;
  bool showRed = false;
  bool showWhite = true;
  String deviceToken = "";
  bool showFollowing = false;
  bool showFollow = false;
  bool showRequested = false;
  double containerSize = 50;
  int? userId;
  String? singleUserId = "";
  String? singleUserName = "";
  int? postCount = 0;
  dynamic followingCount = "0";
  dynamic followersCount = '0';
  String imagePath = '';
  String bio = '';
  int isBlock = 0; // 1 = blocked user, 0 = unblocked.
  int isFollowRequest = 0; // 1 = private account, 0 = public account.
  List<Videos> singleUserVideos = <Videos>[];
  List<ReportReasonData> reportReasonData = [];

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    //PreferenceUtils.init();
    if (kDebugMode) {
      print('user id is ${widget.userId}');
    }
    userId = widget.userId;
    Constants.checkNetwork().whenComplete(() => callSingleUserData());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(Constants.bgblack),
          appBar: AppBar(
            title: Text(
              singleUserId!,
            ),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: true,
            actions: <Widget>[
              IconButton(
                tooltip: "Let's Chat with $singleUserName",
                onPressed: () async {
                  var collection = FirebaseFirestore.instance
                      .collection(FirestoreConstants.pathUserCollection);
                  var docSnapshot = await collection
                      .where(FirestoreConstants.userId,
                          isEqualTo: userId.toString())
                      .get();
                  if (kDebugMode) {
                    print(docSnapshot.docs.single.data().toString());
                  }
                  var searchedUserProfile = docSnapshot.docs.single.data();
                  if (searchedUserProfile != null &&
                      searchedUserProfile['userId'] != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          peerAvatar:
                              searchedUserProfile['photoUrl'].toString(),
                          peerId: searchedUserProfile['id'].toString(),
                          peerNickname:
                              searchedUserProfile['nickname'].toString(),
                        ),
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(
                        msg: "something went wrong please login again");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ));
                  }
                },
                icon: SvgPicture.asset(
                  "images/chat_icon.svg",
                  width: 23,
                  height: 23,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  openMoreMenuBottomSheet();
                },
                icon: SvgPicture.asset("images/more_menu.svg"),
              ),
            ],
          ),
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: const CustomLoader(),
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          ///first row
                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
                            child: Container(
                              // height: ScreenUtil().setHeight(55),
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ///profilePicture
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, left: 20),
                                      child: CachedNetworkImage(
                                        alignment: Alignment.center,
                                        imageUrl: imagePath,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          radius: 50,
                                          backgroundColor:
                                              const Color(0xFF36446b),
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundImage: imageProvider,
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            const CustomLoader(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset("images/no_image.png"),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(
                                          right: 20, top: 10, left: 20),
                                      child: ListView(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: <Widget>[
                                          ///username
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              singleUserName!,
                                              style: TextStyle(
                                                  color: Color(
                                                      Constants.whitetext),
                                                  fontSize: 18,
                                                  fontFamily:
                                                      Constants.appFont),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 0, top: 15, left: 0),
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                ///followers
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: ListView(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      children: <Widget>[
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "$followersCount",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .whitetext),
                                                                fontFamily:
                                                                    Constants
                                                                        .appFontBold,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "Followers",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .greytext),
                                                                fontFamily:
                                                                    Constants
                                                                        .appFont,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                ///following
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: ListView(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      children: <Widget>[
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "$followingCount",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .whitetext),
                                                                fontFamily:
                                                                    Constants
                                                                        .appFontBold,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "Following",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .greytext),
                                                                fontFamily:
                                                                    Constants
                                                                        .appFont,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                ///posts
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 20),
                                                    child: ListView(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      children: <Widget>[
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "$postCount",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .whitetext),
                                                                fontFamily:
                                                                    Constants
                                                                        .appFontBold,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "Posts",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .greytext),
                                                                fontFamily:
                                                                    Constants
                                                                        .appFont,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
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

                          ///follow request
                          Visibility(
                              visible: isBlock == 0,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Visibility(
                                  visible: showFollow,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        showFollow = false;
                                        showFollowing = true;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          right: 20, left: 20),
                                      alignment: Alignment.center,
                                      height: ScreenUtil().setHeight(40),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Constants.checkNetwork().whenComplete(
                                              () => followRequest());
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(Constants.buttonbg),
                                          onPrimary: Colors.white24,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                "images/follow.svg"),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 2),
                                              child: Text(
                                                "Follow",
                                                style: TextStyle(
                                                    color: Color(
                                                        Constants.whitetext),
                                                    fontSize: 14,
                                                    fontFamily:
                                                        Constants.appFont),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),

                          ///following request
                          Visibility(
                            visible: isBlock == 0,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Visibility(
                                visible: showFollowing,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  alignment: Alignment.center,
                                  height: ScreenUtil().setHeight(40),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Constants.checkNetwork().whenComplete(
                                          () => unFollowRequest());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      onPrimary: Colors.black12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Following",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: Constants.appFontBold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          /// requested request
                          Visibility(
                            visible: isBlock == 0,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Visibility(
                                visible: showRequested,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  alignment: Alignment.center,
                                  height: ScreenUtil().setHeight(40),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      unFollowRequest();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      onPrimary: Colors.black12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Requested",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: Constants.appFontBold,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 5, top: 2),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.black,
                                          ),
                                          // SvgPicture.asset(
                                          //   "images/blue_down.svg",
                                          //   color: Colors.black,
                                          // ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          ///posts
                          Visibility(
                            visible: isBlock == 0,
                            child: isFollowRequest == 0
                                ? Padding(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setWidth(8)),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 0,
                                          left: 15,
                                          right: 15,
                                          top: 15),
                                      child: StaggeredGridView.countBuilder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        crossAxisCount: 3,
                                        itemCount: singleUserVideos.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          // print(
                                          //     'video index $index like ${singleUserVideos[index].isLike}');
                                          if (singleUserVideos[index].isLike ==
                                              true) {
                                            showRed = true;
                                            showWhite = false;
                                          } else {
                                            showWhite = true;
                                            showRed = false;
                                          }
                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OwnPostScreen(
                                                              singleUserVideos[
                                                                      index]
                                                                  .id)));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Stack(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: singleUserVideos[
                                                                index]
                                                            .imagePath! +
                                                        singleUserVideos[index]
                                                            .screenshot!,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.fill,
                                                          alignment: Alignment
                                                              .topCenter,
                                                        ),
                                                      ),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        const CustomLoader(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Image.asset(
                                                            "images/no_image.png"),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    child: SvgPicture.asset(
                                                      "images/play_button.svg",
                                                      width: 50,
                                                      height: 50,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 0,
                                                            bottom: 5),
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            child: Text(
                                                              () {
                                                                if (1 <
                                                                    int.parse(singleUserVideos[
                                                                            index]
                                                                        .viewCount
                                                                        .toString())) {
                                                                  return "${singleUserVideos[index].viewCount} Views";
                                                                } else {
                                                                  return "${singleUserVideos[index].viewCount} View";
                                                                }
                                                              }(),
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
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4),
                                                              child: ListView(
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                children: [
                                                                  Visibility(
                                                                    visible:
                                                                        showWhite,
                                                                    child: InkWell(
                                                                        onTap: () {
                                                                          setState(
                                                                              () {
                                                                            callApiForLikedVideo(singleUserVideos[index].id,
                                                                                context);
                                                                            showRed =
                                                                                !showRed;
                                                                            showWhite =
                                                                                !showWhite;
                                                                          });
                                                                        },
                                                                        child: SvgPicture.asset(
                                                                          "images/white_heart.svg",
                                                                          width:
                                                                              15,
                                                                          height:
                                                                              15,
                                                                        )),
                                                                  ),
                                                                  Visibility(
                                                                    visible:
                                                                        showRed,
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          callApiForLikedVideo(
                                                                              singleUserVideos[index].id,
                                                                              context);
                                                                          showRed =
                                                                              !showRed;
                                                                          showWhite =
                                                                              !showWhite;
                                                                        });
                                                                      },
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "images/red_heart.svg",
                                                                        width:
                                                                            15,
                                                                        height:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        staggeredTileBuilder: (int index) =>
                                            StaggeredTile.count(
                                                1, index.isEven ? 1.5 : 1.5),
                                        mainAxisSpacing: 1.0,
                                        crossAxisSpacing: 1.0,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setWidth(8)),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> callSingleUserData() async {
    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData())
        .getSingleUserData(userId)
        .then((response) {
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
      }
      if (mounted) {
        setState(() {
          singleUserVideos.clear();
          singleUserId = response.userId;
          singleUserName = response.name;
          imagePath = response.imagePath! + response.image!;
          followersCount = response.followersCount;
          followingCount = response.followingCount;
          isFollowRequest = response.followerRequest ?? 0;
          postCount = response.postCount;
          singleUserVideos.addAll(response.videos!);
          isBlock = response.isBlock!;
          if (response.isFollowing == 1) {
            showFollowing = true;
            showFollow = false;
            showRequested = false;
          } else if (response.isRequested == 1) {
            showRequested = true;
            showFollowing = false;
            showFollow = false;
          } else {
            showFollow = true;
            showRequested = false;
            showFollowing = false;
          }
        });
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
      }
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responseCode = res.statusCode;
          // var error = res.data;
          if (responseCode == 401) {
            Constants.toastMessage('$responseCode');
            if (kDebugMode) {
              print(responseCode);
              print(res.statusMessage);
            }
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('$responseCode');
          } else if (responseCode == 500) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  Future<void> unFollowRequest() async {
    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData())
        .unFollowRequest(userId)
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Constants.checkNetwork().whenComplete(() => callSingleUserData());
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Constants.checkNetwork().whenComplete(() => callSingleUserData());
        });
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
      }
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            Constants.toastMessage('$responseCode');
            if (kDebugMode) {
              print(responseCode);
              print(res.statusMessage);
            }
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('$responseCode');
          } else if (responseCode == 500) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  Future<void> followRequest() async {
    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData())
        .followRequest(userId)
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        setState(() {
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Constants.checkNetwork().whenComplete(() => callSingleUserData());
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Constants.checkNetwork().whenComplete(() => callSingleUserData());
        });
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
      }
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            Constants.toastMessage('$responseCode');
            if (kDebugMode) {
              print(responseCode);
              print(res.statusMessage);
            }
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('$responseCode');
          } else if (responseCode == 500) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  Future<void> callApiForLikedVideo(int? id, BuildContext context) async {
    if (kDebugMode) {
      print("likeid:$id");
    }
    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData()).likevideo(id).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      // print("likevideosucees:$success");
      if (success == true) {
        setState(() {
          showSpinner = false;
          Constants.checkNetwork().whenComplete(() => callSingleUserData());
        });
      } else {
        setState(() {
          showSpinner = false;
          Constants.checkNetwork().whenComplete(() => callSingleUserData());
        });
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
      }
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            Constants.toastMessage('$responseCode');
            if (kDebugMode) {
              print(responseCode);
              print(res.statusMessage);
            }
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('$responseCode');
          } else if (responseCode == 500) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  Future<bool> _onWillPop() async {
    // Navigator.pop(context);
    return true;
  }

  callApiForBlockUser(int? userid) async {
    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData())
        .blockuser(userid.toString(), "User")
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage('$msg');
          Constants.checkNetwork().whenComplete(() => callSingleUserData());
        });
        Navigator.pop(context);
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage('$msg');
        });
        Navigator.pop(context);
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
      }
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            Constants.toastMessage('$responseCode');
            if (kDebugMode) {
              print(responseCode);
              print(res.statusMessage);
            }
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('$responseCode');
          } else if (responseCode == 500) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  callApiForUnBlockUser(int? id) async {
    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData())
        .unblockuser(id.toString(), "User")
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }

      if (success == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage('$msg');
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage('$msg');
        });
      }
      callSingleUserData();
    }).catchError((Object obj) {
      final snackBar = SnackBar(
        content: const Text('Server Error'),
        backgroundColor: Color(Constants.redtext),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // _scaffoldKey.currentState!.showSnackBar(snackBar);
      setState(() {
        showSpinner = false;
      });
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  callApiForReportReason() async {
    reportReasonData.clear();
    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData())
        .reportReason("User")
        .then((response) {
      if (response.success == true) {
        setState(() {
          showSpinner = false;
          reportReasonData.addAll(response.data!);
          _openReportBottomSheet();
        });
      } else {
        setState(() {
          showSpinner = false;
          Constants.toastMessage(response.msg!);
        });
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
      }
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            Constants.toastMessage('$responseCode');
            if (kDebugMode) {
              print(responseCode);
              print(res.statusMessage);
            }
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('$responseCode');
          } else if (responseCode == 500) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  callApiForReport(reportId) {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData())
        .reportUser(userId.toString(), reportId.toString())
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage('$msg');
          Constants.checkNetwork().whenComplete(() => callSingleUserData());
          Navigator.pop(context);
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage('$msg');
          Constants.checkNetwork().whenComplete(() => callSingleUserData());
        });
        Navigator.pop(context);
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
      }
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            Constants.toastMessage('$responseCode');
            if (kDebugMode) {
              print(responseCode);
              print(res.statusMessage);
            }
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('$responseCode');
          } else if (responseCode == 500) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  void openMoreMenuBottomSheet() {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: Color(Constants.bgblack),
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Wrap(
                children: <Widget>[
                  /// report
                  showFollowing == true
                      ? InkWell(
                          onTap: () {
                            Constants.checkNetwork()
                                .whenComplete(() => callApiForReportReason());
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                                top: 0, left: 0, bottom: 0),
                            height: ScreenUtil().setHeight(50),
                            child: Text(
                              "Report",
                              style: TextStyle(
                                  color: Color(Constants.whitetext),
                                  fontSize: 16,
                                  fontFamily: Constants.appFont),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : const SizedBox(
                          height: 0,
                          width: 0,
                        ),

                  /// block this user
                  InkWell(
                    onTap: () {
                      isBlock == 0
                          ? Constants.checkNetwork()
                              .whenComplete(() => callApiForBlockUser(userId))
                          : Constants.checkNetwork().whenComplete(
                              () => callApiForUnBlockUser(userId));
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        isBlock == 0 ? "Block This User" : "Unblock This User",
                        style: TextStyle(
                            color: Color(Constants.whitetext),
                            fontSize: 16,
                            fontFamily: Constants.appFont),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  /// unfollow this profile
                  isBlock == 0
                      ? showFollowing || showRequested
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  showFollow = true;
                                  showFollowing = false;
                                  showRequested = false;
                                  Navigator.pop(context);
                                  Constants.checkNetwork()
                                      .whenComplete(() => unFollowRequest());
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                    top: 0, left: 0, bottom: 0),
                                height: ScreenUtil().setHeight(50),
                                child: Text(
                                  showRequested
                                      ? "Cancel Request"
                                      : "Unfollow This Profile",
                                  style: TextStyle(
                                      color: Color(Constants.redtext),
                                      fontSize: 16,
                                      fontFamily: Constants.appFont),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Container(
                              height: 1,
                            )
                      : Container(
                          height: 1,
                        ),
                ],
              ),
            ));
  }

  void _openReportBottomSheet() {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: Color(Constants.bgblack),
        builder: (context) {
          for (int i = 0; i < reportReasonData.length; i++) {
            containerSize += 50;
          }
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              height: containerSize,
              child: ListView.builder(
                itemCount: reportReasonData.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    Constants.checkNetwork().whenComplete(
                        () => callApiForReport(reportReasonData[index].id));
                  },
                  title: Text(
                    reportReasonData[index].reason!,
                    style: TextStyle(
                        color: Color(Constants.whitetext),
                        fontSize: 16,
                        fontFamily: Constants.appFont),
                  ),
                ),
              ),
            ),
          );
        });
    containerSize = 50;
  }
}
