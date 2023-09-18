import 'package:shared_preferences/shared_preferences.dart';

class NetworkHandler {
  String? nToken,
      nUserId,
      nUserName,
      nName,
      nNik,
      nLevel,
      nPhoneNumber;

  void savePref(
    String? nToken,
    String? nUserId,
    String? nUserName,
    String? nName,
    String? nNik,
    String? nLevel,
    String? nPhoneNumber,
    // String? nRole,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("token", nToken ?? "");
    pref.setString("_id", nUserId ?? "");
    pref.setString("username", nUserName ?? "");
    pref.setString("name", nName ?? "");
    pref.setString("nik", nNik ?? "");
    pref.setString("level", nLevel ?? "");
    pref.setString("phoneNumber", nPhoneNumber ?? "");
    // pref.setString("role", nRole ?? "");
  }

  Future getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    nToken = pref.getString("token");
    nUserId = pref.getString("_id");
    nUserName = pref.getString("username");
    nName = pref.getString("name");
    nNik = pref.getString("nik");
    nLevel = pref.getString("level");
    nPhoneNumber = pref.getString("phoneNumber");
    // nRole = pref.getString("role");
    return nToken;
  }

  Future clearSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}

final sessionManager = NetworkHandler();