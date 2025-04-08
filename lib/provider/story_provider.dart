import 'package:flutter/material.dart';
import 'package:qisa/common/enum/result_state.dart';
import 'package:qisa/data/api/api_service.dart';
import 'package:qisa/data/models/results/story.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;

  StoryProvider({required this.apiService}) {
    _getStories();
  }

  ResultState? _state;
  ResultState? get state => _state;

  String _message = '';
  String get message => _message;

  final List<Story> _stories = [];
  List<Story> get stories => _stories;
  Future<dynamic> getStories() => _getStories();

  Future<dynamic> _getStories() async {
    try {
      _stories.clear();
      _state = ResultState.loading;
      notifyListeners();

      final result = await apiService.getStories();
      if (result.listStory.isNotEmpty) {
        _state = ResultState.hasData;
        _stories.addAll(result.listStory);
        _message = 'Get All Story Success !!!';
      } else {
        _state = ResultState.noData;
        _message = 'Get All Story Failed !!!';
      }
    } catch (e) {
      _state = ResultState.error;
      return _message = "$e";
    } finally {
      notifyListeners();
    }
  }
}
