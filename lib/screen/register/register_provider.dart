import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../apiservice/Api_Header.dart';
import '../../apiservice/Apiservice.dart';
import '../../util/constants.dart';
import '../../util/preference_utils.dart';

class RegisterProvider extends ChangeNotifier {
  bool passwordVisible = true;
  TextEditingController textUsername = TextEditingController();
  TextEditingController textName = TextEditingController();
  TextEditingController textEmail = TextEditingController();
  TextEditingController textContact = TextEditingController();
  TextEditingController textPassword = TextEditingController();
  TextEditingController textConfPassword = TextEditingController();
  bool autoValidate = false;
  bool showSpinner = false;
  String? strCountryCode = "+91";
  bool confirmPasswordVisible = true;

  String? validateConfPassword(String? value) {
    // Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    // RegExp regex = new RegExp(pattern as String);
    if (value!.isEmpty) {
      return "Confirm Password is Required";
    } else if (value.length < 6) {
      return "Confirm Password must be at least 6 characters";
    } else if (textPassword.text != textConfPassword.text) {
      return 'Password and Confirm Password does not match.';
    } else {
      return null;
    }
  }

  Future<int> callApiForRegister(String name, String userId, String email, String? code, String phone,
      String password, String confirmPassword, BuildContext context) async {

    // 0 no screen change
    // 1 initialize if verify
    // 2 otpScreen if not verify
    // 3 error
    int responseInt = 0;

    showSpinner = true;
    notifyListeners();
    try{
      String? response = await RestClient(ApiHeader().dioData())
          .register(name, userId, email, code, phone, password, confirmPassword);
      if (kDebugMode) {
        print(response.toString());
      }
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        showSpinner = false;
        notifyListeners();
        Constants.toastMessage("User created successfully!");
        PreferenceUtils.setString(Constants.serverUserId, body['data']['id'].toString());
        PreferenceUtils.setString(Constants.name, body['data']['name']);
        PreferenceUtils.setString(Constants.email, body['data']['email']);
        PreferenceUtils.setString(Constants.code, body['data']['code']);
        PreferenceUtils.setString(Constants.phone, body['data']['phone']);
        PreferenceUtils.setString(Constants.userId, body['data']['user_id']);
        PreferenceUtils.setString(Constants.isverified, body['data']['is_verify'].toString());
        if (body['data']['is_verify'] == 1) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const LoginScreen()),
          // );
          responseInt = 1;
        } else {
          // Navigator.of(context).push(Transitions(
          //     transitionType: TransitionType.slideUp,
          //     curve: Curves.bounceInOut,
          //     reverseCurve: Curves.fastLinearToSlowEaseIn,
          //     widget: OtpScreen()));
          responseInt = 2;
        }
      } else if (success == false) {
        showSpinner = false;
        notifyListeners();
        var msg = body['message'];
        if (kDebugMode) {
          print(msg);
        }
      }
    }catch(obj){
      responseInt = 3;
      showSpinner = false;
      notifyListeners();
      if (kDebugMode) {
        print("error:$obj.");
        print(obj.runtimeType);
      }
      final res = (obj as DioError).response;
      var data = json.decode(res!.data);
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj).response!;
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
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("Invalid Data");
            }
            if (data["errors"]["email"] != null) {
              var error = data["errors"]["email"][0];
              Constants.toastMessage(error);
            } else if (data["errors"]["phone"] != null) {
              var error = data["errors"]["phone"][0];
              Constants.toastMessage(error);
            } else {
              Constants.createSnackBar(
                  "The given data was invalid.", context, Color(Constants.redtext));
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

  notify(){
    notifyListeners();
  }
}
