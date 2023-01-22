import 'package:flutter/foundation.dart';
import '../../apiservice/Api_Header.dart';
import '../../apiservice/Apiservice.dart';
import '../../model/search_data.dart';
import '../../util/constants.dart';

class SearchCreatorProvider extends ChangeNotifier {
  bool showSpinner = false;
  late Future<int> getSearchFeatureBuilder;
  List<Creators> creator = [];
  List<Hashtags> hashtag = [];

  Future<int> getSearchItems(String value) async {
    int tempPassData = 0;
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).getSearchData(value).then((response) {
      if (response.success == true) {
        showSpinner = false;
        creator.clear();
        creator.addAll(response.data!.creators!);
        hashtag.clear();
        hashtag.addAll(response.data!.hashtags!);
        notifyListeners();
      } else {
        showSpinner = false;
        notifyListeners();
      }
    }).catchError((Object obj) {
      showSpinner = false;
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
      Constants.toastMessage("Internal Server Error");
    });
    if (creator.isNotEmpty) {
      tempPassData = creator.length;
    }
    if (hashtag.isNotEmpty) {
      tempPassData += hashtag.length;
    }
    notifyListeners();
    return tempPassData;
  }
}
