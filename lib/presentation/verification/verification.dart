// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shake/shake.dart';
// import 'package:sizer/sizer.dart';

// import '../../core/app_export.dart';
// import 'widgets/countdown_timer_widget.dart';
// import 'widgets/otp_digit_input_widget.dart';
// import 'widgets/phone_number_display_widget.dart';
// import 'widgets/resend_otp_widget.dart';

// class OtpInputScreen extends StatefulWidget {
//   const OtpInputScreen({Key? key}) : super(key: key);

//   @override
//   State<OtpInputScreen> createState() => _OtpInputScreenState();
// }

// class _OtpInputScreenState extends State<OtpInputScreen>
//     with TickerProviderStateMixin {
//   final List<String> _otpDigits = List.filled(6, '');
//   int _currentIndex = 0;
//   bool _isLoading = false;
//   bool _hasError = false;
//   String _errorMessage = '';
//   bool _isTimerExpired = false;
//   late ShakeDetector _shakeDetector;
//   late AnimationController _shakeAnimationController;
//   late Animation<double> _shakeAnimation;

//   // Mock phone number for display
//   final String _phoneNumber = '+1 (555) 123-4567';

//   // Mock correct OTP for validation
//   final String _correctOtp = '123456';

//   @override
//   void initState() {
//     super.initState();
//     _initializeShakeDetection();
//     _initializeAnimations();
//     _simulateAutoDetection();
//   }

//   void _initializeShakeDetection() {
//     _shakeDetector = ShakeDetector.autoStart(
//       onPhoneShake: (ShakeEvent event) {
//         if (mounted) {
//           _clearOtp();
//           HapticFeedback.mediumImpact();
//         }
//       },
//       minimumShakeCount: 2,
//       shakeSlopTimeMS: 500,
//       shakeCountResetTime: 3000,
//       shakeThresholdGravity: 2.7,
//     );
//   }

//   void _initializeAnimations() {
//     _shakeAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _shakeAnimation = Tween<double>(
//       begin: 0,
//       end: 10,
//     ).animate(CurvedAnimation(
//       parent: _shakeAnimationController,
//       curve: Curves.elasticIn,
//     ));
//   }

//   void _simulateAutoDetection() {
//     // Simulate SMS auto-detection after 3 seconds
//     Timer(const Duration(seconds: 3), () {
//       if (mounted && _otpDigits.every((digit) => digit.isEmpty)) {
//         _showAutoDetectionDialog();
//       }
//     });
//   }

//   void _showAutoDetectionDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             CustomIconWidget(
//               iconName: 'sms',
//               color: Theme.of(context).colorScheme.primary,
//               size: 24,
//             ),
//             SizedBox(width: 2.w),
//             Text('SMS Detected'),
//           ],
//         ),
//         content: Text(
//             'We detected an OTP in your messages. Would you like to auto-fill it?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _autoFillOtp(_correctOtp);
//             },
//             child: Text('Auto-fill'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _autoFillOtp(String otp) {
//     for (int i = 0; i < otp.length && i < 6; i++) {
//       setState(() {
//         _otpDigits[i] = otp[i];
//       });
//     }
//     setState(() {
//       _currentIndex = otp.length < 6 ? otp.length : 6;
//       _hasError = false;
//       _errorMessage = '';
//     });
//     HapticFeedback.lightImpact();
//   }

//   void _onDigitTap(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   void _onKeyPressed(String key) {
//     if (key == 'backspace') {
//       _handleBackspace();
//     } else if (RegExp(r'[0-9]').hasMatch(key) && key.length == 1) {
//       _handleDigitInput(key);
//     }
//   }

//   void _handleDigitInput(String digit) {
//     if (_currentIndex < 6) {
//       setState(() {
//         _otpDigits[_currentIndex] = digit;
//         _currentIndex = _currentIndex < 5 ? _currentIndex + 1 : 6;
//         _hasError = false;
//         _errorMessage = '';
//       });
//       HapticFeedback.lightImpact();
//     }
//   }

//   void _handleBackspace() {
//     if (_currentIndex > 0) {
//       setState(() {
//         if (_currentIndex == 6 && _otpDigits[5].isNotEmpty) {
//           _otpDigits[5] = '';
//           _currentIndex = 5;
//         } else {
//           _currentIndex--;
//           _otpDigits[_currentIndex] = '';
//         }
//         _hasError = false;
//         _errorMessage = '';
//       });
//       HapticFeedback.lightImpact();
//     }
//   }

//   void _clearOtp() {
//     setState(() {
//       _otpDigits.fillRange(0, 6, '');
//       _currentIndex = 0;
//       _hasError = false;
//       _errorMessage = '';
//     });
//   }

//   bool get _isOtpComplete => _otpDigits.every((digit) => digit.isNotEmpty);

