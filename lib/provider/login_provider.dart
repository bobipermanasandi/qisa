import 'package:flutter/material.dart';
import 'package:qisa/common/enum/result_state.dart';
import 'package:qisa/data/api/api_service.dart';
import 'package:qisa/data/local/preference_helper.dart';
import 'package:qisa/data/models/request/request_login_model.dart';

class LoginProvider extends ChangeNotifier {
  final ApiService apiService;
  final PreferencesHelper pref;

  LoginProvider({required this.apiService, required this.pref});

  ResultState? _state;
  ResultState? get state => _state;

  String _message = '';
  String get message => _message;

  Future<dynamic> login(RequestLoginModel request) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await apiService.login(request: request);
      if (!result.error) {
        _state = ResultState.hasData;
        pref.setToken(result.loginResult!.token);
        _message = result.message;
      } else {
        _state = ResultState.noData;
        _message = result.message;
      }
    } catch (e) {
      _state = ResultState.error;
      return _message = "$e";
    } finally {
      notifyListeners();
    }
  }
}
