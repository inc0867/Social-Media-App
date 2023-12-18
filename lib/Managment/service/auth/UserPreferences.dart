import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static String usernamekey = "usernamekey";
  static String userloggedkey = "userloggedkey";
  static String useridkey = "useridkey";

  static Future<bool> saveusername(String username) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(usernamekey, username);
  }

  static Future<bool> saveuserid(String userid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(useridkey, userid);
  }

  static Future<bool> saveuserlogged(bool logged) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(userloggedkey, logged);
  }

  static Future<String?> getusername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(usernamekey);
  }

  static Future<String?> getuserid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(useridkey);
  }

  static Future<bool?> getuserlogged() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(userloggedkey);
  }
}
