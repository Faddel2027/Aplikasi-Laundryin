import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';

/// Search bar widget with leading icon and clear button.
///
/// States: default, focused, filled (with clear button).
class AppSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String hintText;
  final bool readOnly;
  final bool autoFocus;

  const AppSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.hintText = 'Cari layanan laundry...',
    this.readOnly = false,
    this.autoFocus = false,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
      _isInternalController = true;
    } else {
      _controller = widget.controller!;
    }
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (_isInternalController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;
    final hasText = _controller.text.isNotEmpty;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.inputRadius,
        border: Border.all(
          color: isFocused ? AppColors.primary : AppColors.border,
          width: isFocused ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              readOnly: widget.readOnly,
              autofocus: widget.autoFocus,
              style: AppTextTheme.body,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTextTheme.body.copyWith(
                  color: AppColors.textMuted,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                ),
                filled: false,
              ),
              onTap: widget.onTap,
              onChanged: (val) {
                widget.onChanged?.call(val);
                if (mounted) setState(() {});
              },
              onSubmitted: widget.onSubmitted,
            ),
          ),
          if (hasText)
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
              tooltip: 'Hapus pencarian',
            )
          else
            const SizedBox(width: AppSpacing.sm),
        ],
      ),
    );
  }
}
