import 'package:intl/intl.dart';

class Converter {
  static String currencyIndonesia(int value) {
    return NumberFormat.currency(
        locale: 'id', symbol: 'Rp ', decimalDigits: 0)
        .format(value);
  }
  static String cIWithoutSymbol(int value) {
    return NumberFormat.currency(
        locale: 'id', symbol: '',decimalDigits: 0)
        .format(value);
  }
}