//   String get _enteredOtp => _otpDigits.join();

//   Future<void> _verifyOtp() async {
//     if (!_isOtpComplete) return;

//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//       _errorMessage = '';
//     });

//     // Simulate network delay
//     await Future.delayed(const Duration(seconds: 2));

//     if (!mounted) return;

//     if (_enteredOtp == _correctOtp) {
//       // Success - navigate to success screen
//       HapticFeedback.heavyImpact();
//       Navigator.pushReplacementNamed(
//           context, '/otp-verification-success-screen');
//     } else {
//       // Error - show validation error
//       setState(() {
//         _hasError = true;
//         _errorMessage = 'Invalid OTP. Please check and try again.';
//         _isLoading = false;
//       });
//       _shakeAnimationController.forward().then((_) {
//         _shakeAnimationController.reverse();
//       });
//       HapticFeedback.heavyImpact();
//     }
//   }

//   void _resendOtp() {
//     // Simulate resend OTP
//     setState(() {
//       _isTimerExpired = false;
//     });
//     HapticFeedback.lightImpact();

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             CustomIconWidget(
//               iconName: 'check_circle',
//               color: Colors.white,
//               size: 20,
//             ),
//             SizedBox(width: 2.w),
//             Text('OTP sent successfully'),
//           ],
//         ),
//         backgroundColor: AppTheme.getSuccessColor(
//             Theme.of(context).brightness == Brightness.light),
//       ),
//     );
//   }

//   void _onTimerExpired() {
//     setState(() {
//       _isTimerExpired = true;
//     });
//   }

//   void _changePhoneNumber() {
//     Navigator.pop(context);
//   }

//   @override
//   void dispose() {
//     _shakeDetector.stopListening();
//     _shakeAnimationController.dispose();
//     super.dispose();
//   }

//   Widget _buildKeypad() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 4.w),
//       child: Column(
//         children: [
//           // Numbers 1-3
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildKeypadButton('1'),
//               _buildKeypadButton('2'),
//               _buildKeypadButton('3'),
//             ],
//           ),
//           SizedBox(height: 2.h),
//           // Numbers 4-6
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildKeypadButton('4'),
//               _buildKeypadButton('5'),
//               _buildKeypadButton('6'),
//             ],
//           ),
//           SizedBox(height: 2.h),
//           // Numbers 7-9
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildKeypadButton('7'),
//               _buildKeypadButton('8'),
//               _buildKeypadButton('9'),
//             ],
//           ),
//           SizedBox(height: 2.h),
//           // 0 and backspace
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               SizedBox(width: 20.w), // Empty space
//               _buildKeypadButton('0'),
//               _buildKeypadButton('backspace', isBackspace: true),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildKeypadButton(String key, {bool isBackspace = false}) {
//     return GestureDetector(
//       onTap: () => _onKeyPressed(key),
//       child: Container(
//         width: 20.w,
//         height: 8.h,
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.surface,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
//           ),
//         ),
//         child: Center(
//           child: isBackspace
//               ? CustomIconWidget(
//                   iconName: 'backspace',
//                   color: Theme.of(context).colorScheme.onSurface,
//                   size: 24,
//                 )
//               : Text(
//                   key,
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                         fontWeight: FontWeight.w500,
//                       ),
//                 ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: CustomIconWidget(
//             iconName: 'arrow_back',
//             color: Theme.of(context).colorScheme.onSurface,
//             size: 24,
//           ),
//         ),
//         title: Text('Verify OTP'),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 4.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 2.h),

//               // Phone number display
//               PhoneNumberDisplayWidget(
//                 phoneNumber: _phoneNumber,
//                 onChangeNumber: _changePhoneNumber,
//               ),

//               SizedBox(height: 4.h),

//               // Title and description
//               Text(
//                 'Enter Verification Code',
//                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     ),
//                 textAlign: TextAlign.center,
//               ),

//               SizedBox(height: 1.h),

//               Text(
//                 'We sent a 6-digit code to your phone number',
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       color: Theme.of(context).colorScheme.onSurfaceVariant,
//                     ),
//                 textAlign: TextAlign.center,
//               ),

//               SizedBox(height: 4.h),

//               // OTP input fields
//               AnimatedBuilder(
//                 animation: _shakeAnimation,
//                 builder: (context, child) {
//                   return Transform.translate(
//                     offset: Offset(_shakeAnimation.value, 0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: List.generate(6, (index) {
//                         return OtpDigitInputWidget(
//                           digit: _otpDigits[index],
//                           isActive: _currentIndex == index,
//                           hasError: _hasError,
//                           onTap: () => _onDigitTap(index),
//                         );
//                       }),
//                     ),
//                   );
//                 },
//               ),

//               SizedBox(height: 2.h),

//               // Error message
//               if (_hasError) ...[
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.errorContainer,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CustomIconWidget(
//                         iconName: 'error_outline',
//                         color: Theme.of(context).colorScheme.error,
//                         size: 16,
//                       ),
//                       SizedBox(width: 2.w),
//                       Flexible(
//                         child: Text(
//                           _errorMessage,
//                           style:
//                               Theme.of(context).textTheme.bodySmall?.copyWith(
//                                     color: Theme.of(context).colorScheme.error,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 2.h),
//               ],

//               // Timer
//               if (!_isTimerExpired)
//                 CountdownTimerWidget(
//                   initialSeconds: 300,
//                   onTimerExpired: _onTimerExpired,
//                 ),

//               SizedBox(height: 3.h),

//               // Resend OTP
//               ResendOtpWidget(
//                 onResend: _resendOtp,
//                 cooldownSeconds: 30,
//               ),

//               SizedBox(height: 4.h),

//               // Verify button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _isOtpComplete && !_isLoading ? _verifyOtp : null,
//                   child: _isLoading
//                       ? SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Theme.of(context).colorScheme.onPrimary,
//                             ),
//                           ),
//                         )
//                       : Text('Verify OTP'),
//                 ),
//               ),

//               SizedBox(height: 2.h),

//               // Clear button
//               TextButton(
//                 onPressed: _clearOtp,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CustomIconWidget(
//                       iconName: 'refresh',
//                       color: Theme.of(context).colorScheme.primary,
//                       size: 16,
//                     ),
//                     SizedBox(width: 1.w),
//                     Text('Clear & Start Over'),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 4.h),

//               // Keypad
//               _buildKeypad(),

//               SizedBox(height: 2.h),

//               // Help text
//               Container(
//                 padding: EdgeInsets.all(3.w),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context)
//                       .colorScheme
//                       .primaryContainer
//                       .withValues(alpha: 0.3),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   children: [
//                     CustomIconWidget(
//                       iconName: 'info_outline',
//                       color: Theme.of(context).colorScheme.primary,
//                       size: 20,
//                     ),
//                     SizedBox(width: 3.w),
//                     Expanded(
//                       child: Text(
//                         'Shake your device to clear the OTP or use the keypad to enter manually',
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 2.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import './widgets/countdown_timer_widget.dart';
// import './widgets/resend_otp_widget.dart';
import './widgets/otp_digit_input_widget.dart';
import '../../services/auth.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final AuthService _auth = AuthService();
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _hiddenTextFieldFocus = FocusNode();

  bool _isLoading = false;
  String? _error;

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await AuthService().verifyOtp(
        otp: _otpController.text.trim(),
      );

      if (response.session != null) {
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
      } else {
        setState(() => _error = "OTP verification failed.");
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _hiddenTextFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("No user is logged in");
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Verification Required",
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              
              Text(
                "We've sent a verification code to ${user.email}",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // OTP Input Boxes
              GestureDetector(
                onTap: () =>
                    FocusScope.of(context).requestFocus(_hiddenTextFieldFocus),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    final digit = index < _otpController.text.length
                        ? _otpController.text[index]
                        : "";
                    return OtpDigitInputWidget(
                      digit: digit,
                      isActive: _otpController.text.length == index,
                      hasError: false, // toggle on validation error if needed
                      onTap: () {
                        FocusScope.of(context)
                            .requestFocus(_hiddenTextFieldFocus);
                      },
                    );
                  }),
                ),
              ),

              // Hidden TextField (captures user input)
              SizedBox(
                height: 0,
                width: 0,
                child: TextField(
                  focusNode: _hiddenTextFieldFocus,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  onChanged: (_) => setState(() {}), // Refresh UI
                  autofocus: true,
                ),
              ),

              const SizedBox(height: 24),

              // Verify Button
              ElevatedButton(
                onPressed: _otpController.text.length == 6 ? _verifyOtp : null,
                child: const Text("Verify Email"),
              ),

              const SizedBox(height: 24),

              // Countdown Timer
              CountdownTimerWidget(
                initialSeconds: 300, // 5 minutes
                onTimerExpired: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Your OTP has expired")),
                  );
                  Navigator.pushReplacementNamed(context, '/verification');

                },
              ),
              const SizedBox(height: 16),

              // Resend OTP
              //   ResendOtpWidget(
            //     cooldownSeconds: 30,
            //     onResend: () async {
            //       final user = _auth.currentUser;
            //       if (user == null) {
            //         throw Exception("No user is logged in");
            //       }
            //       await _auth.sendOtp(email: user.email);
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(content: Text("OTP resent to your email")),
            //       );
            //     },
            //   ),
              // 
            ],
          ),
        ),
      ),
    );
  }
}
