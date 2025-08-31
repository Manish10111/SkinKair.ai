import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ResendOtpWidget extends StatefulWidget {
  final VoidCallback onResend;
  final int cooldownSeconds;

  const ResendOtpWidget({
    Key? key,
    required this.onResend,
    this.cooldownSeconds = 30,
  }) : super(key: key);

  @override
  State<ResendOtpWidget> createState() => _ResendOtpWidgetState();
}

class _ResendOtpWidgetState extends State<ResendOtpWidget> {
  bool _isEnabled = false;
  int _remainingCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  void _startCooldown() {
    setState(() {
      _isEnabled = false;
      _remainingCooldown = widget.cooldownSeconds;
    });

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingCooldown > 0) {
        setState(() {
          _remainingCooldown--;
        });
      } else {
        setState(() {
          _isEnabled = true;
        });
        timer.cancel();
      }
    });
  }

  void _handleResend() {
    if (_isEnabled) {
      widget.onResend();
      _startCooldown();
    }
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive the code? ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            GestureDetector(
              onTap: _handleResend,
              child: Text(
                _isEnabled ? 'Resend OTP' : 'Resend in ${_remainingCooldown}s',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _isEnabled
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                      decoration: _isEnabled ? TextDecoration.underline : null,
                    ),
              ),
            ),
          ],
        ),
        if (!_isEnabled) ...[
          SizedBox(height: 1.h),
          Container(
            width: 60.w,
            height: 4,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_remainingCooldown / widget.cooldownSeconds),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
