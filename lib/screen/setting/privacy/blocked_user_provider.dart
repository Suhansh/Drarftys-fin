import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../apiservice/Api_Header.dart';
import '../../../apiservice/Apiservice.dart';
import '../../../model/userblocklist.dart';
import '../../../util/constants.dart';

class BlockedUserProvider extends ChangeNotifier {
  bool showSpinner = false;
  bool noData = true;
  bool showData = false;
  List<UserBlockListData> blockUserList = <UserBlockListData>[];

  Future<void> callApiForBlockUserList() async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).getblockuser().then((response) {
      if (response.success == true) {
        showSpinner = false;
        notifyListeners();

        blockUserList.clear();
        if (response.data!.isNotEmpty) {
          blockUserList.clear();
          blockUserList.addAll(response.data!);
          noData = false;
          showData = true;
        }
        notifyListeners();
      } else {
        showSpinner = false;
        noData = true;
        showData = false;
        notifyListeners();
      }
    }).catchError((Object obj) {
      Constants.toastMessage("Server Error");
      showSpinner = false;
      noData = true;
      showData = false;
      notifyListeners();
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  callApiForUnBlockUser(int? id) async {
    showSpinner = true;
    notifyListeners();
    await RestClient(ApiHeader().dioData()).unblockuser(id.toString(), "User").then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Constants.checkNetwork().whenComplete(() => callApiForBlockUserList());
        notifyListeners();
      } else {
        showSpinner = false;
        var msg = body['msg'];
        Constants.toastMessage(msg);
        notifyListeners();
      }
    }).catchError((Object obj) {
      Constants.toastMessage('Server Error');
      showSpinner = false;
      notifyListeners();
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }
}
