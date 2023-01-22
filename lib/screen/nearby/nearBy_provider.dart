import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../../apiservice/Api_Header.dart';
import '../../apiservice/Apiservice.dart';
import '../../model/report_reason.dart';
import '../../model/trendingVideoModel.dart';
import '../../model/videocomment.dart';
import '../../util/constants.dart';
import '../../util/preference_utils.dart';

class NearByProvider extends ChangeNotifier {
  bool isRememberMe = false;
  bool showRed = false;
  bool showWhite = true;
  bool showGridView = true;
  bool halfStatus = true;
  bool fullStatus = false;
  bool showMore = true;
  bool showLess = false;
  PageController nearByController = PageController();
  List<int?> savedItem = <int?>[];
  late Future<List<TrendingData>> getVideoFeatureBuilder;
  List<TrendingData> nearByVidList = <TrendingData>[];
  List<CommentData> commentList = <CommentData>[];
  int? selectedCommentId = 0;
  int? removeVideoIndex;
  GlobalKey<ScaffoldState> nearByProviderScaffoldKey = GlobalKey<ScaffoldState>();
  // final _textCommentController = TextEditingController();
  List<ReportReasonData> reportReasonData = [];
  bool adMobNative = false;
  List<String> storeAdNetworkData = [];
  int setLoop = 0;
  static const List<String> choices = <String>["Delete Comment", "Report Comment"];

  NearByProvider() {
    getVideoFeatureBuilder = callApiForNearByVideo();
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
      }
      else {
        adMobNative = false;
      }
    }
  }

  Future<List<TrendingData>> callApiForNearByVideo() async {
    LocationData _locationData;
    Location _location = Location();
    _locationData = await _location.getLocation();
    await RestClient(ApiHeader().dioData())
        .getNearByVideo(_locationData.latitude, _locationData.longitude)
        .then((response) {
      if (response.success == true) {
        if (kDebugMode) {
          print("lenght123456:${nearByVidList.length}");
        }
        if (response.data!.isNotEmpty) {
          nearByVidList.clear();
          nearByVidList.addAll(response.data!);
          if (kDebugMode) {
            print("nearbyvideo.length:${nearByVidList.length}");
          }
        }
        notifyListeners();
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
    return nearByVidList;
  }

  Future<void> callApiForNearByVideoSearched(latitude, longitude) async {
    RestClient(ApiHeader().dioData()).getNearByVideo(latitude, longitude).then((response) {
      if (response.success == true) {
        if (kDebugMode) {
          print("length123456:${nearByVidList.length}");
        }
        if (response.data!.isNotEmpty) {
          nearByVidList.clear();
          nearByVidList.addAll(response.data!);
          if (kDebugMode) {
            print("nearby video.length:${nearByVidList.length}");
          }
        }
        notifyListeners();
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  Future<void> callApiForLikedVideo(int? id, BuildContext context) async {
    if (kDebugMode) {
      print("like id:$id");
    }
    await RestClient(ApiHeader().dioData()).likevideo(id).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print("like video success:$success");
      }
      if (success == false) {
        var msg = body['msg'];
        Constants.toastMessage(msg.toString());
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  Future<void> callApiForFollowRequest(int? userId, int? videoId) async {
    await RestClient(ApiHeader().dioData()).followRequest(userId).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        var msg = body['msg'];
        Constants.toastMessage(msg);
        updateFollow(videoId: videoId);
        for (var singleVid in nearByVidList) {
          if (singleVid.userId == userId.toString()) {
            if (singleVid.user?.followerRequest == "0") {
              singleVid.user?.isFollowing = 1;
            }else{
              singleVid.user?.isRequested = 1;
            }
          }
        }
        notifyListeners();
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
        for (var singleVid in nearByVidList) {
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

  void updateFollow({int? videoId}) {
    final tile = nearByVidList.firstWhere((item) => item.id == videoId);

    tile.user!.isFollowing = 1;
    notifyListeners();
  }

  void updateUnFollow({int? videoId}) {
    final tile = nearByVidList.firstWhere((item) => item.id == videoId);

    tile.user!.isFollowing = 0;
    notifyListeners();
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

  notify() {
    notifyListeners();
  }
}
