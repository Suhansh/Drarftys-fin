import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../apiservice/Api_Header.dart';
import '../../apiservice/Apiservice.dart';
import '../../model/trendingVideoModel.dart';
import '../../util/constants.dart';
import '../../util/preference_utils.dart';
import 'package:dio/dio.dart';

class TrendingProvider extends ChangeNotifier {
  bool halfStatus = true;
  bool fullStatus = false;
  bool showMore = true;
  List<TrendingData> trendingVidList = <TrendingData>[];
  late Future<List<TrendingData>> getVideoFeatureBuilder;
  // bool noData = true;
  // bool showData = false;
  bool adMobNative = false;
  List<String> storeAdNetworkData = [];
  int setLoop = 0;

  TrendingProvider() {
    getVideoFeatureBuilder = callApiForTrendingVideo();
    if (PreferenceUtils.getBool(Constants.adAvailable) == true) {
      setLoop = PreferenceUtils.getStringList(Constants.adNetwork).length;
      for (int i = 0; i < setLoop; i++) {
        storeAdNetworkData.add(PreferenceUtils.getStringList(Constants.adNetwork)[i]);
      }
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


  Future<List<TrendingData>> callApiForTrendingVideo() async {
    await RestClient(ApiHeader().dioData()).gettrendingvideo().then((response) {
      if (response.success == true) {
        if (kDebugMode) {
          print("length123456:${trendingVidList.length}");
        }
        if (response.data != null && (response.data?.length ?? 0) > 0) {
          trendingVidList.clear();
          trendingVidList.addAll(response.data!);
          if (kDebugMode) {
            print("trending vid list length:${trendingVidList.length}");
          }
          // noData = false;
          // showData = true;
          notifyListeners();
        }
      } else {
        // noData = true;
        // showData = false;
        notifyListeners();
      }
    }).catchError((Object obj) {
      // noData = true;
      // showData = false;
      notifyListeners();
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
      Constants.toastMessage("Internal Server Error");
    });
    return trendingVidList;
  }

  Future<void> callApiForFollowRequest(int? userId, int? videoId) async {
    await RestClient(ApiHeader().dioData()).followRequest(userId).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        var msg = body['msg'];
        Constants.toastMessage(msg);
        updateFollow(videoId: videoId);
        for (var singleVid in trendingVidList) {
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
        for (var singleVid in trendingVidList) {
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

  setHalfStatus() {
    halfStatus = true;
    fullStatus = false;
    showMore = true;
    notifyListeners();
  }

  changeFullStatus() {
    halfStatus = !halfStatus;
    fullStatus = !fullStatus;
    showMore = !showMore;
    notifyListeners();
  }

  void updateFollow({int? videoId}) {
    final tile = trendingVidList.firstWhere((item) => item.id == videoId);
    tile.user!.isFollowing = 1;
    notifyListeners();
  }

  void updateUnFollow({int? videoId}) {
    final tile = trendingVidList.firstWhere((item) => item.id == videoId);
    tile.user!.isFollowing = 0;
    notifyListeners();
  }
}
