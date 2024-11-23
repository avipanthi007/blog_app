import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences pref;

  static initSharedPref() async {
    pref = await SharedPreferences.getInstance();
  }

  setLoginStatus(bool isLoggedIn) async {
    await pref.setBool('isLoggedIn', isLoggedIn);
  }

  getLoginStatus() async {
    return pref.getBool('isLoggedIn') ?? false;
  }
}
