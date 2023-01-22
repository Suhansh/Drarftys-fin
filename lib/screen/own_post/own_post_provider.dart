import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';
import '../../apiservice/Api_Header.dart';
import '../../apiservice/Apiservice.dart';
import '../../custom/loader_custom_widget.dart';
import '../../model/report_reason.dart';
import '../../model/videocomment.dart';
import '../../util/constants.dart';

class OwnPostProvider extends ChangeNotifier {
  GlobalKey<ScaffoldState> ownPostProviderScaffoldKey =
      GlobalKey<ScaffoldState>();
  final textCommentController = TextEditingController();
  bool halfStatus = true;
  bool fullStatus = false;
  bool showMore = true;
  bool showSpinner = false;
  List<CommentData> commentList = <CommentData>[];
  int? videoId = 0;
  int? userId = 0;
  String videoLink = "link";
  String isComment = "0";
  String commentCount = "0";
  String likeCount = "0";
  String viewCount = "0";
  bool? isLike = false;
  String isSaved = "0";
  String isReported = "0";
  String? originalSound;
  String status = "The Status";
  String songId = "0";
  String audioId = "0";
  int? selectedCommentId = 0;
  String? username = "name";
  String userImage = "image";
  bool showBuffering = false;
  bool visible = false;
  List<ReportReasonData> reportReasonData = [];
  bool showLoading = true;
  static const List<String> choices = <String>[
    "Delete Comment",
    "Report Comment"
  ];
  late Future<bool> getVideoFeatureBuilder;
  late VideoPlayerController controller =
      VideoPlayerController.asset('images/bg_logo.png');

  void ownPostInit(previousPageUserId) {
    getVideoFeatureBuilder = callApiForSingleVideo(previousPageUserId);
    userId = previousPageUserId;
    controller.addListener(() {
      controller.value.isBuffering ? showLoading = true : showLoading = false;
      notifyListeners();
    });
  }

  Future<void> callApiForViewVideo() async {
    await RestClient(ApiHeader().dioData()).viewVideo(userId).then((response) {
      if (kDebugMode) {
        print(response);
      }
      notifyListeners();
    }).catchError((Object obj) {
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  callApiForGetComment(int? id) async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData())
        .getvideocomment(id)
        .then((response) {
      if (response.success == true) {
        showSpinner = false;
        commentList.clear();
        _openCommentLayout();
        if (response.data!.isNotEmpty) {
          commentList.addAll(response.data!);
        }
        notifyListeners();
      } else {
        showSpinner = false;
        _openCommentLayout();
        notifyListeners();
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());
      showSpinner = false;
      notifyListeners();
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  callApiForPostComment(String comment, BuildContext context, int? id) async {
    if (kDebugMode) {
      print("like id:$id");
    }
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData())
        .postcomment(id.toString(), comment)
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Navigator.pop(context);
        textCommentController.clear();

        // Constants.checkNetwork().whenComplete(() => callApiForSingleVideo(userId));
        notifyListeners();
      } else {
        showSpinner = false;
        // var msg = body['msg'];
        notifyListeners();
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());
      showSpinner = false;
      notifyListeners();
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  Future<void> callApiForLikeComment(
      int? id, BuildContext context, int index) async {
    if (kDebugMode) {
      print("like id:$id");
    }
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).likecomment(id).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        showSpinner = false;
        Navigator.pop(context);
        notifyListeners();
      } else {
        showSpinner = false;
        notifyListeners();
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());
      showSpinner = false;
      notifyListeners();
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  Future<void> callApiForLikedVideo(int? id, BuildContext context) async {
    if (kDebugMode) {
      print("likeid:$id");
    }
    showSpinner = true;
    await RestClient(ApiHeader().dioData()).likevideo(id).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print("like video succees:$success");
      }
      if (success == true) {
        showSpinner = false;
        if (kDebugMode) {
          print("like vid msg:${body['msg']}");
        }
      } else {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
      }
      notifyListeners();
    }).catchError((Object obj) {
      Constants.toastMessage("Server Error");
      showSpinner = false;
      notifyListeners();
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  void choiceAction(String choice) {
    if (choice == "Delete Comment") {
      if (kDebugMode) {
        print('delete comment');
      }
      callApiForDeleteComment(
          selectedCommentId, ownPostProviderScaffoldKey.currentContext!);
    } else if (choice == "Report Comment") {
      if (kDebugMode) {
        print('Report Comment');
      }
      callApiForReportReason(selectedCommentId);
    }
  }

  Future<void> callApiForDeleteComment(int? id, BuildContext context) async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).deleteComment(id).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Navigator.of(context).pop();
        // Constants.checkNetwork().whenComplete(() => callApiForSingleVideo(userId));
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());

