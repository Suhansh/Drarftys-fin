import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../apiservice/Api_Header.dart';
import '../../../apiservice/Apiservice.dart';
import '../../../util/constants.dart';

class PrivacyProvider extends ChangeNotifier {
  bool showSpinner = false;
  bool isPrivate = false;

  PrivacyProvider() {
    callApiForGetPrivacy();
  }

  Future<void> callApiForGetPrivacy() async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).myProfileInfo().then((response) {
      if (kDebugMode) {
        print(response.toString());
      }
      if (response.success == true) {
        showSpinner = false;
        if (response.data!.followerRequest == 1) {
          isPrivate = true;
        } else {
          isPrivate = false;
        }
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

  Future<void> callApiForSetPrivacy(BuildContext context) async {
    isPrivate = !isPrivate;
    notifyListeners();
    String followRequest = "0";
    if (kDebugMode) {
      print("isOnline12345:$isPrivate");
    }
    if (isPrivate == true) {
      followRequest = "1";
      notifyListeners();
    } else if (isPrivate == false) {
      followRequest = "0";
      notifyListeners();
    }
    if (kDebugMode) {
      print("follow_request345:$followRequest");
    }
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).privacysetting(followRequest).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        var msg = body['msg'];
        Constants.toastMessage(msg);
        showSpinner = false;
        notifyListeners();
      }
    }).catchError((Object obj) {
      Constants.toastMessage('Server Error');
      showSpinner = false;
      notifyListeners();
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }
}
