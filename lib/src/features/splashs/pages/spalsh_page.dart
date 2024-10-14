import 'package:flutter/material.dart';
import 'package:positio_test/src/themes/themes.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/constants.dart';
import '../../../../utils/utils.dart';
import '../../home/home.dart';
import '../../logins/logins.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double loadingValue = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      _updateLoadingProgress();
    });
  }

  _updateLoadingProgress() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (loadingValue >= 1) {
        _navigateToNextScreen();
        return;
      }
      loadingValue += 0.1;
      setState(() {});
      _updateLoadingProgress();
    });
  }

  Future<void> _navigateToNextScreen() async {
    final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
    String? val = prefsHelper.getString("identifiant");
    if (val != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorPrimary,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                AppConstants.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35.sp,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Center(
              child: Text(
                "GANDOUR",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}