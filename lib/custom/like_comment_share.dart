import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../util/preference_utils.dart';
import '/apiservice/Api_Header.dart';
import '/apiservice/Apiservice.dart';
import '/model/report_reason.dart';
import '/model/videocomment.dart';
import '/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';
import 'loader_custom_widget.dart';
import 'no_post_available.dart';

//ignore: must_be_immutable
class CustomLikeComment extends StatefulWidget {
  int index;
  String shareLink;
  String commentCount;

  // String likeCount;
  bool? isLike;
  List listOfAll;

  // BuildContext context;
  CustomLikeComment({
    Key? key,
    required this.index,
    required this.shareLink,
    required this.commentCount,
    // required this.likeCount,
    required this.isLike,
    required this.listOfAll,
    // required this.context
  }) : super(key: key);

  @override
  _CustomLikeCommentState createState() => _CustomLikeCommentState();
}

class _CustomLikeCommentState extends State<CustomLikeComment> {
  List trendingVidList = [];

  bool deleteOptionAvailable = false;
  static const List<String> choices = <String>[
    "Delete Comment",
    "Report Comment"
  ];
  static const List<String> choicesReportOnly = <String>["Report Comment"];
  int? selectedCommentId = 0;
  int? removeVideoIndex;
  final _textCommentController = TextEditingController();
  String likeCount = '';
  List<ReportReasonData> reportReasonData = [];
  late Future<List<CommentData>> _getCommentFeatureBuilder;
  late LikeCommentShareProvider likeCommentShareProvider;

  @override
  void initState() {
    super.initState();
    // _getCommentFeatureBuilder = callApiForGetComment();
    trendingVidList = widget.listOfAll;
    likeCount = trendingVidList[widget.index].likeCount.toString();
  }

