import 'package:flutter/material.dart';
import 'package:qisa/common/enum/result_state.dart';
import 'package:qisa/data/api/api_service.dart';
import 'package:qisa/data/models/request/request_add_story_model.dart';

class StoryAddProvider extends ChangeNotifier {
  final ApiService apiService;

  StoryAddProvider({required this.apiService});

  ResultState? _state;
  ResultState? get state => _state;

  String _message = '';
  String get message => _message;

  Future<dynamic> addStory(RequestAddStoryModel request) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await apiService.addStory(request: request);
      if (!result.error) {
        _state = ResultState.hasData;
        _message = 'Upload Story Success !!!';
      } else {
        _state = ResultState.noData;
        _message = 'Upload Story Failed !!!';
      }
    } catch (e) {
      _state = ResultState.error;
      return _message = "$e";
    } finally {
      notifyListeners();
    }
  }
}
