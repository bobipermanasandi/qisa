import 'package:flutter/material.dart';
import 'package:qisa/data/models/results/detail_story_model.dart';

import '../data/api/api_service.dart';
import '../common/enum/result_state.dart';

class StoryDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;

  StoryDetailProvider({required this.apiService, required this.id}) {
    _getStoryDetail(id: id);
  }

  ResultState? _state;
  ResultState? get state => _state;

  String _message = '';
  String get message => _message;

  late DetailStoryModel _result;
  DetailStoryModel? get result => _result;

  Future<dynamic> _getStoryDetail({required String id}) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await apiService.detailStory(id: id);
      if (result.story.toString().isNotEmpty) {
        _state = ResultState.hasData;
        _result = result;
        _message = 'Detail Story Success !!!';
      } else {
        _state = ResultState.noData;
        _message = 'Detail Story Failed !!!';
      }
    } catch (e) {
      _state = ResultState.error;
      return _message = "$e";
    } finally {
      notifyListeners();
    }
  }
}
