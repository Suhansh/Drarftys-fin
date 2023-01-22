import 'dart:io';
import '../util/constants.dart';
import '../util/preference_utils.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return PreferenceUtils.getString(Constants.admobBannerAdUnitIdAndroid)
              .isNotEmpty
          ? PreferenceUtils.getString(Constants.admobBannerAdUnitIdAndroid)
          : 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return PreferenceUtils.getString(Constants.admobBannerAdUnitIdiOS)
              .isNotEmpty
          ? PreferenceUtils.getString(Constants.admobBannerAdUnitIdiOS)
          : 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return PreferenceUtils.getString(
                  Constants.admobInterstitialAdUnitIdAndroid)
              .isNotEmpty
          ? PreferenceUtils.getString(
              Constants.admobInterstitialAdUnitIdAndroid)
          : "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return PreferenceUtils.getString(Constants.admobInterstitialAdUnitIdiOS)
              .isNotEmpty
          ? PreferenceUtils.getString(Constants.admobInterstitialAdUnitIdiOS)
          : "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      print("android////");
      return PreferenceUtils.getString(Constants.admobNativeAdUnitIdAndroid)
              .isNotEmpty
          ? PreferenceUtils.getString(Constants.admobNativeAdUnitIdAndroid)
          : "ca-app-pub-3940256099942544/2247696110";
    } else if (Platform.isIOS) {
      print("ios////");
      return PreferenceUtils.getString(Constants.admobNativeAdUnitIdiOS)
              .isNotEmpty
          ? PreferenceUtils.getString(Constants.admobNativeAdUnitIdiOS)
          : "ca-app-pub-3940256099942544/9214589741";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
