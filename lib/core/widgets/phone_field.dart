import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';

/// Phone number validator for Indonesian numbers (9-13 digits without leading 0).
String? validatePhoneNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Nomor telepon tidak boleh kosong';
  }
  final cleaned = value.replaceAll(RegExp(r'\s+|-'), '');
  // Disallow leading 0 if typing after +62
  final digitsOnly = cleaned.startsWith('0') ? cleaned.substring(1) : cleaned;
  if (!RegExp(r'^[0-9]+$').hasMatch(digitsOnly)) {
    return 'Hanya boleh berisi angka';
  }
  if (digitsOnly.length < 9) {
    return 'Nomor telepon minimal 9 digit';
  }
  if (digitsOnly.length > 13) {
    return 'Nomor telepon maksimal 13 digit';
  }
  return null;
}

/// Phone input field with fixed +62 country prefix and state management.
///
/// States: empty, focused, filled, error, disabled.
class PhoneField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;
  final bool isDisabled;
  final String? hintText;
  final FocusNode? focusNode;

  const PhoneField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.isDisabled = false,
    this.hintText = '812 3456 7890',
    this.focusNode,
  });

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isInternalController = false;
  bool _isInternalFocusNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
      _isInternalController = true;
    } else {
      _controller = widget.controller!;
    }

    if (widget.focusNode == null) {
      _focusNode = FocusNode();
      _isInternalFocusNode = true;
    } else {
      _focusNode = widget.focusNode!;
    }

    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (_isInternalController) _controller.dispose();
    if (_isInternalFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError =
        widget.errorText != null && widget.errorText!.isNotEmpty;
    final bool isFocused = _focusNode.hasFocus;

    Color borderColor = AppColors.border;
    if (widget.isDisabled) {
      borderColor = AppColors.disabledBackground;
    } else if (hasError) {
      borderColor = AppColors.error;
    } else if (isFocused) {
      borderColor = AppColors.primary;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: AppSpacing.minTouchTarget + 6,
          decoration: BoxDecoration(
            color: widget.isDisabled
                ? AppColors.surfaceVariant
                : AppColors.surface,
            borderRadius: AppRadius.inputRadius,
            border: Border.all(
              color: borderColor,
              width: isFocused || hasError ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              // Prefix +62 with flag / badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: AppColors.border, width: 1.0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🇮🇩', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '+62',
                      style: AppTextTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: widget.isDisabled
                            ? AppColors.disabledText
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              // Input text field
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: !widget.isDisabled,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(13),
                  ],
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: widget.isDisabled
                        ? AppColors.disabledText
                        : AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: AppTextTheme.body.copyWith(
                      color: AppColors.textMuted,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    filled: false,
                  ),
                  onChanged: (val) {
                    widget.onChanged?.call(val);
                    if (mounted) setState(() {});
                  },
                  onSubmitted: widget.onSubmitted,
                ),
              ),
              if (_controller.text.isNotEmpty && !widget.isDisabled)
                IconButton(
                  icon: const Icon(
                    Icons.cancel_rounded,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                    if (mounted) setState(() {});
                  },
                  tooltip: 'Hapus',
                ),
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs),
            child: Text(
              widget.errorText!,
              style: AppTextTheme.caption.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ],
    );
  }
}
