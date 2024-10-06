import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/helper_function.dart';
import 'package:project_management_system/features/bottom_navigation/view/bottom_bar_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController with ChangeNotifier {
  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      showSnackBar(
          context: context,
          message: "Logged in Successfully",
          color: AppColor.primary);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomBarView()));

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('userId', credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(
            context: context, message: "No user found for that email.");
      } else {
        showSnackBar(
            context: context, message: "Login failed. Please try again.");
      }
    } catch (e) {
      showSnackBar(context: context, message: "An error occurred: $e");
    }
  }
}
