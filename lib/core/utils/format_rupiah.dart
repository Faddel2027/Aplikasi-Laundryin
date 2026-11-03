import 'package:intl/intl.dart';

/// Formats an integer amount into standard Indonesian Rupiah currency string.
///
/// Rules per docs/PRD.md:
/// - Full mode (`compact = false`): "Rp7.000" (dot as thousands separator, no space after Rp)
/// - Compact mode (`compact = true`): "Rp7rb" (only for small cards/badges)
String formatRupiah(int amount, {bool compact = false}) {
  if (!compact) {
    // Number format for ID with dot separator
    final formatter = NumberFormat('#,###', 'id_ID');
    final formatted = formatter.format(amount).replaceAll(',', '.');
    return 'Rp$formatted';
  }

  if (amount < 1000) {
    return 'Rp$amount';
  } else if (amount < 1000000) {
    if (amount % 1000 == 0) {
      return 'Rp${amount ~/ 1000}rb';
    }
    final formatted = (amount / 1000).toStringAsFixed(1).replaceAll('.', ',');
    final clean = formatted.endsWith(',0')
        ? formatted.substring(0, formatted.length - 2)
        : formatted;
    return 'Rp${clean}rb';
  } else if (amount < 1000000000) {
    if (amount % 1000000 == 0) {
      return 'Rp${amount ~/ 1000000}jt';
    }
    final formatted = (amount / 1000000)
        .toStringAsFixed(2)
        .replaceAll('.', ',');
    var clean = formatted;
    if (clean.endsWith('0')) {
      clean = clean.substring(0, clean.length - 1);
    }
    if (clean.endsWith(',0')) {
      clean = clean.substring(0, clean.length - 2);
    }
    return 'Rp${clean}jt';
  } else {
    final formatted = (amount / 1000000000)
        .toStringAsFixed(1)
        .replaceAll('.', ',');
    final clean = formatted.endsWith(',0')
        ? formatted.substring(0, formatted.length - 2)
        : formatted;
    return 'Rp${clean}M';
  }
}
