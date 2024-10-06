import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/helper_function.dart';

class ForgotPasswordController with ChangeNotifier {
  Future<void> sendPasswordResetEmail(
      String emailAddress, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailAddress)
          .then((value) {
        showSnackBar(
          context: context,
          message: "Password reset email sent. Check your inbox.",
          color: AppColor.primary,
        );
        Navigator.of(context).pop();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(
          context: context,
          message: "No account found for this email.",
        );
      } else if (e.code == 'invalid-email') {
        showSnackBar(
          context: context,
          message: "The email address is not valid.",
        );
      } else {
        showSnackBar(
          context: context,
          message: "An unexpected error occurred: ${e.message}",
        );
      }
    } catch (e) {
      showSnackBar(
        context: context,
        message: "An error occurred. Please try again.",
        color: Colors.red,
      );
    }
    notifyListeners();
  }
}
