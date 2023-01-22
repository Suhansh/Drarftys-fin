import 'package:flutter/material.dart';

import '../../util/constants.dart';
import '../../util/preference_utils.dart';

class SearchHistoryProvider extends ChangeNotifier {
  bool showSpinner = false;
  List<String> recentData = [];
  List<String> tempRecentData = [];
  List<String> addDataToLocal = [];

  SearchHistoryProvider(){
    if (getStringList(Constants.recentSearch).isNotEmpty) {
      tempRecentData = getStringList(Constants.recentSearch);
    } else {
      tempRecentData = [];
    }
    recentData = tempRecentData.reversed.toList();
  }

  Future<bool>? putStringList(String key, List<String> value) {
    if (PreferenceUtils == null) {
      return null;
    }
    return PreferenceUtils.setStringList(key, value);
  }

   List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    if (PreferenceUtils == null) {
      return defValue;
    }
    return PreferenceUtils.getStringList(key);
  }

}