      showSpinner = false;
      notifyListeners();
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  callApiForReportReason(int? commentId) async {
    reportReasonData.clear();

    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData())
        .reportReason("Comment")
        .then((response) {
      if (response.success == true) {
        showSpinner = false;
        reportReasonData.addAll(response.data!);
        openReportBottomSheet(commentId);
        notifyListeners();
      } else {
        showSpinner = false;
        Constants.toastMessage(response.msg!);
        notifyListeners();
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());

      showSpinner = false;
      notifyListeners();
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

  callApiForReport(commentId, reportId) async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData())
        .reportComment(commentId.toString(), reportId.toString())
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage('$msg');
        Navigator.pop(ownPostProviderScaffoldKey.currentContext!);
      }
      notifyListeners();
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
      showSpinner = false;
      notifyListeners();
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

  void _openCommentLayout() {
    showModalBottomSheet(
        context: ownPostProviderScaffoldKey.currentContext!,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Color(Constants.bgblack),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter myState) {
            myState(() {});
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 80, left: 0, bottom: 20),
                    height: ScreenUtil().setHeight(50),
                    color: const Color(0xFF1d1d1d),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Text("$commentCount comments",
                              style: TextStyle(
                                  color: Color(Constants.whitetext),
                                  fontFamily: Constants.appFont,
                                  fontSize: 16)),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: SvgPicture.asset("images/close.svg")),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: commentList.isNotEmpty
                        ? ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: commentList.length,
                            itemBuilder: (context, index) {
                              if (commentList[index].isLike == 1) {
                                commentList[index].showwhite = false;
                                commentList[index].showred = true;
                              } else {
                                commentList[index].showwhite = true;
                                commentList[index].showred = false;
                              }

                              return Container(
                                margin: const EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, bottom: 10),
                                        child: CachedNetworkImage(
                                          alignment: Alignment.center,
                                          imageUrl: commentList[index]
                                                  .user!
                                                  .imagePath! +
                                              commentList[index].user!.image!,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                const Color(0xFF36446b),
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundImage: imageProvider,
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const CustomLoader(),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  "images/no_image.png"),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        child: ListView(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10, bottom: 0),
                                              color: Colors.transparent,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    commentList[index]
                                                        .user!
                                                        .name!,
                                                    style: TextStyle(
                                                        color: Color(
                                                            Constants.greytext),
                                                        fontSize: 14,
                                                        fontFamily:
                                                            Constants.appFont),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                color: Colors.transparent,
                                                child: Text(
                                                  commentList[index].comment!,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Color(
                                                          Constants.whitetext),
                                                      fontSize: 14,
                                                      fontFamily:
                                                          Constants.appFont),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: ListView(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                myState(() {
                                                  commentList[index].showwhite =
                                                      true;
                                                  commentList[index].showred =
                                                      false;
                                                  Constants.checkNetwork()
                                                      .whenComplete(() =>
                                                          callApiForLikeComment(
                                                              commentList[index]
                                                                  .id,
                                                              context,
                                                              index));
                                                });
                                              },
                                              child: Visibility(
                                                visible:
                                                    commentList[index].showred,
                                                child: SvgPicture.asset(
                                                  "images/red_heart.svg",
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                myState(() {
                                                  commentList[index].showwhite =
                                                      false;
                                                  commentList[index].showred =
                                                      true;
                                                  Constants.checkNetwork()
                                                      .whenComplete(() =>
                                                          callApiForLikeComment(
                                                              commentList[index]
                                                                  .id,
                                                              context,
                                                              index));
                                                });
                                              },
                                              child: Visibility(
                                                visible: commentList[index]
                                                    .showwhite,
                                                child: SvgPicture.asset(
                                                  "images/white_heart.svg",
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              commentList[index]
                                                  .likesCount
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Color(
                                                      Constants.whitetext),
                                                  fontFamily: Constants.appFont,
                                                  fontSize: 14),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: PopupMenuButton<String>(
                                          color: Color(Constants.conbg),
                                          icon: SvgPicture.asset(
                                            "images/more_menu.svg",
                                            width: 20,
                                            height: 20,
                                          ),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(18.0))),
                                          offset: const Offset(20, 20),
                                          onSelected: choiceAction,
                                          itemBuilder: (BuildContext context) {
                                            selectedCommentId =
                                                commentList[index].id;
                                            return choices.map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(
                                                  choice,
                                                  style: TextStyle(
                                                      color: Color(
                                                          Constants.whitetext),
                                                      fontSize: 14,
                                                      fontFamily: Constants
                                                          .appFontBold),
                                                ),
                                              );
                                            }).toList();
                                          },
                                        )),
                                  ],
                                ),
                              );
                            },
                          )
                        : Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: ScreenUtil().setHeight(80),
                              margin: const EdgeInsets.only(
                                  top: 10.0, left: 15.0, right: 15, bottom: 0),
                              child: Text(
                                "No Comments Available !",
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
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 0, bottom: 0),
                    height: ScreenUtil().setHeight(50),
                    color: const Color(0xFF1d1d1d),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextField(
                              autofocus: false,
                              controller: textCommentController,
                              style: TextStyle(
                                  color: Color(Constants.whitetext),
                                  fontSize: 14,
                                  fontFamily: Constants.appFont),
                              decoration: InputDecoration.collapsed(
                                hintText: "Type Something...",
                                hintStyle: TextStyle(
                                    color: Color(Constants.hinttext),
                                    fontSize: 14,
                                    fontFamily: Constants.appFont),
                                border: InputBorder.none,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () {
                                  if (textCommentController.text.isNotEmpty) {
                                    Constants.checkNetwork().whenComplete(() =>
                                        callApiForPostComment(
                                            textCommentController.text,
                                            context,
                                            videoId));
                                  }
                                },
                                child:
                                    SvgPicture.asset("images/post_comment.svg"),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  void openReportBottomSheet(int? commentId) {
    int? value;
    int? reasonId;
    showModalBottomSheet(
        context: ownPostProviderScaffoldKey.currentContext!,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Color(Constants.bgblack),
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter myState) {
              myState(() {});
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Scaffold(
                  backgroundColor: Color(Constants.bgblack1),
                  bottomNavigationBar: InkWell(
                    onTap: reasonId == null
                        ? null
                        : () {
                            Constants.checkNetwork().whenComplete(
                                () => callApiForReport(commentId, reasonId));
                          },
                    child: Container(
                      height: ScreenUtil().setHeight(50),
                      color: const Color(0xff36446B),
                      alignment: Alignment.center,
                      child: Text(
                        'Submit Your Comment Report',
                        style: TextStyle(
                            color: Color(Constants.whitetext),
                            fontSize: 15,
                            fontFamily: Constants.appFont),
                      ),
                    ),
                  ),
                  body: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: ScreenUtil().setHeight(50),
                          color: Color(Constants.bgblack1),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Reason of Report',
                                  style: TextStyle(
                                      color: Color(Constants.whitetext),
                                      fontSize: 13,
                                      fontFamily: Constants.appFont),
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(Icons.close,
                                        color: Colors.white))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.50,
                          child: ListView(
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            // mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SingleChildScrollView(
                                child: ListView.builder(
                                  itemCount: reportReasonData.length,
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor:
                                            Color(Constants.whitetext),
                                      ),
                                      child: RadioListTile(
                                        value: index,
                                        groupValue: value,
                                        onChanged: (dynamic val) => myState(() {
                                          reasonId = reportReasonData[index].id;
                                          value = val;
                                        }),
                                        title: Text(
                                          reportReasonData[index].reason!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Color(Constants.whitetext),
                                              fontSize: 14,
                                              fontFamily: Constants.appFont),
                                        ),
                                        activeColor: Color(Constants.whitetext),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  Future<bool> callApiForSingleVideo(apiUserId) async {
    bool apiResponseInBool = false;
    // OwnPostProvider provider = Provider.of<OwnPostProvider>(context, listen: false);
    showSpinner = true;
    showLoading = true;
    // setState(() {});
    await RestClient(ApiHeader().dioData())
        .getsinglevideo(apiUserId)
        .then((response) {
      callApiForViewVideo();
      if (response.success == true) {
        showSpinner = false;
        videoId = response.data!.id;
        videoLink = response.data!.imagePath! + response.data!.video!;
        isComment = response.data!.isComment.toString();
        commentCount = response.data!.commentCount.toString();
        likeCount = response.data!.likeCount.toString();
        viewCount = response.data!.viewCount.toString();
        isLike = response.data!.isLike;
        isSaved = response.data!.isSaved.toString();
        isReported = response.data!.isReported.toString();
        username = response.data!.user!.name;
        userImage =
            response.data!.user!.imagePath! + response.data!.user!.image!;
        if (response.data!.originalAudio != null) {
          originalSound = response.data!.originalAudio;
        }
        if (response.data!.description != null) {
          status = response.data!.description.toString();
        } else {
          status = '';
        }
        songId = response.data!.songId.toString();
        audioId = response.data!.audioId.toString();
        controller = VideoPlayerController.network(videoLink)
          ..initialize().then((value) => {
                controller.play(),
                controller.value.isBuffering
                    ? showLoading = true
                    : showLoading = false
              });
        controller.play();
        controller.seekTo(Duration.zero);
        controller.setLooping(true);
        showLoading = false;
        notifyListeners();
        apiResponseInBool = true;
      } else {
        showSpinner = false;
        showLoading = false;
        notify();
        apiResponseInBool = false;
      }
    }).catchError((Object obj) {
      showSpinner = false;
      showLoading = false;
      apiResponseInBool = false;
      notify();
    });
    return apiResponseInBool;
  }

  void showMoreStatus() {
    halfStatus = !halfStatus;
    fullStatus = !fullStatus;
    showMore = !showMore;
    notifyListeners();
  }

  void shareVideo() {
    showSpinner = true;
    controller.pause();
    Share.share(videoLink + '?video=' + videoId.toString()).then((value) {
      return showSpinner = false;
    });
  }

  void likeVideos(BuildContext context) {
    isLike = !isLike!;
    int tempLike;
    tempLike = int.parse(likeCount);
    if (isLike!) {
      tempLike += 1;
    } else {
      tempLike -= 1;
    }
    likeCount = tempLike.toString();
    notifyListeners();
    callApiForLikedVideo(videoId, context);
  }

  notify() {
    notifyListeners();
  }
}
