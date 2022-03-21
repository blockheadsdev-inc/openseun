import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  Future<bool> addString(String _key, String _value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, _value);
    // print("LocalData() addString :  $_key : $_value");
    bool checkValue = prefs.containsKey(_key);
    return checkValue;
  }

  Future<bool> addInt(String _key, int _value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_key, _value);
    bool checkValue = prefs.containsKey(_key);
    return checkValue;
  }

  Future<bool> addDouble(String _key, double _value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(_key, _value);
    bool checkValue = prefs.containsKey(_key);
    return checkValue;
  }

  Future<bool> addBool(String _key, bool _value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_key, _value);
    bool checkValue = prefs.containsKey(_key);
    return checkValue;
  }

  Future<String?> getStringValues(String _key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString(_key);
    // print("LocalData() getStringValues :  $_key : $stringValue");
    return stringValue;
  }

  Future<int?> getIntValues(String _key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int? intValue = prefs.getInt(_key);
    return intValue;
  }

  Future<bool?> getBoolValues(String _key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    // String _data = prefs.getBool(_key);
    bool? boolValue = prefs.getBool(_key);
    return boolValue;
  }

  Future<double?> getDoubleValues(String _key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    double? doubleValue = prefs.getDouble('doubleValue');
    return doubleValue;
  }

  Future<bool?> saveSelectedToken(String _tokenId, String _tokenWalletId,
      String _tokenWalletWalletId) async {
    String _key1 = "selectedTokenId";
    String _key2 = "selectedTokenWalletId";
    String _key3 = "selectedTokenWalletWalletId";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_key1, _tokenId);
    prefs.setString(_key2, _tokenWalletId);
    prefs.setString(_key3, _tokenWalletWalletId);

    // print("LocalData() saveSelectedToken :  $_key : $_value");
    bool checkValue = prefs.containsKey(_key2);
    return checkValue;
  }

  Future<Map?> getSelectedToken() async {
    String _key1 = "selectedTokenId";
    String _key2 = "selectedTokenWalletId";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedTokenId = prefs.getString(_key1);
    String? selectedTokenWalletId = prefs.getString(_key2);
    // print("LocalData() getSelectedToken :  $_key : $stringValue");
    String _json = """
      {
        "selectedTokenId" : $selectedTokenId,
        "selectedTokenWalletId" : $selectedTokenWalletId,
      }
    """;
    Map _map = json.decode(_json);
    return _map;
  }

  Future<String?> getSelectedTokenId() async {
    String _key = "selectedTokenId";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedTokenId = prefs.getString(_key);
    return selectedTokenId;
  }

  Future<String?> getSelectedTokenWalletId() async {
    String _key = "selectedTokenWalletId";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedTokenWalletId = prefs.getString(_key);
    return selectedTokenWalletId;
  }

  Future<String?> getSelectedTokenWalletWalletId() async {
    String _key = "selectedTokenWalletWalletId";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedTokenWalletId = prefs.getString(_key);
    return selectedTokenWalletId;
  }

  removeValues(String _key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  removeAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
