import 'dart:convert';
import 'package:acoustic/screen/initialize_screen.dart';
import 'package:acoustic/widget/transitions.dart';

import '../../otpscreen.dart';
import '/screen/chat/model/user_chat_model.dart';
import '/util/constants.dart';
import '/util/preference_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show Directory, File, HttpClient, Platform;
import 'package:dio/dio.dart';
import '../../../apiservice/Api_Header.dart';
import '../../../apiservice/Apiservice.dart';


enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
}

class AuthProvider extends ChangeNotifier {

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  Status _status = Status.uninitialized;

  Status get status => _status;

  bool passwordVisible = true;
  TextEditingController textEmail = TextEditingController();
  TextEditingController textPassword = TextEditingController();
  bool showSpinner = false;
  String deviceToken = "";
  bool autoValidate = false;

  AuthProvider({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  String? getUserFirebaseId() {
    return PreferenceUtils.getString(FirestoreConstants.id);
  }

  Future<bool> handleSignIn(
      String email, String password, String? name, String? image, String userId) async {
    _status = Status.authenticating;
    notifyListeners();

    try {
      bool checkUserRegistered = PreferenceUtils.getBool(FirestoreConstants.signInFirebaseUser);
      if (checkUserRegistered) {
        User? firebaseUser = (await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ))
            .user;
        if (firebaseUser != null) {
          await firebaseSignIn(firebaseUser, name, image, userId);
        }
      } else {
        User? firebaseUser = (await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ))
            .user;
        if (firebaseUser != null) {
          await firebaseSignIn(firebaseUser, name, image, userId);
        }
      }
      PreferenceUtils.setBool(FirestoreConstants.signInFirebaseUser, true);
      return true;
    } on FirebaseAuthException catch (err) {
      bool checkS = false;
      if (kDebugMode) {
        print(err.toString());
      }
      if (err.code == "email-already-in-use") {
        User? firebaseUser = (await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ))
            .user;
        if (firebaseUser != null) {
          await firebaseSignIn(firebaseUser, name, image, userId);
          PreferenceUtils.setBool(FirestoreConstants.signInFirebaseUser, true);
          checkS = true;
        }
        return checkS;
      }
      return checkS;
    }
  }

  Future<void> firebaseSignIn(User firebaseUser, String? name, String? image, userId) async {
    final QuerySnapshot result = await firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.isEmpty) {
      // Writing data to server because here is a new user
      firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(firebaseUser.uid)
          .set({
        FirestoreConstants.nickname: name,
        FirestoreConstants.photoUrl: image,
        FirestoreConstants.id: firebaseUser.uid,
        FirestoreConstants.userId: userId,
        FirestoreConstants.userType: "user",
        // FirestoreConstants.vShopId: vShopId,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        FirestoreConstants.chattingWith: null
      });

      // Write data to local storage
      User? currentUser = firebaseUser;
      PreferenceUtils.setString(FirestoreConstants.id, currentUser.uid);
      PreferenceUtils.setString(FirestoreConstants.nickname, name ?? "");
      PreferenceUtils.setString(FirestoreConstants.photoUrl, image ?? "");
      PreferenceUtils.setString(FirestoreConstants.userId, userId ?? "");
      PreferenceUtils.setString(FirestoreConstants.userType, "user");
    } else {
      // Already sign up, just get data from firestore
      DocumentSnapshot documentSnapshot = documents[0];
      UserChat userChat = UserChat.fromDocument(documentSnapshot);
      // Write data to local
      PreferenceUtils.setString(FirestoreConstants.id, userChat.id);
      PreferenceUtils.setString(FirestoreConstants.nickname, userChat.nickname);
      PreferenceUtils.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
      PreferenceUtils.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
      PreferenceUtils.setString(FirestoreConstants.userType, userChat.types);
      // prefs.setString(FirestoreConstants.vShopId, userChat.vShopId);
    }
  }

  Future<void> handleSignOut() async {
    _status = Status.uninitialized;
    await firebaseAuth.signOut();
    // await googleSignIn.disconnect();
    // await googleSignIn.signOut();
  }

  Future<void> callApiForSetting() async {
    await RestClient(ApiHeader().dioData()).settingRequest().then((response) async {
      if (response.success == true) {
        if (kDebugMode) {
          print("Setting true");
        }

        PreferenceUtils.setString(Constants.appName, response.data?.appName ?? "");
        PreferenceUtils.setString(Constants.appId, response.data?.appId ?? "");
        PreferenceUtils.setString(Constants.appVersion, response.data?.appVersion ?? "");
        PreferenceUtils.setString(Constants.appFooter, response.data?.appFooter ?? "");
        PreferenceUtils.setString(Constants.termsOfUse, response.data?.termsOfUse ?? "");
        PreferenceUtils.setString(Constants.privacyPolicy, response.data?.privacyPolicy ?? "");
        PreferenceUtils.setString(Constants.imagePath, response.data?.imagePath ?? "");
        if (response.data!.isWatermark == 0) {
          PreferenceUtils.setBool(Constants.isWaterMark, false);
        } else if (response.data!.isWatermark == 1) {
          PreferenceUtils.setBool(Constants.isWaterMark, true);
        }

        late String videoDirectory;
        if (Platform.isAndroid) {
          final Directory? appDirectory = await (getExternalStorageDirectory());
          videoDirectory = '${appDirectory!.path}/Watermark';
        } else {
          final Directory? appDirectory = await (getApplicationDocumentsDirectory());
          videoDirectory = '${appDirectory!.path}/Watermark';
        }

        await Directory(videoDirectory).create(recursive: true);
        String url = (response.data?.imagePath ?? "") + (response.data?.watermark ?? "");
        String? fileName = (response.data?.watermark ?? "");
        await downloadFile(url, fileName, videoDirectory);
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print("error:$obj.");
        print(obj.runtimeType);
      }

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
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("code:$responseCode");
            }
          }

          break;
        default:
      }
    });
  }

  Future<String> downloadFile(String url, String? fileName, String dir) async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    try {
      myUrl = url;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else {
        filePath = 'Error code: ' + response.statusCode.toString();
      }
    } catch (ex) {
      filePath = 'Can not fetch url';
    }
    PreferenceUtils.setString(Constants.waterMarkPath, filePath);
    return filePath;
  }

  Future<int> callApiForLogin(
      String email, String password, String? deviceToken) async {
    int responseInt = 0;
    showSpinner = true;
    notifyListeners();
    String platform = "android";
    String provider = "local";
    String provider_token = " ";
    String name = " ";
    String image = " ";
    if (Platform.isAndroid) {
      platform = "android";
    } else if (Platform.isIOS) {
      platform = "ios";
    }

    if (kDebugMode) {
      print("Login_Email:$email");
      print("Login_Password:$password");
      print("Login_Token:$deviceToken");
    }
    try {
      String? response = await RestClient(ApiHeader().dioData())
          .login(email, password, deviceToken, provider, provider_token, name, image, platform);
      final body = json.decode(response!);
      bool? success = body['success'];
      handleSignIn(
          email,
          password,
          body['data']['name'] ?? "",
          body['data']['imagePath'].toString() + body['data']['image'].toString(),
          body['data']['id'].toString());
      if (success == true) {
        showSpinner = false;
        notifyListeners();
        var token = body['data']['token'];
        Constants.toastMessage("Login Successfully...");
        PreferenceUtils.setString(Constants.headerToken, token);
        if (kDebugMode) {
          print(token);
        }
        PreferenceUtils.setBool(Constants.isLoggedIn, true);
        if (body['data']['id'] != null) {
          PreferenceUtils.setString(Constants.serverUserId, body['data']['id'].toString());
        } else {
          PreferenceUtils.setString(Constants.serverUserId, "");
        }
        if (body['data']['name'] != null) {
          PreferenceUtils.setString(Constants.name, body['data']['name']);
        } else {
          PreferenceUtils.setString(Constants.name, "");
        }
        if (body['data']['email'] != null) {
          PreferenceUtils.setString(Constants.email, body['data']['email']);
        } else {
          PreferenceUtils.setString(Constants.email, "");
        }
        if (body['data']['code'] != null) {
          PreferenceUtils.setString(Constants.code, body['data']['code']);
        } else {
          PreferenceUtils.setString(Constants.code, "");
        }
        if (body['data']['phone'] != null) {
          PreferenceUtils.setString(Constants.phone, body['data']['phone']);
        } else {
          PreferenceUtils.setString(Constants.phone, "");
        }
        if (body['data']['user_id'] != null) {
          PreferenceUtils.setString(Constants.userId, body['data']['user_id']);
        } else {
          PreferenceUtils.setString(Constants.userId, "");
        }
        if (body['data']['is_verify'] != null) {
          PreferenceUtils.setString(Constants.isverified, body['data']['is_verify'].toString());
        } else {
          PreferenceUtils.setString(Constants.isverified, "");
        }
        if (body['data']['imagePath'] != null && body['data']['image'] != null) {
          PreferenceUtils.setString(Constants.image,
              body['data']['imagePath'].toString() + body['data']['image'].toString());
        } else {
          PreferenceUtils.setString(Constants.image, "");
        }
        if (body['data']['is_verify'] == 1) {
          PreferenceUtils.setBool(Constants.isverified, true);
        } else {
          PreferenceUtils.setBool(Constants.isverified, false);
        }
        // 0 no screen change
        // 1 initialize if verify
        // 2 otpScreen if not verify
        // 3 error
        if (body['data']['is_verify'] == 0) {
          // nothing will change if in case of api call issue
        } else if (body['data']['is_verify'] == 1) {
          Navigator.of(globalKey.currentContext!).push(Transitions(
              transitionType: TransitionType.slideUp,
              curve: Curves.bounceInOut,
              reverseCurve: Curves.fastLinearToSlowEaseIn,
              widget: InitializeScreen(0)));
          responseInt=1;
        } else if (body['data']['is_verify'] == 2) {
          Navigator.of(globalKey.currentContext!)
              .push(Transitions(
              transitionType: TransitionType.slideUp,
              curve: Curves.bounceInOut,
              reverseCurve: Curves.fastLinearToSlowEaseIn,
              widget: const OtpScreen()));
          responseInt=3;
        } else if (body['data']['is_verify'] == 3) {
          //if error occurred and action to do.
        }
      } else if (success == false) {
        showSpinner = false;
        notifyListeners();
        var msg = body['msg'];
        if (kDebugMode) {
          print(msg);
        }
        if (body['data']['id'] != null) {
          PreferenceUtils.setString(Constants.serverUserId, body['data']['id'].toString());
        } else {
          PreferenceUtils.setString(Constants.serverUserId, "");
        }
        if (msg == "Verify your account") {
          Navigator.of(globalKey.currentContext!).push(Transitions(
              transitionType: TransitionType.slideUp,
              curve: Curves.bounceInOut,
              reverseCurve: Curves.fastLinearToSlowEaseIn,
              widget: OtpScreen()));
          responseInt = 2;
        }
        Constants.toastMessage(msg);
      }
    } catch (e) {
      responseInt = 3;
      showSpinner = false;
      notifyListeners();
      if (kDebugMode) {
        print("error:$e.");
        print(e.runtimeType);
      }
      switch (e.runtimeType) {
        case DioError:
          final res = (e as DioError).response!;
          if (kDebugMode) {
            print(res);
          }
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            if (kDebugMode) {
              print("Got error : ${res.statusCode} -> ${res.statusMessage}");
            }
            showSpinner = false;
            notifyListeners();
            Constants.toastMessage("Invalid email or password");
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("Invalid Data");
            }
            showSpinner = false;
            notifyListeners();
          }
          break;
        default:
          showSpinner = false;
          notifyListeners();
      }
    }
    return responseInt;
  }

  void getDeviceToken(String appId, BuildContext context) async {
    OneSignal.shared.consentGranted(true);
    await OneSignal.shared.setAppId(appId);
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
    OneSignal.shared.promptLocationPermission();
    await OneSignal.shared.getDeviceState().then((value) {
      Constants.checkNetwork().whenComplete(() => callApiForLogin(
          textEmail.text.toString(), textPassword.text.toString(),value!.userId));
      return PreferenceUtils.setString(Constants.deviceToken, value!.userId!);
    });
  }

  notify() {
    notifyListeners();
  }
}
