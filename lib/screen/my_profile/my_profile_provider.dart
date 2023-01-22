import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import '../../apiservice/Api_Header.dart';
import '../../apiservice/Apiservice.dart';
import '../../model/myprofilemodel.dart';
import '../../util/constants.dart';
import '../../util/preference_utils.dart';
import '../edit_post/edit_post_page.dart';

class MyProfileProvider extends ChangeNotifier {
  bool showSpinner = false;
  String? name = "name";
  String? username = "username";
  String? bio = "bio";
  String? phone = "phone";
  String? email = "email";
  String? bDate = "bdate";
  String image = "bdate";
  String followers = "0";
  String following = "0";
  String totalPost = "0";
  int? userId = 0;

  List<Posts> postList = <Posts>[];
  List<Saved> savedList = <Saved>[];
  List<Liked> likedList = <Liked>[];

  Future<int>? profileFuture;

  MyProfileProvider() {
    profileFuture = callApiForGetProfile(isShowLoader: true);
  }

  Future<int> callApiForGetProfile({required bool isShowLoader}) async {
    int tempPassData = 0;
    if(isShowLoader) showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).getmyprofiledata().then((response) {
      if (response.success == true) {
        if(isShowLoader) showSpinner = false;
        notifyListeners();
        if (kDebugMode) {
          print("success profile");
        }
        if (response.data!.mainUser!.name != null) {
          PreferenceUtils.setString(Constants.name, response.data!.mainUser!.name!);
        } else {
          PreferenceUtils.setString(Constants.name, "");
        }
        if (response.data!.mainUser!.userId != null) {
          PreferenceUtils.setString(Constants.userId, response.data!.mainUser!.userId!);
        } else {
          PreferenceUtils.setString(Constants.userId, "");
        }
        if (response.data!.mainUser!.email != null) {
          PreferenceUtils.setString(Constants.email, response.data!.mainUser!.email!);
        } else {
          PreferenceUtils.setString(Constants.email, "");
        }
        if (response.data!.mainUser!.phone != null) {
          PreferenceUtils.setString(Constants.phone, response.data!.mainUser!.phone!);
        } else {
          PreferenceUtils.setString(Constants.phone, "");
        }
        if (response.data!.mainUser!.bio != null) {
          PreferenceUtils.setString(Constants.bio, response.data!.mainUser!.bio!);
        } else {
          PreferenceUtils.setString(Constants.bio, "");
        }
        if (response.data!.mainUser!.bdate != null) {
          PreferenceUtils.setString(Constants.bDate, response.data!.mainUser!.bdate!);
        } else {
          PreferenceUtils.setString(Constants.bDate, "");
        }
        if (response.data!.mainUser!.gender != null) {
          PreferenceUtils.setString(Constants.gender, response.data!.mainUser!.gender!);
        } else {
          PreferenceUtils.setString(Constants.gender, "");
        }
        if (response.data!.mainUser!.imagePath != null && response.data!.mainUser!.image != null) {
          PreferenceUtils.setString(Constants.image,
              (response.data!.mainUser!.imagePath! + response.data!.mainUser!.image!));
        } else {
          PreferenceUtils.setString(Constants.image, "");
        }
        if (response.data!.mainUser!.bio != null && response.data!.mainUser!.bio!.isNotEmpty) {
          bio = response.data!.mainUser!.bio;
        }
        bDate = response.data!.mainUser!.bdate;
        name = response.data!.mainUser!.name;
        username = response.data!.mainUser!.userId;
        phone = response.data!.mainUser!.phone;
        email = response.data!.mainUser!.email;
        image = response.data!.mainUser!.imagePath! + response.data!.mainUser!.image!;
        followers = response.data!.mainUser!.followersCount.toString();
        following = response.data!.mainUser!.followingCount.toString();
        totalPost = response.data!.posts!.length.toString();
        userId = response.data!.mainUser!.id;
        likedList.clear();
        postList.clear();
        savedList.clear();
        if (response.data!.posts!.isNotEmpty) {
          postList.clear();
          postList.addAll(response.data!.posts!);
        }
        if (response.data!.liked!.isNotEmpty) {
          likedList.clear();
          likedList.addAll(response.data!.liked!);
        }
        if (response.data!.saved!.isNotEmpty) {
          savedList.clear();
          savedList.addAll(response.data!.saved!);
        }
        notifyListeners();
      } else {
        if(isShowLoader)  showSpinner = false;
        notifyListeners();
      }
    }).catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          if (kDebugMode) {
            print(res);
          }
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            if (kDebugMode) {
              print(responseCode);
              print(res.statusMessage);
            }
            Constants.toastMessage("Login Please");
          } else if (responseCode == 422) {
            Constants.toastMessage("Internal server error");
            if (kDebugMode) {
              print("code:$responseCode");
            }
          }
          break;
        default:
      }
      if(isShowLoader)  showSpinner = false;
      notifyListeners();
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
    if (postList.isNotEmpty) {
      tempPassData = postList.length;
    }
    if (likedList.isNotEmpty) {
      tempPassData += likedList.length;
    }
    if (savedList.isNotEmpty) {
      tempPassData += savedList.length;
    }
    notifyListeners();
    return tempPassData;
  }

  void openPostBottomSheet(int? videoId, String video, BuildContext context) {
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
                      Constants.checkNetwork()
                          .whenComplete(() => callApiForDeleteVideo(videoId, context));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        "Delete Post",
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPost(
                              videoId: videoId,
                            ),
                          )).whenComplete(() => Navigator.pop(context));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        "Edit Post",
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
                      Share.share(video + '?video=' + videoId.toString())
                          .whenComplete(() => Navigator.pop(context));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        "Share to...",
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

  void openSavedBottomSheet(
      int? id, int? userid, String video, String videoId, BuildContext context) {
    if (kDebugMode) {
      print("saved id123:$id");
      print("saved user id123:$userid");
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
                      Constants.checkNetwork().whenComplete(() => callApiForSaveVideo(id, context));
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        "Remove From The Save List",
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
                          .whenComplete(() => callApiForBlockUser(userid, context));
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
                      Share.share(video + '?video=' + videoId.toString())
                          .whenComplete(() => Navigator.pop(context));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        "Share to...",
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

  Future<void> callApiForLikedVideo(int? id, BuildContext context) async {
    if (kDebugMode) {
      print("like id:$id");
    }
    // showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).likevideo(id).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        // showSpinner = false;
        Constants.checkNetwork().whenComplete(() => callApiForGetProfile(isShowLoader: false));
        notifyListeners();
      } else {
        // showSpinner = false;
        notifyListeners();
      }
    }).catchError((Object obj) {
      Constants.toastMessage("Server Error");
      // showSpinner = false;
      notifyListeners();
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  Future<void> callApiForDeleteVideo(int? id, BuildContext context) async {
    if (kDebugMode) {
      print("like id:$id");
    }
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).deleteVideo(id).then((response) {
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
        Constants.checkNetwork().whenComplete(() => callApiForGetProfile(isShowLoader: false));
        notifyListeners();
      } else {
        showSpinner = false;
        var msg = body['msg'];
        Navigator.pop(context);
        Constants.toastMessage(msg);
        notifyListeners();
      }
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

  Future<void> callApiForSaveVideo(int? id, BuildContext context) async {
    if (kDebugMode) {
      print("like id:$id");
    }
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).savevideo(id).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Constants.checkNetwork().whenComplete(() => callApiForGetProfile(isShowLoader: false));
        notifyListeners();
      } else {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
        notifyListeners();
      }
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

  callApiForBlockUser(int? userid, BuildContext context) async {
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
        Constants.toastMessage(msg);
        Constants.checkNetwork().whenComplete(() => callApiForGetProfile(isShowLoader: false));
        notifyListeners();
      } else {
        showSpinner = false;
        notifyListeners();
        var msg = body['msg'];
        // Constants.toastMessage(msg);
        final snackBar = SnackBar(
          content: Text(msg),
          backgroundColor: Color(Constants.redtext),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // _scaffoldKey.currentState!.showSnackBar(snackBar);
      }
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

  notify() {
    notifyListeners();
  }
}
