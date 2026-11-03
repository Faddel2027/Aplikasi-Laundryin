import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';

/// 6-digit OTP verification field.
///
/// Handles:
/// - 6 separate square boxes with states: empty, focused, filled, error, disabled.
/// - Automatic focus advance on typing.
/// - Backspace handling to previous box.
/// - Full 6-digit paste from clipboard.
/// - Auto-trigger of [onCompleted] when all 6 boxes are filled.
class OtpField extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool hasError;
  final bool isDisabled;
  final bool autoFocus;

  const OtpField({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.hasError = false,
    this.isDisabled = false,
    this.autoFocus = true,
  });

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());

    for (var i = 0; i < widget.length; i++) {
      _focusNodes[i].addListener(() {
        if (mounted) setState(() {});
      });
    }

    if (widget.autoFocus && !widget.isDisabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _focusNodes.isNotEmpty) {
          _focusNodes[0].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentOtp => _controllers.map((c) => c.text).join();

  void _notifyChange() {
    final otp = _currentOtp;
    widget.onChanged?.call(otp);
    if (otp.length == widget.length) {
      widget.onCompleted?.call(otp);
    }
  }

  void _handlePaste(String text) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;

    final takeCount = digits.length.clamp(0, widget.length);
    for (var i = 0; i < takeCount; i++) {
      _controllers[i].text = digits[i];
    }
    for (var i = takeCount; i < widget.length; i++) {
      _controllers[i].clear();
    }

    if (takeCount < widget.length) {
      _focusNodes[takeCount].requestFocus();
    } else {
      _focusNodes.last.unfocus();
    }
    _notifyChange();
    if (mounted) setState(() {});
  }

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      // Possible paste into a single box
      _handlePaste(value);
      return;
    }

    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    _notifyChange();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        final isFilled = _controllers[index].text.isNotEmpty;
        final isFocused = _focusNodes[index].hasFocus;

        Color borderColor = AppColors.border;
        if (widget.isDisabled) {
          borderColor = AppColors.disabledBackground;
        } else if (widget.hasError) {
          borderColor = AppColors.error;
        } else if (isFocused) {
          borderColor = AppColors.primary;
        } else if (isFilled) {
          borderColor = AppColors.primaryDark;
        }

        return SizedBox(
          width: 48,
          height: 56,
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace &&
                  _controllers[index].text.isEmpty &&
                  index > 0) {
                _controllers[index - 1].clear();
                _focusNodes[index - 1].requestFocus();
                _notifyChange();
                if (mounted) setState(() {});
              }
            },
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              enabled: !widget.isDisabled,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTextTheme.h2.copyWith(
                color: widget.hasError
                    ? AppColors.error
                    : (widget.isDisabled
                          ? AppColors.disabledText
                          : AppColors.textPrimary),
              ),
              decoration: InputDecoration(
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                ),
                fillColor: widget.isDisabled
                    ? AppColors.surfaceVariant
                    : (isFocused
                          ? AppColors.primaryLight.withValues(alpha: 0.3)
                          : AppColors.surface),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.inputRadius,
                  borderSide: BorderSide(
                    color: borderColor,
                    width: isFocused || widget.hasError ? 1.5 : 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.inputRadius,
                  borderSide: BorderSide(
                    color: borderColor,
                    width: isFocused || widget.hasError ? 1.5 : 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.inputRadius,
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.inputRadius,
                  borderSide: const BorderSide(
                    color: AppColors.disabledBackground,
                  ),
                ),
              ),
              onChanged: (val) => _onDigitChanged(index, val),
            ),
          ),
        );
      }),
    );
  }
}
