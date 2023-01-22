import 'dart:io';
import 'package:acoustic/screen/bottom_bar/bottom_bar_provider.dart';
import 'package:camera/camera.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/advertise/interstitial_ad_utils.dart';
import 'upload_video/uploadvideo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uni_links/uni_links.dart';
import 'package:dio/dio.dart';
import '../apiservice/Api_Header.dart';
import '../apiservice/Apiservice.dart';
import '../util/constants.dart';
import '../util/preference_utils.dart';
import 'bottom_bar/bottom_bar.dart';
import 'own_post/ownpost.dart';

bool _isInterstitialAdReady = false;

//ignore: must_be_immutable
class InitializeScreen extends StatefulWidget {
  int initialIndex;

  InitializeScreen(this.initialIndex, {Key? key}) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<InitializeScreen> {
  String name = "User";
  Location location = Location();
  late LocationData _locationData;
  late BottomBarProvider bottomBarProvider;

  final GlobalKey<ScaffoldState> _drawerScaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    initFunction();
    ScreenUtil.setContext(context);
    bottomBarProvider=Provider.of<BottomBarProvider>(context,listen: false);
  }

  Future<void> initFunction() async {
    Future.delayed(const Duration(seconds: 1), () {
      initDynamicLinks();
    });
    getPermission();
    PreferenceUtils.setBool(Constants.adAvailable, false);
    PreferenceUtils.setBool(Constants.admobAvailable, false);
    Constants.checkNetwork().whenComplete(() => callApiForSetting());
    Constants.checkNetwork().whenComplete(() => callApiForAdManage());
    if (_isInterstitialAdReady) {
      // InterstitialAdUtils.createInterstitialAd();
    }
    if (PreferenceUtils.getBool(Constants.isFirstOpenApp) == false) {
      callApiForGuestUser();
    }
    cameras = await availableCameras();
  }

