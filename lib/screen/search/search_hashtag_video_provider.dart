import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../apiservice/Api_Header.dart';
import '../../apiservice/Apiservice.dart';
import '../../model/hashtag_video.dart';
import '../../util/constants.dart';

class SearchHashtagVideoProvider extends ChangeNotifier {
  bool isRememberMe = false;
  bool showSpinner = false;
  bool showRed = false;
  bool showWhite = true;
  late Future<List<HashtagVideoData>> getHashtagVideoFeatureBuilder;
  List<HashtagVideoData> hashtagVideos = <HashtagVideoData>[];

  Future<List<HashtagVideoData>> callApiForHashTagVideos(hashtag) async {
    await RestClient(ApiHeader().dioData()).hashtagVideo(hashtag).then((response) {
      hashtagVideos.clear();
      hashtagVideos.addAll(response.data!);
      notifyListeners();
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
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
    return hashtagVideos;
  }
}
