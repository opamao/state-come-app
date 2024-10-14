import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:positio_test/src/features/splashs/splashs.dart';
import 'package:positio_test/src/themes/themes.dart';
import 'package:sizer/sizer.dart';

import 'constants/constants.dart';
import 'utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, _, __) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: appColorPrimary),
            useMaterial3: true,
            textTheme: GoogleFonts.lateefTextTheme(),
            scaffoldBackgroundColor: Colors.white,
        ),
        home: const SplashPage(),
      );
    });
  }
}