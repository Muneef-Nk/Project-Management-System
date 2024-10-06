import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/features/add_project/controller/add_project_controller.dart';
import 'package:project_management_system/features/bottom_navigation/controller/bottom_navigation_controller.dart';
import 'package:project_management_system/features/forgot_password/controller/forgot_password_controller.dart';
import 'package:project_management_system/features/home/controller/homescreen_controller.dart';
import 'package:project_management_system/features/login/controller/login_controller.dart';
import 'package:project_management_system/features/payment_recorde/controller/payment_record_controller.dart';
import 'package:project_management_system/features/project_details/controller/project_details_controller.dart';
import 'package:project_management_system/features/register/controller/register_controller.dart';
import 'package:project_management_system/features/reports/controller/report_controller.dart';
import 'package:project_management_system/features/splash_screeen/splash_screen.dart';
import 'package:project_management_system/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => BottomNavigationController()),
        ChangeNotifierProvider(create: (context) => AddProjectController()),
        ChangeNotifierProvider(create: (context) => ProjectDetailsController()),
        ChangeNotifierProvider(create: (context) => PaymentRecordController()),
        ChangeNotifierProvider(create: (context) => HomescreenController()),
        ChangeNotifierProvider(create: (context) => ReportController()),
        ChangeNotifierProvider(create: (context) => RegisterController()),
        ChangeNotifierProvider(create: (context) => LoginController()),
        ChangeNotifierProvider(create: (context) => ForgotPasswordController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColor.bg,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
