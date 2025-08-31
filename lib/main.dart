
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';
import '../widgets/custom_error_widget.dart';




// final AiSkincareService aiService = AiSkincareService.create(); // Initialize the service
void main() async {
  WidgetsFlutterBinding.ensureInitialized();



  // final aiService = await AiSkincareService.create();

  await Supabase.initialize(
    url: 'https://vulpkkznqmbqomjuvbjb.supabase.co',
    anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ1bHBra3pucW1icW9tanV2YmpiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYyOTM5MjUsImV4cCI6MjA3MTg2OTkyNX0.GMTSaZ-oZnGWTe5SHys9CMU6sUyHBABttH7wNpI9UQo',
  );


  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(
      errorDetails: details,
    );
  };
  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ]).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'skinkair.ai',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        //CRITICAL: NEVER REMOVE OR MODIFY
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
        //END CRITICAL SECTION
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.initial,
      );
    });
  }
}