  @override
  void dispose() {
    InterstitialAdUtils.createInterstitialAd().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bottomBarProvider=Provider.of<BottomBarProvider>(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          key: _drawerScaffoldKey,
          bottomNavigationBar: widget.initialIndex != null
              ? BottomBar(widget.initialIndex)
              : BottomBar(0),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                icon: const Text("NO"),
              ),
              const SizedBox(height: 16),
              IconButton(
                onPressed: () {
                  exit(0);
                },
                icon: const Text("YES"),
              ),
            ],
          ),
        )) ??
        false as Future<bool>;
  }

  Future initDynamicLinks() async {
    Uri? initialLink = await getInitialUri();
    if (kDebugMode) {
      print(
          "dynamic link path is ${initialLink?.queryParameters.values.first}");
    }
    final queryParams = initialLink?.queryParameters;
    if ((queryParams?.length ?? 0) > 0) {
      String videoId = queryParams!['video'].toString();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OwnPostScreen(int.parse(videoId.toString()))));
    }
  }

  Future<void> getPermission() async {
    await Permission.camera.request();
    await Permission.location.request();
    await Permission.microphone.request();
    await Permission.storage.request();
    if (await Permission.camera.status.isDenied) {
      Permission.camera.request();
    }
    if (await Permission.location.isRestricted) {
      Permission.location.request();
    }
    if (await Permission.location.isDenied) {
      Permission.location.request();
    }
    if (await Permission.microphone.isDenied) {
      Permission.microphone.request();
    }
    if (await Permission.storage.isDenied) {
      Permission.storage.request();
    }
    if (await Permission.location.isGranted) {
      _locationData = await location.getLocation();
      if (kDebugMode) {
        print(_locationData.latitude);
        print(_locationData.longitude);
      }
    } else {
      Permission.location.request();
    }
  }

  Future<void> callApiForSetting() async {
    await RestClient(ApiHeader().dioData()).settingRequest().then((response) {
      if (response.success == true) {
        if (kDebugMode) {
          print("Setting true");
        }
        PreferenceUtils.setString(
            Constants.appName, response.data?.appName ?? "");
        PreferenceUtils.setString(Constants.appId, response.data?.appId ?? "");
        PreferenceUtils.setString(
            Constants.appVersion, response.data?.appVersion ?? "");
        PreferenceUtils.setString(
            Constants.appFooter, response.data?.appFooter ?? "");
        PreferenceUtils.setString(
            Constants.termsOfUse, response.data?.termsOfUse ?? "");
        PreferenceUtils.setString(
            Constants.privacyPolicy, response.data?.privacyPolicy ?? "");
        PreferenceUtils.setString(
            Constants.imagePath, response.data?.imagePath ?? "");
        PreferenceUtils.setString(Constants.admobBannerAdUnitIdAndroid,
            response.data?.androidBanner ?? "");
        PreferenceUtils.setString(
            Constants.admobBannerAdUnitIdiOS, response.data?.iosBanner ?? "");
        PreferenceUtils.setString(Constants.admobInterstitialAdUnitIdAndroid,
            response.data?.androidInterstitial ?? "");
        PreferenceUtils.setString(Constants.admobInterstitialAdUnitIdiOS,
            response.data?.iosInterstitial ?? "");
        PreferenceUtils.setString(Constants.admobNativeAdUnitIdAndroid,
            response.data?.androidNative ?? "");
        PreferenceUtils.setString(
            Constants.admobNativeAdUnitIdiOS, response.data?.iosNative ?? "");
        PreferenceUtils.setString(
            Constants.facebookInit, response.data?.facebookInit ?? "");
        PreferenceUtils.setString(Constants.facebookPlaceIdForBanner,
            response.data?.facebookBanner ?? "");
        if (response.data!.appId != null && response.data!.appId!.isNotEmpty) {
          getDeviceToken(PreferenceUtils.getString((Constants.appId)));
        }
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
          // print(responseCode);
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

  void getDeviceToken(String appId) async {
    if (!mounted) return;
    OneSignal.shared.consentGranted(true);
    await OneSignal.shared.setAppId(appId);
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
    OneSignal.shared.promptLocationPermission();
    await OneSignal.shared.getDeviceState().then((value) {
      if (value!.userId != null) {
        PreferenceUtils.setString(Constants.deviceToken, value.userId!);
      } else {
        PreferenceUtils.setString(Constants.deviceToken, "");
      }
    });
  }

  Future<void> callApiForAdManage() async {
    await RestClient(ApiHeader().dioData())
        .adManagement()
        .then((response) async {
      if (response.data!.isNotEmpty) {
        PreferenceUtils.setBool(Constants.adAvailable, true);
      }
      List<String> adLocationList = [];
      List<String> adNetworkList = [];
      List<String> adTypeList = [];
      List<String> adIntervalList = [];
      List<String> adStatusList = [];
      for (int i = 0; i < response.data!.length; i++) {
        adLocationList.add(response.data![i].location.toString());
        adNetworkList.add(response.data![i].network.toString());
        adTypeList.add(response.data![i].type.toString());
        adIntervalList.add(response.data![i].interval.toString());
        adStatusList.add(response.data![i].status.toString());
        if (response.data![i].network == 'admob' && response.data![i].status == 1) {
          PreferenceUtils.setBool(Constants.admobAvailable, true);
          PreferenceUtils.setBool(Constants.adAvailable, true);
        } else if (response.data![i].network == 'facebook' && response.data![i].status == 1) {
          PreferenceUtils.setBool(Constants.admobAvailable, true);
          PreferenceUtils.setBool(Constants.adAvailable, true);
        }
      }
      PreferenceUtils.setStringList(Constants.adLocation, adLocationList);
      PreferenceUtils.setStringList(Constants.adNetwork, adNetworkList);
      PreferenceUtils.setStringList(Constants.adType, adTypeList);
      PreferenceUtils.setStringList(Constants.adInterval, adIntervalList);
      PreferenceUtils.setStringList(Constants.adStatus, adStatusList);
      await activeAdvertisement();
      await bottomBarProvider.bottomBarInit();

    }).catchError((Object obj) {
      // pr.hide();
      if (kDebugMode) {
        print("error:$obj.");
        print(obj.runtimeType);
      }
      switch (obj.runtimeType) {
        case DioError:
          // Here's the sample to get the failed response error code and message
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

  Future<void> activeAdvertisement() async {
    int setLoop = 0;
    setLoop = PreferenceUtils.getStringList(Constants.adNetwork).length;
    for (int i = 0; i < setLoop; i++) {
      if (PreferenceUtils.getStringList(Constants.adNetwork)[i] == "admob" &&
          PreferenceUtils.getStringList(Constants.adStatus)[i] == "1" &&
          PreferenceUtils.getStringList(Constants.adType)[i] == "Interstitial") {
        _isInterstitialAdReady = true;
        adMob();
        break;
      } else if (PreferenceUtils.getStringList(Constants.adNetwork)[i] == "facebook" &&
          PreferenceUtils.getStringList(Constants.adStatus)[i] == "1" &&
          PreferenceUtils.getStringList(Constants.adType)[i] == "Banner") {
        facebookAd();
        break;
      }
    }
  }

  Future<void> adMob() async {
    InterstitialAdUtils.createInterstitialAd();
  }

  Future<void> facebookAd() async {
    await FacebookAudienceNetwork.init(
      testingId: PreferenceUtils.getString(Constants.facebookInit), //optional
    );
  }

  Future<void> callApiForGuestUser() async {
    RestClient(ApiHeader().dioData()).guestUser().then((response) {
      PreferenceUtils.setBool(Constants.isFirstOpenApp, true);
      // print(response);
    }).catchError((Object obj) {
      // print("error:$obj");
      if (kDebugMode) {
        print(obj.runtimeType);
      }
    });
  }
}
