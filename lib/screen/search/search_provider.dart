import 'package:flutter/foundation.dart';
import '../../apiservice/Api_Header.dart';
import '../../apiservice/Apiservice.dart';
import '../../util/constants.dart';
import '../../util/preference_utils.dart';

class SearchProvider extends ChangeNotifier {
  bool showSpinner = false;
  int current = 0;
  List<String> imgList = [];
  List<String?> hashTagForBanner = [];
  List<dynamic> mainHashtags = [];
  bool adMobNative = false;
  List<String> storeAdNetworkData = [];
  int setLoop = 0;

  SearchProvider() {
    callApiForGetBanners();
    callApiForDefaultSearch();

    if (PreferenceUtils.getBool(Constants.adAvailable) == true) {
      setLoop = PreferenceUtils.getStringList(Constants.adNetwork).length;
    }
    for (int i = 0; i < setLoop; i++) {
      storeAdNetworkData
          .add(PreferenceUtils.getStringList(Constants.adNetwork)[i]);
    }
    storeAdNetworkData.sort();
    for (int i = 0; i < setLoop; i++) {
      if (storeAdNetworkData[i] == "admob" &&
          PreferenceUtils.getStringList(Constants.adStatus)[i] == "1" &&
          PreferenceUtils.getStringList(Constants.adType)[i] == "Native") {
        adMobNative = true;
        break;
      } else {
        adMobNative = false;
        // PreferenceUtils.setBool(Constants.adAvailable, false);
      }
    }
  }

  Future<void> callApiForGetBanners() async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).getbanners().then((response) {
      if (response.success == true) {
        showSpinner = false;
        if (kDebugMode) {
          print("length 123456:${imgList.length}");
        }
        if (response.data!.isNotEmpty) {
          imgList.clear();
          for (int i = 0; i < response.data!.length; i++) {
            imgList
                .add(response.data![i].imagePath! + response.data![i].image!);
            hashTagForBanner.add(response.data![i].title);
          }
          if (kDebugMode) {
            print("imgList.length:${imgList.length}");
          }
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
      Constants.toastMessage("Internal Server Error");
    });
  }

  Future<void> callApiForDefaultSearch() async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).getDefaultSearch().then((response) {
      if (response.success == true) {
        showSpinner = false;
        mainHashtags.addAll(response.data!);
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
      Constants.toastMessage("Internal Server Error");
    });
  }

  notify() {
    notifyListeners();
  }
}
