import 'package:flutter/material.dart';
import 'package:skinkair_ai/presentation/profile.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/voice_onboarding/voice_onboarding.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/product_routine/product_routine.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/verification/verification.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String login = '/login-screen';
  static const String dashboard = '/dashboard';
  static const String voiceOnboarding = '/voice-onboarding';
  static const String registration = '/registration-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String productRoutine = '/product-routine';
  static const String verification = '/verification';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
        initial: (context) => const SplashScreen(),
        splash: (context) => const SplashScreen(),
        login: (context) => const LoginScreen(),
        registration: (context) => const RegistrationScreen(),
        onboardingFlow: (context) => const OnboardingFlow(),
        voiceOnboarding: (context) => const VoiceOnboarding(),
        dashboard: (context) => const Dashboard(),
        profile: (context) => const ProfilePage(),
        productRoutine: (context) => const ProductRoutine(),
        verification: (context) => const VerificationPage(),
      };

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const SplashScreen(),
    );
  }
}
