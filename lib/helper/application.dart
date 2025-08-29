import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:portal/components/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/toast.dart';

Future<SharedPreferences> _sharedPref = SharedPreferences.getInstance();
Application application = Application();

class Application implements Constants {
  getHeaders() async {
    // device token, platform , lang, token if
    Map<String, String> header;
    String token = await application.getAccessToken();
    print("--------------------token:$token");
    if (token != '') {
      // UserModel user = await application.getUserInfo();
      header = {
        "Content-Type": "application/json",
        "charset": "UTF-8",
        "project-type": await getPlatform() ?? 'ANDROID',
        "deviceToken": await getDeviceToken() ?? '',
        "merchant": "portal",
        // "company": "test",
        "Authorization": "Bearer $token"
      };
    } else {
      header = {
        "Content-Type": "application/json",
        "charset": "UTF-8",
        "merchant": "portal",
        "project-type": await getPlatform() ?? 'ANDROID',
        "deviceToken": await getDeviceToken() ?? '',

        // "company": "test",
      };
    }
    return header;
  }

  getThemeType() async {
    final SharedPreferences sharedPref = await _sharedPref;
    return sharedPref.getBool(Constants.storageKey + Constants.appTheme) ?? false;
  }

  setThemeType() async {
    final SharedPreferences sharedPref = await _sharedPref;
    bool? isDark = sharedPref.getBool(Constants.storageKey + Constants.appTheme);
    sharedPref.setBool(Constants.storageKey + Constants.appTheme, isDark == null ? true : !isDark);
  }

  getPlatform() async {
    final SharedPreferences sharedPref = await _sharedPref;
    return sharedPref.getString(Constants.storageKey + Constants.platform);
  }

  getDeviceToken() async {
    final SharedPreferences sharedPref = await _sharedPref;
    return sharedPref.getString(Constants.storageKey + Constants.deviceToken);
  }

  setDeviceToken(String deviceToken) async {
    final SharedPreferences sharedPref = await _sharedPref;
    sharedPref.setString(Constants.storageKey + Constants.deviceToken, deviceToken);
  }

  getEmail() async {
    final SharedPreferences sharedPref = await _sharedPref;
    return sharedPref.getString(Constants.storageKey + Constants.mail);
  }

  setEmail(String mail) async {
    final SharedPreferences sharedPref = await _sharedPref;
    sharedPref.setString(Constants.storageKey + Constants.mail, mail);
  }

  getpassword() async {
    final SharedPreferences sharedPref = await _sharedPref;
    return sharedPref.getString(Constants.storageKey + Constants.password);
  }

  setpassword(String pass) async {
    final SharedPreferences sharedPref = await _sharedPref;
    sharedPref.setString(Constants.storageKey + Constants.password, pass);
  }

  getUserName() async {
    final SharedPreferences sharedPref = await _sharedPref;
    return sharedPref.getString(Constants.storageKey + Constants.username);
  }

  setUserName(String name) async {
    final SharedPreferences sharedPref = await _sharedPref;
    sharedPref.setString(Constants.storageKey + Constants.username, name);
  }

  getRememberMe() async {
    final SharedPreferences sharedPref = await _sharedPref;
    return sharedPref.getString(Constants.storageKey + Constants.rememberMe) ?? '';
  }

  setRememberMe(bool isRemember, String username, String password) async {
    String value = isRemember ? "$username,$password" : "";
    final SharedPreferences sharedPref = await _sharedPref;
    sharedPref.setString(Constants.storageKey + Constants.rememberMe, value);
  }

  getBiometricLogin() async {
    final SharedPreferences sharedPref = await _sharedPref;
    return sharedPref.getBool(Constants.storageKey + Constants.biometricLogin) ?? false;
  }

  setBiometricLogin(bool value) async {
    final SharedPreferences sharedPref = await _sharedPref;
    sharedPref.setBool(Constants.storageKey + Constants.biometricLogin, value);
  }

  getUserType() async {
    final SharedPreferences sharedPref = await _sharedPref;
    print('get user type from sharedRef:${sharedPref.getInt(Constants.storageKey + Constants.userType)}');

    return sharedPref.getInt(Constants.storageKey + Constants.userType) ?? 0;
  }

  setUserType(int userType) async {
    final SharedPreferences sharedPref = await _sharedPref;
    sharedPref.setInt(Constants.storageKey + Constants.userType, userType);
  }

  setPlatform(String platform) async {
    final SharedPreferences sharedPref = await _sharedPref;
    sharedPref.setString(Constants.storageKey + Constants.platform, platform);
  }

  getSeenBoarding() async {
    final SharedPreferences sharedPref = await _sharedPref;
    return sharedPref.getBool(Constants.storageKey + Constants.seenBoarding) ?? false;
  }

  setSeenBoarding(bool seenBoarding) async {
    final SharedPreferences sharedPref = await _sharedPref;
    sharedPref.setBool(Constants.storageKey + Constants.seenBoarding, seenBoarding);
  }

