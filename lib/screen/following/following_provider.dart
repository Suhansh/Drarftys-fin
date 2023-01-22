import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../apiservice/Api_Header.dart';
import '../../apiservice/Apiservice.dart';
import '../../model/report_reason.dart';
import '../../model/trendingVideoModel.dart';
import '../../model/videocomment.dart';
import '../../util/constants.dart';
import '../../util/preference_utils.dart';

class FollowingProvider extends ChangeNotifier {
  bool halfStatus = true;
  bool fullStatus = false;
  bool showMore = true;
  bool showLess = false;
  bool isLike = false;
  PageController followingPageController = PageController();
  int? removeVideoIndex;
  final textCommentController = TextEditingController();
  late Future<List<TrendingData>> getVideoFeatureBuilder;
  List<TrendingData> followingVidList = <TrendingData>[];
  List<CommentData> commentList = <CommentData>[];
  int? selectedCommentId = 0;
  static const List<String> choices = <String>["Delete Comment", "Report Comment"];
  List<ReportReasonData> reportReasonData = [];
  bool adMobNative = false;
  List<String> storeAdNetworkData = [];
  int setLoop = 0;
  GlobalKey<ScaffoldState> followingProviderScaffoldKey = GlobalKey<ScaffoldState>();

  FollowingProvider() {
    getVideoFeatureBuilder = callApiForFollowingVideo();
    if (PreferenceUtils.getBool(Constants.adAvailable) == true) {
      setLoop = PreferenceUtils.getStringList(Constants.adNetwork).length;
    }
    for (int i = 0; i < setLoop; i++) {
      storeAdNetworkData.add(PreferenceUtils.getStringList(Constants.adNetwork)[i]);
    }
    storeAdNetworkData.sort();
    for (int i = 0; i < setLoop; i++) {
      if (storeAdNetworkData[i] == "admob" &&
          PreferenceUtils.getStringList(Constants.adStatus)[i] == "1" &&
          PreferenceUtils.getStringList(Constants.adType)[i] == "Native") {
        adMobNative = true;
        break;
      } else {
        adMobNative = false;
      }
    }
  }

  changeFullStatus() {
    halfStatus = !halfStatus;
    fullStatus = !fullStatus;
    showMore = !showMore;
    notifyListeners();
  }

  setHalfStatus() {
    halfStatus = true;
    fullStatus = false;
    showMore = true;
    notifyListeners();
  }

  void updateLike({int? videoId, String? totalLikes, bool? videoLike}) {
    final tile = followingVidList.firstWhere((item) => item.id == videoId);
    tile.likeCount = totalLikes;
    tile.isLike = videoLike;
    notifyListeners();
  }

  updateCommentsCount({int? videoId}) {
    final tile = followingVidList.firstWhere((item) => item.id == videoId);
    int commentCount = int.parse(tile.commentCount.toString());
    commentCount += 1;
    tile.commentCount = commentCount.toString();
    notifyListeners();
  }

  removeCommentsCount({int? videoId}) {
    final tile = followingVidList.firstWhere((item) => item.id == videoId);
    int commentCount = int.parse(tile.commentCount.toString());
    commentCount -= 1;
    tile.commentCount = commentCount.toString();
    notifyListeners();
  }

  void updateFollow({int? videoId}) {
    final tile = followingVidList.firstWhere((item) => item.id == videoId);
    tile.user!.isFollowing = 1;
    notifyListeners();
  }

  void updateUnFollow({int? videoId}) {
    final tile = followingVidList.firstWhere((item) => item.id == videoId);

    tile.user!.isFollowing = 0;

    notifyListeners();
  }

