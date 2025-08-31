// lib/services/auth.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io' show Platform;

import 'package:universal_html/js.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final storage = const FlutterSecureStorage();

  /// Email & Password login
  Future<Session?> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        throw 'Invalid email or password';
      }
      HapticFeedback.lightImpact();
      return response.session;
    } catch (e) {
      rethrow; // let UI handle error
    }
  }

  Future<void> sendOtp({required String? email}) async {
    try {
      await _supabase.auth.signInWithOtp(
        email: email,
        emailRedirectTo: null, // optional: deep link
      );
    } catch (e) {
      throw Exception("Failed to send OTP: $e");
    }
  }

  Future<AuthResponse> verifyOtp({
    required String otp,
  }) async {
    final userEmail = _supabase.auth.currentUser?.email;
    if (userEmail == null) {
      throw Exception("No logged-in user found");
    }
    try {
      final response = await _supabase.auth.verifyOTP(
        token: otp,
        type: OtpType.email, // only email verification
        email: userEmail,
      );
      if (response == true) {
        // get password back from secure storage
        final password = await storage.read(key: 'temp_password');

        if (password == null) {
          throw "Password not found. Please try logging in again.";
        }

        final session = await _supabase.auth.signInWithPassword(
          email: userEmail,
          password: password,
        );

        if (session != true) {
          await storage.delete(key: 'temp_password');

          ScaffoldMessenger.of(context as BuildContext).showSnackBar(
            const SnackBar(content: Text("Email verified & logged in!")),
          );
        }
        
      }      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Signup with email
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) {
        throw 'Signup failed';
      }
      HapticFeedback.lightImpact();
      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Google OAuth login
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    const webClientId =
        '923833708867-ee3gnpls7nk2i4vcucl5j3oogn2sjq8e.apps.googleusercontent.com';
    const iosClientId =
        '923833708867-i3hplfip4kb5qedm2u38uafodm2focj7.apps.googleusercontent.com';

    try {
      late final GoogleSignIn googleSignIn;

      if (Platform.isIOS) {
        googleSignIn = GoogleSignIn(
          clientId: iosClientId, // required on iOS
          serverClientId: webClientId,
        );
      } else {
        googleSignIn = GoogleSignIn(
          serverClientId: webClientId, // only needed on Android
        );
      }

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) throw 'Sign-in aborted by user';

      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null || googleAuth.accessToken == null) {
        throw 'Missing Google tokens';
      }

      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );
      return googleUser;
    } catch (e) {
      rethrow;
    }
  }

  ///Logout
  Future<void> signOut() async {
    final _googleSignIn = GoogleSignIn();

    await _supabase.auth.signOut();
    await _googleSignIn.signOut();
    try {
      await _googleSignIn.disconnect();
    } catch (e) {
      print("Logout error: $e");
    }
  }

  /// Current user
  User? get currentUser => _supabase.auth.currentUser;
  String get displayName {
    return currentUser?.userMetadata?['full_name'] ?? "User";
  }

  bool get isNewUser {
    if (currentUser == null) return false;
    final createdAt = DateTime.parse(currentUser!.createdAt);
    return DateTime.now().difference(createdAt).inSeconds < 30;
  }


}
