import 'package:flutter/material.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/custom_textfield.dart';
import 'package:project_management_system/core/global/helper_function.dart';
import 'package:project_management_system/core/utils/loading.dart';
import 'package:project_management_system/features/register/controller/register_controller.dart';
import 'package:project_management_system/features/login/view/login_screen.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://static.vecteezy.com/system/resources/thumbnails/010/925/404/small_2x/registration-page-name-and-password-field-fill-in-form-menu-bar-corporate-website-create-account-user-information-flat-design-modern-illustration-vector.jpg",
                ),
                CustomTextField(
                  controller: fullNameController,
                  hintText: "Full Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter full name';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: emailController,
                  hintText: "Email",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!regex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: passwordController,
                  hintText: "Password",
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                Consumer<RegisterController>(builder: (context, provider, _) {
                  return Container(
                    margin: EdgeInsets.all(5),
                    decoration: boxDecoration(),
                    child: DropdownButtonFormField<String>(
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      decoration: InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.primary),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.bg),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColor.primary, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: provider.roles.map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a role';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value != null) {
                          provider.onChangeRole(value);
                        }
                      },
                      hint: Text('Select Role'),
                    ),
                  );
                }),
                SizedBox(height: 20),
                Consumer<RegisterController>(builder: (context, provider, _) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<RegisterController>(context, listen: false)
                            .register(
                          context: context,
                          email: emailController.text,
                          name: fullNameController.text,
                          password: passwordController.text,
                        );
                      }
                    },
                    child: Ink(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: provider.isLoading
                            ? Loading()
                            : Text(
                                "Register",
                                style: TextStyle(color: AppColor.white),
                              ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.grey,
                          fontSize: 12),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      borderRadius: BorderRadius.circular(5),
                      highlightColor: AppColor.bg,
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
