import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../apiservice/Api_Header.dart';
import '../../apiservice/Apiservice.dart';
import '../../model/notification_model.dart';
import '../../util/constants.dart';

class NotificationProvider extends ChangeNotifier {
  bool isRememberMe = false;
  bool showSpinner = false;
  bool showRed = false;
  bool showWhite = true;
  String deviceToken = "";
  bool showFollowing = false;
  bool showFollow = true;
  bool isNotificationClicked = false;
  int? followRequestCount = 0;
  List<Current> currentList = <Current>[];
  List<LastSeven> lastSevenList = <LastSeven>[];
  late Future<int> notificationFuture;

  NotificationProvider() {
    notificationFuture = callApiForNotification();
  }

  Future<int> callApiForNotification() async {
    int tempPassData = 0;
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).notificationRequest().then((response) {
      currentList.clear();
      lastSevenList.clear();
      if (response.success == true) {
        showSpinner = false;
        followRequestCount = response.data!.requesteCount;
        currentList.addAll(response.data!.current!);
        lastSevenList.addAll(response.data!.lastSeven!);
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
    if (currentList.isNotEmpty) {
      tempPassData = currentList.length;
    }
    if (lastSevenList.isNotEmpty) {
      tempPassData += lastSevenList.length;
    }
    return tempPassData;
  }

  Future<void> callApiForConfirmRequest(int? userId) async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).followRequest(userId).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Constants.checkNetwork().whenComplete(() => callApiForNotification());
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

  Future<void> callApiForDeleteRequest(int? userId) async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).rejectRequest(userId).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Constants.checkNetwork().whenComplete(() => callApiForNotification());
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

  Future<void> callApiForAcceptRequest(int? userId) async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).acceptRequest(userId).then((response) {
      final body = json.decode(response);
      bool? success = body['success'];
      if (success == true) {
        showSpinner = false;
        Constants.toastMessage(body['msg'].toString());
        Constants.checkNetwork().whenComplete(() => callApiForNotification());
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

  Future<void> callApiForFollowBack(int? userId) async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).followRequest(userId).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Constants.checkNetwork().whenComplete(() => callApiForNotification());
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
