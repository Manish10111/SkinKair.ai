import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
// import '../../../core/app_export.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The entire original Column is replaced by this single Image widget
    return Image.asset(
      'assets/images/new_logo.png', // The path to your new logo
      height: 25.h, // You can adjust this height to make the logo bigger or smaller
    );
  }
}