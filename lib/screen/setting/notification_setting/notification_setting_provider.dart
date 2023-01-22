import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../apiservice/Api_Header.dart';
import '../../../apiservice/Apiservice.dart';
import '../../../util/constants.dart';

class NotificationSettingProvider extends ChangeNotifier {
  bool showSpinner = false;
  bool muteAllNotification = false;
  bool postAndComment = false;
  bool likeToggle = false;
  bool commentToggle = false;
  bool followingAndFollowers = false;
  bool followingRequest = false;

  NotificationSettingProvider() {
    callApiForGetNotificationData();
  }

  Future<void> callApiForSaveNotification(BuildContext context) async {
    showSpinner = true;
    notifyListeners();
    Map<String, dynamic> body;
    if (muteAllNotification == true) {
      body = {
        "mention_not": 0,
        "like_not": 0,
        "comment_not": 0,
        "follow_not": 0,
        "request_not": 0,
      };
    } else {
      int mentionNot;
      int like;
      int comment;
      int follow;
      int request;
      if (postAndComment == true) {
        mentionNot = 1;
      } else {
        mentionNot = 0;
      }
      if (likeToggle == true) {
        like = 1;
      } else {
        like = 0;
      }
      if (commentToggle == true) {
        comment = 1;
      } else {
        comment = 0;
      }
      if (followingAndFollowers == true) {
        follow = 1;
      } else {
        follow = 0;
      }
      if (followingRequest == true) {
        request = 1;
      } else {
        request = 0;
      }
      body = {
        "mention_not": mentionNot,
        "like_not": like,
        "comment_not": comment,
        "follow_not": follow,
        "request_not": request,
      };
    }
    await RestClient(ApiHeader().dioData()).notificationSave(body).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Navigator.pop(context);
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

  Future<void> callApiForGetNotificationData() async {
      showSpinner = true;
      notifyListeners();
    await RestClient(ApiHeader().dioData()).notificationGetSetting().then((response) {
      if (response.success == true) {

          showSpinner = false;
          if (response.data!.mentionNot == 0 &&
              response.data!.followerRequest == 0 &&
              response.data!.likeNot == 0 &&
              response.data!.commentNot == 0 &&
              response.data!.followNot == 0 &&
              response.data!.requestNot == 0) {
            muteAllNotification = true;
            postAndComment = false;
            likeToggle = false;
            commentToggle = false;
            followingAndFollowers = false;
            followingRequest = false;
          } else {
            muteAllNotification = false;
            response.data!.mentionNot == 1 ? postAndComment = true : postAndComment = false;
            response.data!.likeNot == 1 ? likeToggle = true : likeToggle = false;
            response.data!.commentNot == 1 ? commentToggle = true : commentToggle = false;
            response.data!.followNot == 1
                ? followingAndFollowers = true
                : followingAndFollowers = false;
            response.data!.requestNot == 1 ? followingRequest = true : followingRequest = false;
          }
        notifyListeners();
      } else {
          showSpinner = false;
          Constants.toastMessage("${response.msg}");
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
}
