import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'preference_utils.dart';

class Constants {
  /*BaseUrl*/
  static const String baseUrl = "Enter_your_base_url/public/api/";
  //don't remove "/public/api/"

  /*Advertisement*/
  ///admob
  static const String admobBannerAdUnitIdAndroid = 'bannerAdUnitIdAndroid';
  // 'ca-app-pub-3940256099942544/6300978111';
  static const String admobBannerAdUnitIdiOS = 'bannerAdUnitIdiOS';
  // 'ca-app-pub-3940256099942544/2934735716';

  static const String admobInterstitialAdUnitIdAndroid =
      'interstitialAdUnitIdAndroid';
  // 'ca-app-pub-3940256099942544/1033173712';
  static const String admobInterstitialAdUnitIdiOS = 'interstitialAdUnitIdiOS';
  // 'ca-app-pub-3940256099942544/4411468910';

  static const String admobNativeAdUnitIdAndroid = 'nativeAdUnitIdAndroid';
  // 'ca-app-pub-3940256099942544/2247696110';
  static const String admobNativeAdUnitIdiOS = 'nativeAdUnitIdiOS';
  // 'ca-app-pub-3940256099942544/3986624511';

  static String getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return PreferenceUtils.getString(Constants.admobBannerAdUnitIdAndroid);
    } else if (Platform.isIOS) {
      return PreferenceUtils.getString(Constants.admobBannerAdUnitIdiOS);
    }
    return "";
  }

  static String getInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      return PreferenceUtils.getString(
          Constants.admobInterstitialAdUnitIdAndroid);
    } else if (Platform.isIOS) {
      return PreferenceUtils.getString(Constants.admobInterstitialAdUnitIdiOS);
    }
    return "";
  }

  static String getNativeAdUnitId() {
    if (Platform.isAndroid) {
      return PreferenceUtils.getString(Constants.admobNativeAdUnitIdAndroid);
    } else if (Platform.isIOS) {
      return PreferenceUtils.getString(Constants.admobNativeAdUnitIdiOS);
    }
    return "";
  }

  ///facebook
  static const String facebookInit = 'facebookInit';
  // '37b1da9d-b48c-4103-a393-2e095e734bd6';
  static const String facebookPlaceIdForBanner = 'facebookPlaceIdForBanner';
  // 'IMG_16_9_LINK#349126746297760_349562716254163';

  static int bgblack = 0xFF121212;
  static int bgblack1 = 0xFF1d1d1d;
  static int buttonbg = 0xFF36446b;
  static int greytext = 0xFF666666;
  static int hinttext = 0xFFc2c2c2;
  static int whitetext = 0xFFffffff;
  static int lightbluecolor = 0xFF36446b;
  static int conbg = 0xFF1d1d1d;
  static int redtext = 0xFFff4343;





  /*User Data*/

  static const String isLoggedIn = "isLoggedIn";
  static const String isverified = "isverified";

  static const String deviceToken = "devicetoken";
  static const String headerToken = "headertoken";
  static const String id = "id";
  static const String serverUserId = "serverUserId";
  static const String name = "name";
  static const String userId = "user_id";
  static const String email = "email";
  static const String code = "code";
  static const String phone = "phone";
  static const String isVerify = "is_verify";
  static const String bio = "bio";
  static const String bDate = "bdate";
  static const String gender = "gender";
  static const String image = "image";

  /*Setting data*/

  static const String appName = "app_name";
  static const String appId = "app_id";
  static const String appVersion = "app_version";
  static const String appFooter = "app_footer";
  static const String termsOfUse = "terms_of_use";
  static const String privacyPolicy = "privacy_policy";
  static const String isWaterMark = "isWaterMark";
  static const String waterMarkPath = "waterMarkPath";
  static const String imagePath = "imagePath";
  static const String addMusicId = "addMusicId";
  static const String trendingVidPreviousIndex = "trendingVidPreviousIndex";

  /*search*/
  static const String recentSearch = "recentSearch";

  static const String isFirstOpenApp = "isFirstOpenApp";

  /*advertise setting*/
  static const String adLocation = "adLocation";
  static const String adNetwork = "adNetwork";
  static const String adType = "adType";
  static const String adInterval = "adInterval";
  static const String adStatus = "adStatus";
  static const String adAvailable = "adAvailable";
  static const String admobAvailable = "admobAvailable";

  /*fonts*/
  static String appFont = 'Proxima';
  static String appFontBold = 'ProximaBold';

  static var kAppLabelWidget = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14.0,
      color: Color(Constants.greytext),
      fontFamily: Constants.appFont);

  static var kTextFieldInputDecoration = InputDecoration(
    hintStyle: TextStyle(
        color: Color(Constants.hinttext),
        fontFamily: Constants.appFont,
        fontSize: 14),

    disabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(Constants.greytext)),
    ),

    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),

    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    // errorStyle: TextStyle(
    //     fontFamily: Constants.app_font, color: Colors.red)
  );

  static String? kvalidatedata(String? value) {
    if (value!.isEmpty) {
      return 'Data is Required';
    } else {
      return null;
    }
  }

  static String? kvalidateUserName(String? value) {
    value!.trim();
    Pattern pattern = r'[a-zA-Z0-9]+$';
    RegExp regex = RegExp(pattern as String);
    Pattern pattern2 = r'^\S*$';
    RegExp regex2 = RegExp(pattern2 as String);
    if (value.isEmpty) {
      return "Enter any character";
    } else if (value.length < 5 || value.length > 10) {
      return "UserName should be min. 5 letter and max. 10 letter";
    } else if (!regex.hasMatch(value)) {
      return 'Not Included any special characters(#, @, .)';
    } else if (!regex2.hasMatch(value)) {
      return 'Not Included a whitespace';
    } else {
      return null;
    }
  }

  static String? kvalidateotp(String? value) {
    // Pattern pattern = r'[0-9]';
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{4}$)';
    RegExp regex = RegExp(pattern as String);
    if (value!.isEmpty) {
      return 'OTP is Required';
    } else if (value.length > 4) {
      return 'Enter Valid OTP';
    } else if (!regex.hasMatch(value)) {
      return ' Enter Valid OTP';
    } else {
      return null;
    }
  }

  static String? kvalidateName(String? value) {
    if (value!.isEmpty) {
      return 'Name is Required';
    } else {
      return null;
    }
  }

  static String? kvalidateReason(String? value) {
    if (value!.trim().isEmpty) {
      return 'Reason is Required';
    } else {
      return null;
    }
  }

  static String? kvalidateIssue(String? value) {
    if (value!.trim().isEmpty) {
      return 'Issue is Required';
    } else {
      return null;
    }
  }

  static String? kvalidateCotactNum(String? value) {
    Pattern pattern = r'^[0-9]*$';
    RegExp regex = RegExp(pattern as String);
    if (value!.isEmpty) {
      return 'Contact Number is Required';
    } else if (value.length > 10) {
      return 'Contact Number should be 10 letter';
    } else if (!regex.hasMatch(value)) {
      return 'letter should be in numbers';
    } else {
      return null;
    }
  }

  static String? kvalidatePassword(String? value) {
    // Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    // RegExp regex = new RegExp(pattern as String);

    if (value!.isEmpty) {
      return "Password is Required";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    // else if (!regex.hasMatch(value))
    //   return 'Password required';
    else {
      return null;
    }
  }

  static String? kValidateConfPassword(
      String? value,
      TextEditingController textPassword,
      TextEditingController textConfPassword) {
    Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = RegExp(pattern as String);
    if (value!.isEmpty) {
      return "Password is Required";
    } else if (textPassword.text != textConfPassword.text) {
      return 'Password and Confirm Password does not match.';
    } else if (!regex.hasMatch(value)) {
      return 'Password required';
    } else {
      return null;
    }
  }

  static String? kvalidateEmail(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern as String);
    if (value!.isEmpty) {
      return "Email is Required";
    } else if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  static void createSnackBar(
      String message, BuildContext scaffoldContext, Color color) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
            color: Color(whitetext), fontFamily: appFont, fontSize: 16),
      ),
      backgroundColor: color,
    );

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(snackBar);
    // Scaffold.of(scaffoldContext).showSnackBar(snackBar);
  }

  static Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      Constants.toastMessage("No Internet Connection");
      return false;
    }
  }

  static toastMessage(String msg) {
    Fluttertoast.showToast(
        msg: "$msg.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static toastMessageLongTime(String msg) {
    Fluttertoast.showToast(
        msg: "$msg.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

class FirestoreConstants {
  static const pathUserCollection = "users";
  static const pathMessageCollection = "messages";
  static const nickname = "nickname";
  static const aboutMe = "aboutMe";
  static const photoUrl = "photoUrl";
  static const id = "id";
  static const chattingWith = "chattingWith";
  static const idFrom = "idFrom";
  static const idTo = "idTo";
  static const timestamp = "timestamp";
  static const content = "content";
  static const type = "type";
  static const shopId = "shopId";
  static const userId = "userId";
  static const userType = "userType";
  static const signInFirebaseUser = "signInFirebaseUser";
}