// import 'package:intl/intl.dart';

extension StringExt on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String toCamelCase() {
    return split(' ')
        .map((String word) {
          return word.capitalize();
        })
        .join('');
  }

  String toSnakeCase() {
    return split(' ').join('_').toLowerCase();
  }

  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }

  String fromBase64() {
    return split(',').last.trim();
  }
}
