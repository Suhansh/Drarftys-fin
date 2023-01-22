import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../apiservice/Api_Header.dart';
import '../../../apiservice/Apiservice.dart';
import '../../../util/constants.dart';
import '../../../util/preference_utils.dart';

class ReportProblemProvider extends ChangeNotifier {
  bool showSpinner = false;
  File? proImage;
  final picker = ImagePicker();
  String image = "";

  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textReason = TextEditingController();
  TextEditingController textIssue = TextEditingController();
  TextEditingController textEmail = TextEditingController();

  ReportProblemProvider() {
    textEmail.text = PreferenceUtils.getString(Constants.email);
  }

  void chooseProfileImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(
                    "From Gallery",
                    style: TextStyle(fontFamily: Constants.appFont),
                  ),
                  onTap: () {
                    proImgFromGallery();
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        );
      },
    );
  }

  // Get from gallery
  void proImgFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      proImage = File(pickedFile.path);
      List<int> imageBytes = proImage!.readAsBytesSync();
      image = base64Encode(imageBytes);
      if (kDebugMode) {
        print("_Proimage:$proImage");
      }
    } else {
      Constants.toastMessage("No image selected.");
      // print('No image selected.');
    }
    notifyListeners();
  }

  Future<void> callApiForReportProblem(userId, BuildContext context) async {
    showSpinner = true;
    notifyListeners();
    List<String> passImage = [];
    if (proImage != null) {
      List<int> liImageBytes = proImage!.readAsBytesSync();
      String proImageB64 = base64Encode(liImageBytes);
      passImage.add(proImageB64);
    }
    Map<String, dynamic> body;
    if (proImage != null) {
      body = {
        "subject": textReason.text,
        "issue": textIssue.text,
        "email": textEmail.text,
        "imgs": json.encode(passImage),
        "user_id": userId,
      };
    } else {
      body = {
        "subject": textReason.text,
        "issue": textIssue.text,
        "email": textEmail.text,
        "user_id": userId,
      };
    }
    await RestClient(ApiHeader().dioData()).reportProblem(body).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
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
