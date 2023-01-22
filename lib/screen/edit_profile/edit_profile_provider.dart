import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../apiservice/Api_Header.dart';
import '../../apiservice/Apiservice.dart';
import '../../util/constants.dart';
import '../../util/preference_utils.dart';
import '../initialize_screen.dart';

class EditProfileProvider extends ChangeNotifier {
  bool showSpinner = false;
  bool emailVerified = false;
  TextEditingController userNameLoad = TextEditingController();
  TextEditingController nameLoad = TextEditingController();
  TextEditingController bioLoad = TextEditingController();
  TextEditingController phoneLoad = TextEditingController();
  TextEditingController emailLoad = TextEditingController();
  TextEditingController birthdate = TextEditingController();
  String? dropdownValue = 'Select Gender';
  File? proImage;
  final picker = ImagePicker();
  String image = "";

  EditProfileProvider() {
    callApiForMyProfileInfo();
    if (PreferenceUtils.getString(Constants.bDate).isNotEmpty) {
      birthdate.text = PreferenceUtils.getString(Constants.bDate);
    }
  }

  Future<void> callApiForMyProfileInfo() async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).myProfileInfo().then((response) {
      if (response.success == true) {
        image = response.data!.imagePath! + response.data!.image!;
        showSpinner = false;
        userNameLoad.text = response.data!.userId!;
        nameLoad.text = response.data!.name!;
        phoneLoad.text = (response.data?.code ?? "") + (response.data?.phone ?? "");
        emailLoad.text = response.data!.email!;
        birthdate.text = response.data?.bdate ?? "";
        if (response.data!.bio != null) {
          bioLoad.text = response.data!.bio!;
        }
        if (response.data!.isVerify == 0) {
          emailVerified = true;
        }
        if (response.data!.gender != null) {
          dropdownValue = response.data!.gender;
        }
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

  Future<void> callApiForEditProfile(BuildContext context) async {
    showSpinner = true;
    notifyListeners();
    var passImage;
    if (proImage != null) {
      List<int> listImageBytes = proImage!.readAsBytesSync();
      String proImageB64 = base64Encode(listImageBytes);
      passImage = proImageB64;
    }
    Map<String, dynamic> body;
    if (passImage != null) {
      body = {
        "name": nameLoad.text,
        "gender": dropdownValue,
        "bdate": birthdate.text,
        "bio": bioLoad.text,
        "image": passImage,
      };
    } else {
      body = {
        "name": nameLoad.text,
        "gender": dropdownValue,
        "bdate": birthdate.text,
        "bio": bioLoad.text,
      };
    }
    await RestClient(ApiHeader().dioData()).editprofile(body).then((response) {
      var body = json.decode(response!);
      Constants.toastMessage(body["msg"].toString());
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitializeScreen(4),
          ));
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
      if (kDebugMode) {
        print('No image selected.');
      }
    }
    notifyListeners();
  }

  // Get from Camera
  void proImgFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      proImage = File(pickedFile.path);
      List<int> imageBytes = proImage!.readAsBytesSync();
      image = base64Encode(imageBytes);
      if (kDebugMode) {
        print("_Pro image:$proImage");
      }
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
    notifyListeners();
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
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(
                  "From Camera",
                  style: TextStyle(fontFamily: Constants.appFont),
                ),
                onTap: () {
                  proImgFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1975),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      if (kDebugMode) {
        print(picked);
      }
      var inputFormat = DateFormat('yyyy-MM-dd');
      var inputDate = inputFormat.parse(picked.toString().split(' ')[0]);
      var outputFormat = DateFormat('dd-MM-yyyy');
      birthdate.text = outputFormat.format(inputDate).toString();
      notifyListeners();
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