  // String accessToken =
  //     'eyJraWQiOiIrMitxSHc3QVJYQnFURGNVR3dBTkZ1NkZ2SlM1cTRaVUZJRzFUYW9XZm9zPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiI2ZWVkOTMxNC1lZmMzLTQ2MDgtYmY5Ni03YTY0MDRiNmE3N2YiLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0yLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMl9PUEw1NnVOQUsiLCJjbGllbnRfaWQiOiI2aWsyYmNlNzJwdTZrbGczMjJqdWxmc2U1bCIsIm9yaWdpbl9qdGkiOiI4NDFkNDU2Ni01YjNkLTQ3N2EtOWYyOC02Y2Y3MDViNGJlY2IiLCJldmVudF9pZCI6IjE4NmU3MmJiLWU4ZDUtNDIwMC04MTEzLTU0MTg3YzJmM2EyYyIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE3NTA5MDk0OTQsImV4cCI6MTc1MTI3NjI3NSwiaWF0IjoxNzUxMjcyNjc1LCJqdGkiOiI5YzRmYmQwNy0yMTI4LTQxZTEtYjE0OS00ZDlhZGM0ZjhjMWMiLCJ1c2VybmFtZSI6ImVua2hqaW5nZyJ9.nsnfrSdikswa_LppPhXdcBSRM5kgDhYCC6rQJrU6x30WvAe3rKiBB8UdX54WY8gHG8xrAAps5VAC5SBmloW9QyHl3724UAjlEqFF2GdQfYvLgjqQPlbRza6O71qMczxqxooeBFTktRYoh9OhFDC1lnNTdPbUAmm5xuszxYv5qjEsLPLCCuXMckgBCmt0qwe_HGjWMJXbhBxDlpp1v7_Xw2grNkBQeZXERK7gQLo9Wm4hqTMPuSqNqfUrrc4R6lhYN3KItBaRXxvfDJagNLPFVQoHeL2Q8HayfvjFZQQZIscAUnBsKL_v4EEQIZUcG-8gmEmDuqir8mfbwt69GFK4ew';

  getAccessToken() async {
    final SharedPreferences sharedPref = await _sharedPref;
    return sharedPref.getString(Constants.storageKey + Constants.accessToken) ?? '';
    // return accessToken;
  }

  setAccessToken(String token) async {
    final SharedPreferences sharedPref = await _sharedPref;
    print('----------------->ene bol baij bolohgui zuil: $token');
    sharedPref.setString(Constants.storageKey + Constants.accessToken, token);
  }

  getRefreshToken() async {
    final SharedPreferences sharedPref = await _sharedPref;
    return sharedPref.getString(Constants.storageKey + Constants.refreshToken) ?? '';
    // return accessToken;
  }

  setRefreshToken(String token) async {
    final SharedPreferences sharedPref = await _sharedPref;
    sharedPref.setString(Constants.storageKey + Constants.refreshToken, token);
  }

  // getIdToken() async {
  //   final SharedPreferences sharedPref = await _sharedPref;
  //   return sharedPref.getString(Constants.storageKey + Constants.idToken) ?? '';
  //   // return accessToken;
  // }

  // setIdToken(String token) async {
  //   final SharedPreferences sharedPref = await _sharedPref;
  //   sharedPref.setString(Constants.storageKey + Constants.idToken, token);
  // }

  getPushNotifToken() async {
    final SharedPreferences sharedPref = await _sharedPref;
    return sharedPref.getString(Constants.storageKey + Constants.pushNotifToken);
  }

  setPushNotifToken(String pushNotifToken) async {
    final SharedPreferences sharedPref = await _sharedPref;
    sharedPref.setString(Constants.storageKey + Constants.pushNotifToken, pushNotifToken);
  }

  getQuizNumber() async {
    final SharedPreferences sharedPref = await _sharedPref;
    return sharedPref.getString(Constants.storageKey + Constants.quizNumber) ?? '';
    // return accessToken;
  }

  setQuizNumber(String number) async {
    final SharedPreferences sharedPref = await _sharedPref;
    sharedPref.setString(Constants.storageKey + Constants.quizNumber, number);
  }

  getQuizName() async {
    final SharedPreferences sharedPref = await _sharedPref;
    return sharedPref.getString(Constants.storageKey + Constants.quizName) ?? '';
    // return accessToken;
  }

  setQuizName(String name) async {
    final SharedPreferences sharedPref = await _sharedPref;
    sharedPref.setString(Constants.storageKey + Constants.quizName, name);
  }

  getLocale() async {
    final SharedPreferences sharedPref = await _sharedPref;
    return sharedPref.getString(Constants.storageKey + Constants.languageCode);
  }

  setLocale(String lang) async {
    final SharedPreferences sharedPref = await _sharedPref;
    sharedPref.setString(Constants.storageKey + Constants.languageCode, lang);
    return lang;
  }

  showNotification(String message, String desc, dynamic route) {
    showOverlay((_, t) {
      return NotificationToast(
        message: message ?? '',
        desc: desc ?? '',
        route: route,
      );
    }, key: ValueKey(message));
  }

  showToast(String message, {bool? isConnect}) {
    showOverlay((_, t) {
      return CustomToast(
        message: message,
        isAlert: false,
        isConn: isConnect ?? false,
      );
    }, key: ValueKey(message));
  }

  showToastAlert(String message) {
    showOverlay((
      _,
      t,
    ) {
      return CustomToast(
        message: message ?? '',
        isAlert: true,
      );
    }, key: ValueKey(message), duration: const Duration(seconds: 3), reverseAnimationDuration: const Duration(milliseconds: 300));
  }
}
