import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/helper_function.dart';
import 'package:project_management_system/features/bottom_navigation/view/bottom_bar_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController with ChangeNotifier {
  String? selectedRole;
  final List<String> roles = ['Admin', 'Project Manager', 'Team Lead'];
  bool isLoading = false;

  onChangeRole(String value) {
    selectedRole = value;
    notifyListeners();
  }

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    setLoading(true);
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await saveUserData(
        uid: credential.user?.uid,
        email: email,
        name: name,
        role: selectedRole ?? '',
      );

      showSnackBar(
          context: context,
          message: "Registered Successfully",
          color: AppColor.primary);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomBarView()));

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('userId', credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showSnackBar(
          context: context,
          message: "An account already exists for that email.",
        );
      } else if (e.code == 'invalid-email') {
        showSnackBar(
          context: context,
          message: "The email address is not valid.",
        );
      } else {
        showSnackBar(
          context: context,
          message: "Registration failed. Try again later..",
        );
      }
    } catch (e) {
      showSnackBar(
        context: context,
        message: "An error occurred",
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> saveUserData({
    required String? uid,
    required String email,
    required String name,
    required String role,
  }) async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    await usersCollection.doc(uid).set({
      'name': name,
      'email': email,
      'role': role,
    });
  }
}