  Future<List<TrendingData>> callApiForFollowingVideo() async {
    await RestClient(ApiHeader().dioData()).getFollowingVideo().then((response) {
      if (response.success == true) {
        if (kDebugMode) {
          print("lenght123456:${followingVidList.length}");
        }
        if (response.data!.isNotEmpty) {
          followingVidList.clear();
          followingVidList.addAll(response.data!);
          if (kDebugMode) {
            print("followingvidlist.length:${followingVidList.length}");
          }
        }
      }
      notifyListeners();
    }).catchError((Object obj) {
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
    return followingVidList;
  }

  Future<void> callApiForLikeComment(int? id, BuildContext context, int index) async {
    if (kDebugMode) {
      print("likeid:$id");
    }
    await RestClient(ApiHeader().dioData()).likecomment(id).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        Navigator.pop(context);
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());
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
      callApiForDeleteComment(selectedCommentId, followingProviderScaffoldKey.currentContext!);
    } else if (choice == "Report Comment") {
      if (kDebugMode) {
        print('Report Comment');
      }
      callApiForReportCommentReason(selectedCommentId);
    }
  }

  Future<void> callApiForDeleteComment(int? id, BuildContext context) async {
    await RestClient(ApiHeader().dioData()).deleteComment(id).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Navigator.of(context).pop();
        // Constants.createSnackBar(msg, context, Color(Constants.redtext));

      } else {
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Navigator.of(context).pop();
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
    await RestClient(ApiHeader().dioData()).reportReason("Comment").then((response) {
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

  callApiForReportComment(commentId, reportId) async {
    await RestClient(ApiHeader().dioData())
        .reportComment(commentId.toString(), reportId.toString())
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        var msg = body['msg'];
        // Constants.createSnackBar(

        Constants.toastMessage('$msg');
        Navigator.pop(followingProviderScaffoldKey.currentContext!);
        // Constants.createSnackBar(msg, context, Color(Constants.redtext));
      } else {
        var msg = body['msg'];
        Constants.toastMessage('$msg');
        Navigator.pop(followingProviderScaffoldKey.currentContext!);
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

  void openReportBottomSheetComment(int? commentId) {
    int? value;
    int? reasonId;

    showModalBottomSheet(
        context: followingProviderScaffoldKey.currentContext!,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Color(Constants.bgblack),
        builder: (context) => StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
              mystate(() {});
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Scaffold(
                  backgroundColor: Color(Constants.bgblack1),
                  bottomNavigationBar: InkWell(
                    onTap: reasonId == null
                        ? null
                        : () {
                            Constants.checkNetwork()
                                .whenComplete(() => callApiForReportComment(commentId, reasonId));
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
                                    child: const Icon(Icons.close, color: Colors.white))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.50,
                          child: ListView(
                            // crossAxisAlignment: CrossAxisAlignment.stretch,

                            children: <Widget>[
                              SingleChildScrollView(
                                child: ListView.builder(
                                  itemCount: reportReasonData.length,
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Color(Constants.whitetext),
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

  void callApiForFollowRequest(int? userId, int? videoId) {
    RestClient(ApiHeader().dioData()).followRequest(userId).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        var msg = body['msg'];
        Constants.toastMessage(msg);
        updateFollow(videoId: videoId);
        for (var singleVid in followingVidList) {
          if (singleVid.userId == userId.toString()) {
            if (singleVid.user?.followerRequest == "0") {
              singleVid.user?.isFollowing = 1;
            } else {
              singleVid.user?.isRequested = 1;
            }
          }
        }
        notifyListeners();
      } else {
        var msg = body['msg'];
        Constants.toastMessage(msg);
        updateFollow(videoId: videoId);
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

  Future<void> callApiForUnFollowRequest(int? userId, int? videoId) async {
    await RestClient(ApiHeader().dioData()).unFollowRequest(userId).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        var msg = body['msg'];
        Constants.toastMessage(msg);
        updateUnFollow(videoId: videoId);
        for (var singleVid in followingVidList) {
          if (singleVid.userId == userId.toString()) {
            singleVid.user?.isFollowing = 0;
            notifyListeners();
          }
        }
      } else {
        var msg = body['msg'];
        Constants.toastMessage(msg);
        updateUnFollow(videoId: videoId);
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

  callApiForPostComment(String comment, BuildContext context, int? id) async {
    if (kDebugMode) {
      print("likeid:$id");
    }
    await RestClient(ApiHeader().dioData()).postcomment(id.toString(), comment).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        // Navigator.pop(context);
        Constants.checkNetwork().whenComplete(() => callApiForFollowingVideo());
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }
}
