import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../apiservice/Api_Header.dart';
import '../../apiservice/Apiservice.dart';
import '../../util/constants.dart';

class EditPostProvider extends ChangeNotifier {
  bool showSpinner = false;
  TextEditingController statusController = TextEditingController();
  bool isAdvanceOpen = false;
  int? radioValue = 0;
  int showComment = 0;
  String seeProfile = 'public';
  bool isComment = true;

  void handleRadioValueChange(int? value) {
    radioValue = value;
    switch (radioValue) {
      case 0:
        seeProfile = "public";
        break;
      case 1:
        seeProfile = "followers";
        break;
      case 2:
        seeProfile = "private";
        break;
    }
    notifyListeners();
  }

  Future<void> callApiForGetEditDataVideo(videoId) async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).getsinglevideo(videoId).then((response) {
      if (response.success == true) {
        showSpinner = false;
        statusController.text = response.data!.description!;
        if (response.data!.isComment == 1) {
          isComment = true;
          showComment = 1;
        } else {
          isComment = false;
          showComment = 0;
        }
        if (response.data!.view == "public") {
          radioValue = 0;
        } else if (response.data!.view == "followers") {
          radioValue = 1;
        } else if (response.data!.view == "private") {
          radioValue = 2;
        }
        notifyListeners();
      } else {
        showSpinner = false;
        notifyListeners();
      }
    }).catchError((Object obj) {
      showSpinner = false;
      notifyListeners();
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  Future<void> callApiForEditPost(videoId,BuildContext context) async {
    Map<String, dynamic> body = {
      "description": statusController.text,
      "view": seeProfile,
      "is_comment": showComment,
      "video_id": videoId
    };
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).editVideo(body).then((response) {
      showSpinner = false;
      notifyListeners();
      if (response.success!) {
        Constants.toastMessage(response.msg!);
        Navigator.pop(context);
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
