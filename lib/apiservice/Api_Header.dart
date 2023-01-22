import 'package:dio/dio.dart';
import '/util/constants.dart';
import '../util/preference_utils.dart';

class ApiHeader {
  Dio dioData() {
    final dio = Dio();
    dio.options.headers["Authorization"] = "Bearer " +
        PreferenceUtils.getString(
            Constants.headerToken); // config your dio headers globally
    dio.options.headers["Accept"] =
        "application/json"; // config your dio headers globally
    dio.options.headers["Content-Type"] = "application/x-www-form-urlencoded";
    dio.options.followRedirects = false;

    return dio;
  }
}

class ApiHeader2 {
  Dio dioData2() {
    final dio = Dio();

    dio.options.headers["Authorization"] = "Bearer " +
        PreferenceUtils.getString(
            Constants.headerToken); // config your dio headers globally
    dio.options.headers["Accept"] =
        "application/json"; // config your dio headers globally
    dio.options.headers["Content-Type"] = "multipart/form-data";
    return dio;
  }
}
