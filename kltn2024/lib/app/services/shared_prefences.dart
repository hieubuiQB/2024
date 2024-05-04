import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{

  static String userIdKey="USERKEY";
  static String userNameKey="USERNAMEKEY";
  static String userEmailKey="USEREMAILKEY";
  static String userRoleKey="USERLOLEKEY";
  static String userProfileKey="USERPROFILEKEY";
  static String userPurchaseConfirmedKey="USERPURCHASECONFIRMEDKEY";

  Future<bool> saveUserId(String? getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(getUserId != null) {
      return prefs.setString(userIdKey, getUserId);
    }else{
      return prefs.remove(userIdKey);
    }
 }

  Future<bool> saveUserName(String? getUserName) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    if(getUserName != null) {
      return prefs.setString(userNameKey, getUserName);
    }else{
      return prefs.remove(userNameKey);
    }

  }

  Future<bool> saveUserEmail(String? getUserEmail) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    if(getUserEmail != null) {
      return prefs.setString(userEmailKey, getUserEmail);
    }else{
      return prefs.remove(userEmailKey);
    }
  }

  Future<bool> saveUserRole(String getUserRole) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userRoleKey, getUserRole);
  }

  Future<String?> getUserId() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserRole() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(userRoleKey);
  }

  Future<bool> saveUserProfile(String getUserProfile) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userProfileKey, getUserProfile);
  }

  Future<String?> getUserProfile() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(userProfileKey);
  }

  Future<bool> saveUserPurchaseConfirmed(bool purchaseConfirmed) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setBool(userPurchaseConfirmedKey, purchaseConfirmed); 
  }

  Future<bool?> getUserPurchaseConfirmed() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getBool(userPurchaseConfirmedKey); 
  }

}
