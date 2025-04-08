import 'package:flutter/material.dart';

class HelperNav {
  static afterBuildWidgetCallback(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback.call();
    });
  }
}
