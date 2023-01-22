import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../util/advertise/banner_ad.dart';
import '../../util/constants.dart';
import '../../util/preference_utils.dart';

class BottomBarProvider extends ChangeNotifier {
  BottomBarProvider() {
    bottomBarInit();
  }

  double dynamicAdSize = 70;

  bool adMobAds = false;
  bool facebookAds = false;
  bool startAppAds = false;
  List<String> storeAdNetworkData = [];
  int setLoop = 0;

  bottomBarInit() {
    if (PreferenceUtils.getBool(Constants.adAvailable) == true) {
      setLoop = PreferenceUtils.getStringList(Constants.adNetwork).length;
    }
    for (int i = 0; i < setLoop; i++) {
      storeAdNetworkData
          .add(PreferenceUtils.getStringList(Constants.adNetwork)[i]);
    }
    storeAdNetworkData.sort();

    for (int i = 0; i < setLoop; i++) {
      if (storeAdNetworkData[i] == "admob" && PreferenceUtils.getStringList(Constants.adStatus)[i] == "1" &&
          PreferenceUtils.getStringList(Constants.adType)[i] == "Banner") {
        adMobAds = true;
        facebookAds = false;
        startAppAds = false;
        PreferenceUtils.setBool(Constants.adAvailable, true);
        advertisementManage();
        notifyListeners();
        break;
      } else if (storeAdNetworkData[i] == "facebook" && PreferenceUtils.getStringList(Constants.adStatus)[i] == "1") {
        PreferenceUtils.setBool(Constants.adAvailable, true);
        facebookAds = true;
        adMobAds = false;
        startAppAds = false;
        advertisementManage();
        notifyListeners();
        break;
      } else {
        PreferenceUtils.setBool(Constants.adAvailable, false);
        dynamicAdSize = 70;
        adMobAds = false;
        facebookAds = false;
        startAppAds = false;
        notifyListeners();
      }
    }
  }

  void advertisementManage() {
    if (adMobAds) {
      AnchoredAdaptiveExample();
    } else if (facebookAds) {
      facebookAd();
    }
  }

  void facebookAd() {
    // dynamicAdSize = 130;
    notifyListeners();
  }

  void handleEventForFacebookAds(BannerAdResult result, value) {
    switch (result) {
      case BannerAdResult.ERROR:
        if (kDebugMode) {
          print("Error: $value");
        }
        break;
      case BannerAdResult.LOADED:
        dynamicAdSize = 130;
        notifyListeners();
        if (kDebugMode) {
          print("Loaded: $value");
        }
        break;
      case BannerAdResult.CLICKED:
        if (kDebugMode) {
          print("Clicked: $value");
        }
        break;
      case BannerAdResult.LOGGING_IMPRESSION:
        if (kDebugMode) {
          print("Logging Impression: $value");
        }
        break;
    }
  }
}
