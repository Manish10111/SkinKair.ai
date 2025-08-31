// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// import '../../../core/app_export.dart';

// class CountdownTimerWidget extends StatefulWidget {
//   final int initialSeconds;
//   final VoidCallback? onTimerExpired;
//   final bool isResendEnabled;

//   const CountdownTimerWidget({
//     Key? key,
//     this.initialSeconds = 300, // 5 minutes
//     this.onTimerExpired,
//     this.isResendEnabled = false,
//   }) : super(key: key);

//   @override
//   State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
// }

// class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
//   late Timer _timer;
//   late int _remainingSeconds;

//   @override
//   void initState() {
//     super.initState();
//     _remainingSeconds = widget.initialSeconds;
//     _startTimer();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_remainingSeconds > 0) {
//         setState(() {
//           _remainingSeconds--;
//         });
//       } else {
//         _timer.cancel();
//         widget.onTimerExpired?.call();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   String _formatTime(int seconds) {
//     final minutes = seconds ~/ 60;
//     final remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CustomIconWidget(
//               iconName: 'access_time',
//               color: _remainingSeconds <= 60
//                   ? AppTheme.getWarningColor(!isDarkMode)
//                   : Theme.of(context).colorScheme.onSurfaceVariant,
//               size: 16,
//             ),
//             SizedBox(width: 2.w),
//             Text(
//               'Code expires in ${_formatTime(_remainingSeconds)}',
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: _remainingSeconds <= 60
//                         ? AppTheme.getWarningColor(!isDarkMode)
//                         : Theme.of(context).colorScheme.onSurfaceVariant,
//                     fontWeight: _remainingSeconds <= 60
//                         ? FontWeight.w500
//                         : FontWeight.w400,
//                   ),
//             ),
//           ],
//         ),
//         if (_remainingSeconds == 0) ...[
//           SizedBox(height: 2.h),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.errorContainer,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CustomIconWidget(
//                   iconName: 'error_outline',
//                   color: Theme.of(context).colorScheme.error,
//                   size: 16,
//                 ),
//                 SizedBox(width: 2.w),
//                 Text(
//                   'OTP has expired',
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                         color: Theme.of(context).colorScheme.error,
//                         fontWeight: FontWeight.w500,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ],
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class CountdownTimerWidget extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback? onTimerExpired;

  const CountdownTimerWidget({
    Key? key,
    this.initialSeconds = 300, // default 5 minutes
    this.onTimerExpired,
  }) : super(key: key);

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Timer _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer.cancel();
        widget.onTimerExpired?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time,
                color: _remainingSeconds <= 60
                    ? Colors.orange
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 16),
            SizedBox(width: 2.w),
            Text(
              'Code expires in ${_formatTime(_remainingSeconds)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _remainingSeconds <= 60
                        ? Colors.orange
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight:
                        _remainingSeconds <= 60 ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ],
        ),
        if (_remainingSeconds == 0) ...[
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline,
                    color: Theme.of(context).colorScheme.error, size: 16),
                SizedBox(width: 2.w),
                Text(
                  'OTP has expired',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
