import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TextInputFallbackWidget extends StatefulWidget {
  final String question;
  final String? initialValue;
  final Function(String) onSubmit;
  final VoidCallback onCancel;

  const TextInputFallbackWidget({
    Key? key,
    required this.question,
    this.initialValue,
    required this.onSubmit,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<TextInputFallbackWidget> createState() =>
      _TextInputFallbackWidgetState();
}

class _TextInputFallbackWidgetState extends State<TextInputFallbackWidget> {
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialValue ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_textController.text.trim().isNotEmpty) {
      widget.onSubmit(_textController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'keyboard',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Type your response',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            widget.question,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: _textController,
            focusNode: _focusNode,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleSubmit(),
            decoration: InputDecoration(
              hintText: 'Enter your answer here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.w),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.w),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: widget.onCancel,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                  label: Text('Cancel'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _textController.text.trim().isEmpty
                      ? null
                      : _handleSubmit,
                  icon: CustomIconWidget(
                    iconName: 'send',
                    color: _textController.text.trim().isEmpty
                        ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        : AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 4.w,
                  ),
                  label: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 3.w),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
