import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

saveObject(String key, var value) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.setString(key, value);
}

saveintObject(String key, var value) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.setInt(key, value);
}

getSavedObject(String key) async {
  SharedPreferences sp = await SharedPreferences.getInstance();

  return sp.getString(key);
}


// Method to clear a value from SharedPreferences
clearSavedObject(String key) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.remove(key);
}

ShowToast(var messege) {
  Fluttertoast.showToast(
      msg: messege,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.NONE,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.shade400,
      textColor: Colors.grey.shade900,
      fontSize: 16.0);
}
