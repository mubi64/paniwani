import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:paniwani/utils/strings.dart';
import 'package:path_provider/path_provider.dart';

import '../screens/mobile_number_screen.dart';
import '../storage/shared_pref.dart';
import '../utils/comman_dialogs.dart';
import '../utils/utils.dart';

class DioClient {
  static String? cookies;

  Future<Dio> apiClientInstance(context, baseURL) async {
    Utils utils = Utils();
    SharedPref prefs = SharedPref();
    var cookieJar = await getCookiePath();
    BaseOptions options = BaseOptions(
      baseUrl: baseURL,
      connectTimeout: const Duration(milliseconds: 60000),
      receiveTimeout: const Duration(milliseconds: 60000),
    );

    Dio dio = Dio(options);

    // _utils.loggerPrint("Token : " + token);
    utils.loggerPrint("Token : " + baseURL);

    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (
      HttpClient client,
    ) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.interceptors.add(LogInterceptor(responseBody: true));
    dio.interceptors.add(CookieManager(cookieJar));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (
          RequestOptions option,
          RequestInterceptorHandler handler,
        ) async {
          utils.loggerPrint(option.headers);
          return handler.next(option);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          return handler.next(response);
        },
        onError: (e, ErrorInterceptorHandler handler) {
          if (e.response != null) {
            if (e.response!.statusCode == 403) {
              prefs.saveObject(prefs.prefKeyEmployeeData, null);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MobileNumberScreen();
                  },
                ),
                (route) => false,
              );
            } else if (e.response!.data["message"] != null) {
              utils.loggerPrint({"line 69", e.response!.data["message"]});
              utils.showToast(e.response!.data["message"].toString(), context);
            } else if (e.response!.data["exception"] != null) {
              utils.loggerPrint({"line 71", e.response!.data["exception"]});
              utils.showToast(e.response!.data["exception"], context);
            } else {
              utils.loggerPrint({"line 74", e.response?.statusCode});
              utils.showToast(e.response!.data['error_message'], context);
            }
          } else {
            utils.loggerPrint(e.message);
            utils.showToast(AppStrings.msgTryAgain, context);
          }

          return handler.reject(e);
        },
      ),
    );
    return dio;
  }

  static Future initCookies() async {
    cookies = await getCookies();
  }

  static Future<PersistCookieJar> getCookiePath() async {
    Directory appDocDir = await getApplicationSupportDirectory();
    String appDocPath = appDocDir.path;
    return PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(appDocPath),
    );
  }

  static Future<String?> getCookies() async {
    var cookieJar = await getCookiePath();
    SharedPref prefs = SharedPref();
    String baseURL = await prefs.readString(prefs.prefBaseUrl);

    if (baseURL != "") {
      var cookies = await cookieJar.loadForRequest(Uri.parse(baseURL));

      var cookie = CookieManager.getCookies(cookies);

      return cookie;
    } else {
      return null;
    }
  }
}
