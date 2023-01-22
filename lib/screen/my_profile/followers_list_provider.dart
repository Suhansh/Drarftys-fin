import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../apiservice/Api_Header.dart';
import '../../apiservice/Apiservice.dart';
import '../../model/own_following_followers.dart';
import '../../util/constants.dart';

class FollowersListProvider extends ChangeNotifier {
  bool showSpinner = false;
  TextEditingController searchController = TextEditingController();
  int? initialIndex;

  String followers = '';
  String following = '';
  String followerPageTitle = '';

  List<Followers> ownFollowersList = [];
  List<Followings> ownFollowingList = [];
  List<Followers> tempOwnFollowersList = [];
  List<Followings> tempOwnFollowingList = [];

  Future<void> callApiForOwnFollowers() async {
    ownFollowingList.clear();
    ownFollowersList.clear();
    tempOwnFollowersList.clear();
    tempOwnFollowingList.clear();
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).ownFollowingFollowers().then((response) {
      showSpinner = false;
      ownFollowersList.addAll(response.data!.followers!);
      ownFollowingList.addAll(response.data!.followings!);
      tempOwnFollowersList.addAll(response.data!.followers!);
      tempOwnFollowingList.addAll(response.data!.followings!);
      followers = tempOwnFollowersList.length.toString();
      following = tempOwnFollowingList.length.toString();
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

  callApiForBlockUser(int? userid,BuildContext context) async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).blockuser(userid.toString(), "User").then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        showSpinner = false;
        var msg = body['msg'];
        Constants.createSnackBar(msg, context, Color(Constants.redtext));

        Constants.checkNetwork().whenComplete(() => callApiForOwnFollowers());
        notifyListeners();
      } else {
        showSpinner = false;
        var msg = body['msg'];
        Constants.createSnackBar(msg, context, Color(Constants.redtext));
        notifyListeners();
      }
    }).catchError((Object obj) {
      Constants.createSnackBar("Server Error", context, Color(Constants.redtext));
      showSpinner = false;
      notifyListeners();
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  Future<void> callApiForUnFollowRequest(int? userId) async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).unFollowRequest(userId).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Constants.checkNetwork().whenComplete(() => callApiForOwnFollowers());
        notifyListeners();
      } else {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Constants.checkNetwork().whenComplete(() => callApiForOwnFollowers());
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
        Constants.checkNetwork().whenComplete(() => callApiForOwnFollowers());
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

  Future<void> callApiForRemoveFromFollowers(int? userId) async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).removeFromFollowRequest(userId).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Constants.checkNetwork().whenComplete(() => callApiForOwnFollowers());
        notifyListeners();
      } else {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Constants.checkNetwork().whenComplete(() => callApiForOwnFollowers());
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

  void openFollowingMoreMenu(int? userId, BuildContext context) {
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
                Constants.checkNetwork().whenComplete(() => callApiForBlockUser(userId,context));
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
          ],
        ),
      ),
    );
  }
}
