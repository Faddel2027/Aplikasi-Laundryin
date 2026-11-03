import 'package:flutter_test/flutter_test.dart';
import 'package:laundryin/core/utils/format_rupiah.dart';

void main() {
  group('formatRupiah full mode (compact = false)', () {
    test('formats 0 correctly', () {
      expect(formatRupiah(0), equals('Rp0'));
    });

    test('formats 999 correctly', () {
      expect(formatRupiah(999), equals('Rp999'));
    });

    test('formats 1000 correctly', () {
      expect(formatRupiah(1000), equals('Rp1.000'));
    });

    test('formats 7000 correctly', () {
      expect(formatRupiah(7000), equals('Rp7.000'));
    });

    test('formats 25000 correctly', () {
      expect(formatRupiah(25000), equals('Rp25.000'));
    });

    test('formats 1250000 correctly', () {
      expect(formatRupiah(1250000), equals('Rp1.250.000'));
    });
  });

  group('formatRupiah compact mode (compact = true)', () {
    test('formats 0 correctly', () {
      expect(formatRupiah(0, compact: true), equals('Rp0'));
    });

    test('formats 999 correctly', () {
      expect(formatRupiah(999, compact: true), equals('Rp999'));
    });

    test('formats 1000 correctly', () {
      expect(formatRupiah(1000, compact: true), equals('Rp1rb'));
    });

    test('formats 7000 correctly', () {
      expect(formatRupiah(7000, compact: true), equals('Rp7rb'));
    });

    test('formats 25000 correctly', () {
      expect(formatRupiah(25000, compact: true), equals('Rp25rb'));
    });

    test('formats 1250000 correctly', () {
      expect(formatRupiah(1250000, compact: true), equals('Rp1,25jt'));
    });
  });
}
