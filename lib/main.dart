import 'package:blog_app/core/local_storage/shared_pref.dart';
import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/core/utils/init_controller.dart';
import 'package:blog_app/src/views/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorage.initSharedPref();
  await initController();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (buildContext, orientation, screenType) {
        return GetMaterialApp(
          defaultTransition: Transition.cupertino,
          transitionDuration: Duration(seconds: 1),
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const SplashScreen(),
        );
      },
    );
  }
}