  @override
  Widget build(BuildContext context) {
    likeCommentShareProvider = Provider.of<LikeCommentShareProvider>(context);
    return Container(
      margin: const EdgeInsets.only(left: 10, bottom: 10),
      width: 100.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //share
          InkWell(
            onTap: () {
              String passUrl =
                  (trendingVidList[widget.index].imagePath.toString() +
                          trendingVidList[widget.index].video.toString()) +
                      '?video=' +
                      trendingVidList[widget.index].id.toString();
              sharePost(passUrl);
            },
            child: _getSocialAction(
              icon: "images/share.svg",
              title: 'Share',
            ),
          ),
          //comment
          trendingVidList[widget.index].isComment == 1
              ? InkWell(
                  onTap: () {
                    if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                      if (mounted) {
                        _getCommentFeatureBuilder = callApiForGetComment();
                        // Constants.checkNetwork().whenComplete(() => callApiForGetComment());
                        _openCommentLayout(
                            widget.index, widget.listOfAll[widget.index].id);
                      }
                    } else {
                      Constants.toastMessage('Please Login First To Comment');
                    }
                  },
                  child: _getSocialAction(
                    icon: "images/comments.svg",
                    title:
                        trendingVidList[widget.index].commentCount.toString(),
                  ),
                )
              : Container(),
          //like
          InkWell(
            onTap: () async {
              if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                // int a = int.parse(likeCount.toString());
                // a += 1;
                // likeCount = a.toString();
                int likeCountConvert = int.parse(likeCount.toString());
                if (trendingVidList[widget.index].isLike == true) {
                  likeCountConvert -= 1;
                } else {
                  likeCountConvert += 1;
                }
                likeCount = likeCountConvert.toString();
                updateLike(
                  videoId: trendingVidList[widget.index].id,
                  totalLikes: likeCount,
                  videoLike: !trendingVidList[widget.index].isLike!,
                );
                if (kDebugMode) {
                  print('converted like  $likeCount');
                }
                Constants.checkNetwork().whenComplete(() =>
                    callApiForLikedVideo(
                        trendingVidList[widget.index].id, context));
              } else {
                Constants.toastMessage('Please login first to like video');
              }
            },
            child: Container(
              margin: const EdgeInsets.only(top: 15.0),
              width: 60.0,
              height: 60.0,
              child: Column(
                children: [
                  SvgPicture.asset(
                    "images/red_heart.svg",
                    color: trendingVidList[widget.index].isLike == true
                        ? Color(
                            Constants.redtext,
                          )
                        : Color(
                            Constants.whitetext,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      trendingVidList[widget.index].likeCount.toString(),
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          ///more options
          trendingVidList[widget.index].isYou == false
              ? InkWell(
                  onTap: () {
                    if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                      _openSavedBottomSheet(
                          trendingVidList[widget.index].id,
                          trendingVidList[widget.index].isSaved,
                          trendingVidList[widget.index].user!.id);
                    } else {
                      Constants.toastMessage(
                          'Login please to access this option');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _getSingleAction(icon: "images/more_menu.svg"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void updateLike({int? videoId, String? totalLikes, bool? videoLike}) {
    final tile = widget.listOfAll.firstWhere((item) => item.id == videoId);
    tile.likeCount = totalLikes;
    tile.isLike = videoLike;
    likeCommentShareProvider.notify();
  }

  updateCommentsCount({int? videoId}) {
    final tile = widget.listOfAll.firstWhere((item) => item.id == videoId);
    int commentCount = int.parse(tile.commentCount.toString());
    commentCount += 1;
    tile.commentCount = commentCount.toString();
    likeCommentShareProvider.notify();
  }

  removeCommentsCount({int? videoId}) {
    final tile = widget.listOfAll.firstWhere((item) => item.id == videoId);
    int commentCount = int.parse(tile.commentCount.toString());
    commentCount -= 1;
    tile.commentCount = commentCount.toString();
    likeCommentShareProvider.notify();
  }

  Future<void> sharePost(deepLinkPath) async {
    Share.share(deepLinkPath);
  }

  Widget _getSocialAction({required String title, required String icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      width: 60.0,
      height: 60.0,
      child: Column(children: [
        SvgPicture.asset(icon),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(title,
              style: const TextStyle(fontSize: 14, color: Colors.white)),
        ),
      ]),
    );
  }

  Widget _getSingleAction({required String icon}) {
    return Container(
        margin: const EdgeInsets.only(top: 15.0, bottom: 20),
        width: 25.0,
        height: 25.0,
        child: SvgPicture.asset(icon));
  }

  Future<void> choiceAction(String choice) async {
    if (choice == "Delete Comment") {
      if (kDebugMode) {
        if (kDebugMode) {
          print('delete comment');
        }
      }
      await callApiForDeleteComment(selectedCommentId);
      removeCommentsCount(videoId: removeVideoIndex);
    } else if (choice == "Report Comment") {
      if (kDebugMode) {
        print('Report Comment');
      }
      callApiForReportCommentReason(selectedCommentId);
    }
  }

  void choiceActionOnlyReport(String choice) {
    if (choice == "Report Comment") {
      if (kDebugMode) {
        print('Report Comment');
      }
      callApiForReportCommentReason(selectedCommentId);
    }
  }

  void callApiForLikedVideo(int? id, BuildContext context) {
    if (kDebugMode) {
      print("likeid:$id");
    }
    RestClient(ApiHeader().dioData()).likevideo(id).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      // if (kDebugMode) {
      //   print("likevideosucees:$success");
      // }
      if (success == false) {
        var msg = body['msg'];
        Constants.toastMessage(msg);
      }
    }).catchError((Object obj) {
      Constants.toastMessage("Server Error");
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  Future<List<CommentData>> callApiForGetComment() async {
    await RestClient(ApiHeader().dioData())
        .getvideocomment(widget.listOfAll[widget.index].id)
        .then((response) {
      if (response.success == true) {
        likeCommentShareProvider.commentList.clear();
        if (response.data!.isNotEmpty) {
          likeCommentShareProvider.commentList.addAll(response.data!);
        }
        likeCommentShareProvider.notify();
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
    return likeCommentShareProvider.commentList;
  }

  callApiForReportVideoReason(int? videoId) async {
    reportReasonData.clear();
    await RestClient(ApiHeader().dioData())
        .reportReason("Video")
        .then((response) {
      if (response.success == true) {
        reportReasonData.addAll(response.data!);
        openReportBottomSheet(videoId);
      } else {
        Constants.toastMessage(response.msg!);
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            Constants.toastMessage('$responseCode');
            if (kDebugMode) {
              print(responseCode);
            }
            if (kDebugMode) {
              print(res.statusMessage);
            }
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("code:$responseCode");
            }
            if (kDebugMode) {
              print("msg:$msg");
            }
            Constants.toastMessage('$responseCode');
          } else if (responseCode == 500) {
            if (kDebugMode) {
              print("code:$responseCode");
            }
            if (kDebugMode) {
              print("msg:$msg");
            }
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  callApiForBlockUser(int? userid) async {
    await RestClient(ApiHeader().dioData())
        .blockuser(userid.toString(), "User")
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }

      if (success == true) {
        var msg = body['msg'];
        Constants.toastMessage(msg);
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  callApiForReportCommentReason(int? commentId) async {
    reportReasonData.clear();
    await RestClient(ApiHeader().dioData())
        .reportReason("Comment")
        .then((response) {
      if (response.success == true) {
        reportReasonData.addAll(response.data!);
        openReportBottomSheetComment(commentId);
      } else {
        Constants.toastMessage(response.msg!);
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
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

  Future<void> callApiForNotInterestedVideo(int? videoId) async {
    await RestClient(ApiHeader().dioData())
        .notInterested(videoId)
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        Navigator.pop(context);
        var msg = body['msg'];
        Constants.toastMessageLongTime(msg);
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
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

  Future<void> callApiForSaveVideo(int? id) async {
    if (kDebugMode) {
      print("likeid:$id");
    }
    await RestClient(ApiHeader().dioData()).savevideo(id).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        var msg = body['msg'];
        Constants.toastMessage(msg);
        var tile = trendingVidList.firstWhere((item) => item.id == id);
        tile.isSaved == 1 ? tile.isSaved = 0 : tile.isSaved = 1;
        likeCommentShareProvider.notify();
      } else {
        var msg = body['msg'];
        Constants.toastMessage(msg);
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  Future<bool> callApiForDeleteComment(int? id) async {
    try {
      String? response =
          await RestClient(ApiHeader().dioData()).deleteComment(id);
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        var msg = body['msg'];
        Constants.toastMessage(msg);
        return true;
      } else {
        return false;
      }
    } catch (obj) {
      Constants.toastMessage(obj.toString());
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
      return false;
    }
  }

  callApiForReport(videoId, reportId) async {
    await RestClient(ApiHeader().dioData())
        .reportVideo(videoId.toString(), reportId.toString())
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        var msg = body['msg'];
        Constants.toastMessage('$msg');
        Navigator.pop(context);
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            Constants.toastMessage('$responseCode');
            if (kDebugMode) {
              print(responseCode);
            }
            if (kDebugMode) {
              print(res.statusMessage);
            }
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("code:$responseCode");
            }
            if (kDebugMode) {
              print("msg:$msg");
            }
            Constants.toastMessage('$responseCode');
          } else if (responseCode == 500) {
            if (kDebugMode) {
              print("code:$responseCode");
            }
            if (kDebugMode) {
              print("msg:$msg");
            }
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  void _openSavedBottomSheet(int? id, int? isSaved, int? userid) {
    if (kDebugMode) {
      print("savedid123:$id");
    }
    if (kDebugMode) {
      print("isSaved123:$isSaved");
    }

    String save = "Save";

    if (isSaved == 1) {
      save = "Remove From Saved";
    } else if (isSaved == 0) {
      save = "Save";
    }

    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: Color(Constants.bgblack),
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Wrap(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      if (PreferenceUtils.getBool(Constants.isLoggedIn) ==
                          true) {
                        Constants.checkNetwork().whenComplete(
                            () => callApiForReportVideoReason(id));
                      } else {
                        Constants.toastMessage('Please Login First To Report');
                      }
                      // Constants.CheckNetwork().whenComplete(() =>   CallApiForSavevideo(id));
                      // Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 0, left: 0, bottom: 0),
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
                  ),
                  InkWell(
                    onTap: () {
                      Constants.checkNetwork()
                          .whenComplete(() => callApiForBlockUser(userid));
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        "Block This User",
                        style: TextStyle(
                            color: Color(Constants.whitetext),
                            fontSize: 16,
                            fontFamily: Constants.appFont),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Constants.checkNetwork()
                          .whenComplete(() => callApiForNotInterestedVideo(id));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        "I'm Not Interested",
                        style: TextStyle(
                            color: Color(Constants.whitetext),
                            fontSize: 16,
                            fontFamily: Constants.appFont),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Constants.checkNetwork()
                          .whenComplete(() => callApiForSaveVideo(id));
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        save,
                        style: TextStyle(
                            color: Color(Constants.whitetext),
                            fontSize: 16,
                            fontFamily: Constants.appFont),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  Future callApiForLikeComment(int? id, BuildContext context, int index) async {
    if (kDebugMode) {
      print("likeid:$id");
    }
    await RestClient(ApiHeader().dioData()).likecomment(id).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == false) {
        var msg = body['msg'];
        Constants.toastMessage(msg);
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  callApiForPostComment(
      String comment, BuildContext context, int? id, int index) async {
    if (kDebugMode) {
      print("likeid:$id");
    }
    await RestClient(ApiHeader().dioData())
        .postcomment(id.toString(), comment)
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        _textCommentController.clear();
        updateCommentsCount(videoId: widget.listOfAll[index].id);
        var msg = body['msg'];
        Constants.toastMessage('$msg');
        callApiForGetComment();
        FocusScope.of(context).unfocus();
        likeCommentShareProvider.notify();
      } else {
        var msg = body['msg'];
        Constants.toastMessage('$msg');
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());

      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  callApiForReportComment(commentId, reportId) async {
    await RestClient(ApiHeader().dioData())
        .reportComment(commentId.toString(), reportId.toString())
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        var msg = body['msg'];
        Constants.toastMessage('$msg');
        Navigator.pop(context);
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            Constants.toastMessage('$responseCode');
            if (kDebugMode) {
              print(responseCode);
            }
            if (kDebugMode) {
              print(res.statusMessage);
            }
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("code:$responseCode");
            }
            if (kDebugMode) {
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

  void _openCommentLayout(int index1, videoIndex) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Color(Constants.bgblack),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter myState) {
            myState(() {});
            // inAsyncCall: showSpinner,
            // opacity: 1.0,
            // color: Colors.transparent.withOpacity(0.2),
            // progressIndicator: CustomLoader(),
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  /// total comment show
                  Container(
                    margin: EdgeInsets.only(
                        top: ScreenUtil().setHeight(50),
                        left: 0,
                        bottom: ScreenUtil().setHeight(20)),
                    height: ScreenUtil().setHeight(50),
                    color: const Color(0xFF1d1d1d),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Text(
                              widget.listOfAll[index1].commentCount.toString() +
                                  " Comments",
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

                  /// comments
                  Expanded(
                    child: FutureBuilder<List<CommentData>>(
                      future: _getCommentFeatureBuilder,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            return (snapshot.data?.length ?? 0) > 0
                                ? ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: likeCommentShareProvider
                                        .commentList.length,
                                    itemBuilder: (context, index) {
                                      if (likeCommentShareProvider
                                              .commentList[index].isLike ==
                                          1) {
                                        likeCommentShareProvider
                                            .commentList[index]
                                            .showwhite = false;
                                        likeCommentShareProvider
                                            .commentList[index].showred = true;
                                      } else {
                                        likeCommentShareProvider
                                            .commentList[index]
                                            .showwhite = true;
                                        likeCommentShareProvider
                                            .commentList[index].showred = false;
                                      }
                                      return Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, top: 10, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, bottom: 10),
                                                child: CachedNetworkImage(
                                                  alignment: Alignment.center,
                                                  imageUrl:
                                                      likeCommentShareProvider
                                                              .commentList[
                                                                  index]
                                                              .user!
                                                              .imagePath! +
                                                          likeCommentShareProvider
                                                              .commentList[
                                                                  index]
                                                              .user!
                                                              .image!,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor:
                                                        const Color(0xFF36446b),
                                                    child: CircleAvatar(
                                                      radius: 15,
                                                      backgroundImage:
                                                          imageProvider,
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      const CustomLoader(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Image.asset(
                                                          "images/no_image.png"),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 6,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              bottom: 0),
                                                      color: Colors.transparent,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            likeCommentShareProvider
                                                                .commentList[
                                                                    index]
                                                                .user!
                                                                .name!,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .greytext),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    Constants
                                                                        .appFont),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 10),
                                                        color:
                                                            Colors.transparent,
                                                        child: Text(
                                                          likeCommentShareProvider
                                                              .commentList[
                                                                  index]
                                                              .comment!,
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
                                                          int commentLikeCountConvert =
                                                              int.parse(likeCommentShareProvider
                                                                  .commentList[
                                                                      index]
                                                                  .likesCount
                                                                  .toString());
                                                          if (likeCommentShareProvider
                                                                  .commentList[
                                                                      index]
                                                                  .isLike ==
                                                              1) {
                                                            commentLikeCountConvert -=
                                                                1;
                                                          } else {
                                                            commentLikeCountConvert +=
                                                                1;
                                                          }
                                                          var tile = likeCommentShareProvider
                                                              .commentList
                                                              .firstWhere((item) =>
                                                                  item.id ==
                                                                  likeCommentShareProvider
                                                                      .commentList[
                                                                          index]
                                                                      .id);
                                                          tile.isLike = 0;
                                                          tile.showwhite = true;
                                                          tile.showred = false;
                                                          tile.likesCount =
                                                              commentLikeCountConvert
                                                                  .toString();
                                                          Constants
                                                                  .checkNetwork()
                                                              .whenComplete(() =>
                                                                  callApiForLikeComment(
                                                                      likeCommentShareProvider
                                                                          .commentList[
                                                                              index]
                                                                          .id,
                                                                      context,
                                                                      index));
                                                          myState(() {});
                                                        },
                                                        child: Visibility(
                                                          visible:
                                                              likeCommentShareProvider
                                                                  .commentList[
                                                                      index]
                                                                  .showred,
                                                          child:
                                                              SvgPicture.asset(
                                                            "images/red_heart.svg",
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          int commentLikeCountConvert =
                                                              int.parse(likeCommentShareProvider
                                                                  .commentList[
                                                                      index]
                                                                  .likesCount
                                                                  .toString());
                                                          if (likeCommentShareProvider
                                                                  .commentList[
                                                                      index]
                                                                  .isLike ==
                                                              1) {
                                                            commentLikeCountConvert -=
                                                                1;
                                                          } else {
                                                            commentLikeCountConvert +=
                                                                1;
                                                          }
                                                          var tile = likeCommentShareProvider
                                                              .commentList
                                                              .firstWhere((item) =>
                                                                  item.id ==
                                                                  likeCommentShareProvider
                                                                      .commentList[
                                                                          index]
                                                                      .id);
                                                          tile.isLike = 1;
                                                          tile.showwhite =
                                                              false;
                                                          tile.showred = true;
                                                          tile.likesCount =
                                                              commentLikeCountConvert
                                                                  .toString();
                                                          Constants
                                                                  .checkNetwork()
                                                              .whenComplete(() =>
                                                                  callApiForLikeComment(
                                                                      likeCommentShareProvider
                                                                          .commentList[
                                                                              index]
                                                                          .id,
                                                                      context,
                                                                      index));
                                                          myState(() {});
                                                        },
                                                        child: Visibility(
                                                          visible:
                                                              likeCommentShareProvider
                                                                  .commentList[
                                                                      index]
                                                                  .showwhite,
                                                          child:
                                                              SvgPicture.asset(
                                                            "images/white_heart.svg",
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        likeCommentShareProvider
                                                            .commentList[index]
                                                            .likesCount
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .whitetext),
                                                            fontFamily:
                                                                Constants
                                                                    .appFont,
                                                            fontSize: 14),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  )),
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
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    18.0))),
                                                offset: const Offset(20, 20),
                                                onSelected:
                                                    likeCommentShareProvider
                                                                .commentList[
                                                                    index]
                                                                .canDelete ==
                                                            1
                                                        ? (choice) async {
                                                            if (choice ==
                                                                "Delete Comment") {
                                                              if (kDebugMode) {
                                                                if (kDebugMode) {
                                                                  print(
                                                                      'delete comment');
                                                                }
                                                              }
                                                              bool apiStatus =
                                                                  await callApiForDeleteComment(
                                                                      selectedCommentId);
                                                              if (apiStatus) {
                                                                likeCommentShareProvider
                                                                    .commentList
                                                                    .removeAt(
                                                                        index);
                                                                myState(() {});
                                                              }
                                                              removeCommentsCount(
                                                                  videoId:
                                                                      removeVideoIndex);
                                                            } else if (choice ==
                                                                "Report Comment") {
                                                              if (kDebugMode) {
                                                                print(
                                                                    'Report Comment');
                                                              }
                                                              callApiForReportCommentReason(
                                                                  selectedCommentId);
                                                            }
                                                          }
                                                        : choiceActionOnlyReport,
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  selectedCommentId =
                                                      likeCommentShareProvider
                                                          .commentList[index]
                                                          .id;
                                                  removeVideoIndex = videoIndex;
                                                  if (likeCommentShareProvider
                                                          .commentList[index]
                                                          .canDelete ==
                                                      1) {
                                                    return choices
                                                        .map((String choice) {
                                                      return PopupMenuItem<
                                                          String>(
                                                        value: choice,
                                                        child: Text(
                                                          choice,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  Constants
                                                                      .whitetext),
                                                              fontSize: 14,
                                                              fontFamily: Constants
                                                                  .appFontBold),
                                                        ),
                                                      );
                                                    }).toList();
                                                  } else {
                                                    return choicesReportOnly
                                                        .map((String choice) {
                                                      return PopupMenuItem<
                                                          String>(
                                                        value: choice,
                                                        child: Text(
                                                          choice,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  Constants
                                                                      .whitetext),
                                                              fontSize: 14,
                                                              fontFamily: Constants
                                                                  .appFontBold),
                                                        ),
                                                      );
                                                    }).toList();
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : Align(
                                    alignment: Alignment.center,
                                    child: NoPostAvailable(
                                      subject: "Comments",
                                    ),
                                  );
                          case ConnectionState.none:
                            return const CustomLoader();
                          case ConnectionState.waiting:
                            return const CustomLoader();
                          case ConnectionState.active:
                            return const CustomLoader();
                          default:
                            return const CustomLoader();
                        }
                      },
                    ),
                  ),

                  /// type comments
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 0, bottom: 0),
                    padding: const EdgeInsets.only(left: 10),
                    height: ScreenUtil().setHeight(50),
                    color: const Color(0xFF1d1d1d),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextField(
                              autofocus: false,
                              controller: _textCommentController,
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
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: () {
                              if (trendingVidList[index1].user.isCommentBlock ==
                                  0) {
                                if (_textCommentController.text.isNotEmpty) {
                                  Constants.checkNetwork()
                                      .whenComplete(() async {
                                    // return callApiForPostComment(_textCommentController.text, context, widget.listOfAll[index1].id, index1);
                                    // callApiForPostComment(String comment, BuildContext context, int? id, int index) async {
                                    if (kDebugMode) {
                                      print(
                                          "like id:${widget.listOfAll[index1].id}");
                                    }
                                    await RestClient(ApiHeader().dioData())
                                        .postcomment(
                                            widget.listOfAll[index1].id
                                                .toString(),
                                            _textCommentController.text)
                                        .then((response) async {
                                      final body = json.decode(response!);
                                      bool? success = body['success'];
                                      if (kDebugMode) {
                                        print(success);
                                      }
                                      if (success == true) {
                                        _textCommentController.clear();
                                        updateCommentsCount(
                                            videoId:
                                                widget.listOfAll[index1].id);
                                        var msg = body['msg'];
                                        Constants.toastMessage('$msg');
                                        await RestClient(ApiHeader().dioData())
                                            .getvideocomment(widget
                                                .listOfAll[widget.index].id)
                                            .then((response) {
                                          if (response.success == true) {
                                            likeCommentShareProvider.commentList
                                                .clear();
                                            if (response.data!.isNotEmpty) {
                                              likeCommentShareProvider
                                                  .commentList
                                                  .addAll(response.data!);
                                            }
                                            likeCommentShareProvider.notify();
                                          }
                                        }).catchError((Object obj) {
                                          Constants.toastMessage(
                                              obj.toString());
                                          if (kDebugMode) {
                                            print("error:$obj");
                                            print(obj.runtimeType);
                                          }
                                        });
                                        FocusScope.of(context).unfocus();
                                        likeCommentShareProvider.notify();
                                      } else {
                                        var msg = body['msg'];
                                        Constants.toastMessage('$msg');
                                      }
                                      myState(() {});
                                    }).catchError((Object obj) {
                                      Constants.toastMessage(obj.toString());
                                      if (kDebugMode) {
                                        print("error:$obj");
                                        print(obj.runtimeType);
                                      }
                                    });
                                  });
                                }
                              } else {
                                Constants.toastMessage(
                                    "${trendingVidList[index1].user.name} Blocked Comment");
                              }
                            },
                            child: SvgPicture.asset("images/post_comment.svg"),
                          ),
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

  void openReportBottomSheet(int? videoId) {
    int? value;
    int? reasonId;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Color(Constants.bgblack),
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter mystate) {
              mystate(() {});
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Scaffold(
                  backgroundColor: Color(Constants.bgblack1),
                  bottomNavigationBar: InkWell(
                    onTap: reasonId == null
                        ? null
                        : () {
                            Constants.checkNetwork().whenComplete(
                                () => callApiForReport(videoId, reasonId));
                          },
                    child: Container(
                      height: ScreenUtil().setHeight(50),
                      color: const Color(0xff36446B),
                      alignment: Alignment.center,
                      child: Text(
                        'Submit Report',
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
                                        onChanged: (dynamic val) => mystate(() {
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

  void openReportBottomSheetComment(int? commentId) {
    int? value;
    int? reasonId;
    showModalBottomSheet(
        context: context,
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
                            Constants.checkNetwork().whenComplete(() =>
                                callApiForReportComment(commentId, reasonId));
                          },
                    child: Container(
                      height: ScreenUtil().setHeight(50),
                      color: const Color(0xff36446B),
                      alignment: Alignment.center,
                      child: Text(
                        'Submit Report',
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
}

class LikeCommentShareProvider extends ChangeNotifier {
  List<CommentData> commentList = <CommentData>[];

  notify() {
    notifyListeners();
  }
}
