import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:qisa/data/local/preference_helper.dart';

import 'package:qisa/data/models/base_response.dart';
import 'package:qisa/data/models/request/request_add_story_model.dart';
import 'package:qisa/data/models/request/request_login_model.dart';
import 'package:qisa/data/models/request/request_register_model.dart';
import 'package:qisa/data/models/results/detail_story_model.dart';
import 'package:qisa/data/models/results/list_stories_model.dart';
import 'package:qisa/data/models/results/login_model.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  static final Uri _register = Uri.parse('$_baseUrl/register');
  static final Uri _login = Uri.parse('$_baseUrl/login');
  static final Uri _stories = Uri.parse('$_baseUrl/stories');

  Uri _detailStory(String id) => Uri.parse('$_stories/$id');

  static const Duration timeout = Duration(seconds: 7);

  _isResponseSuccess(int statusCode) => (statusCode >= 200 && statusCode < 300);

  Future<BaseResponse> register({required RequestRegisterModel request}) async {
    try {
      final response = await http
          .post(_register, body: request.toJson())
          .timeout(timeout);
      var result = BaseResponse.fromJson(json.decode(response.body));
      if (_isResponseSuccess(response.statusCode)) {
        return result;
      } else {
        throw Exception('(${response.statusCode}) ${result.message}');
      }
    } on TimeoutException catch (_) {
      throw Exception('Request Timeout. Please try again later');
    } on SocketException catch (_) {
      throw Exception('No Internet Connection. Please try again');
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginModel> login({required RequestLoginModel request}) async {
    try {
      final response = await http
          .post(_login, body: request.toJson())
          .timeout(timeout);
      var result = LoginModel.fromJson(json.decode(response.body));
      if (_isResponseSuccess(response.statusCode)) {
        return result;
      } else {
        throw Exception('(${response.statusCode}) ${result.message}');
      }
    } on TimeoutException catch (_) {
      throw Exception('Request Timeout. Please try again later');
    } on SocketException catch (_) {
      throw Exception('No Internet Connection. Please try again');
    } catch (e) {
      rethrow;
    }
  }

  Future<ListStoriesModel> getStories() async {
    try {
      var pref = PreferencesHelper();
      var token = await pref.getToken;

      final response = await http
          .get(_stories, headers: {'Authorization': 'Bearer $token'})
          .timeout(timeout);
      var result = ListStoriesModel.fromJson(json.decode(response.body));
      if (_isResponseSuccess(response.statusCode)) {
        return result;
      } else {
        throw Exception('(${response.statusCode}) ${result.message}');
      }
    } on TimeoutException catch (_) {
      throw Exception('Request Timeout. Please try again later');
    } on SocketException catch (_) {
      throw Exception('No Internet Connection. Please try again');
    } catch (e) {
      rethrow;
    }
  }

  Future<DetailStoryModel> detailStory({required String id}) async {
    try {
      var pref = PreferencesHelper();
      var token = await pref.getToken;

      final response = await http
          .get(_detailStory(id), headers: {'Authorization': 'Bearer $token'})
          .timeout(timeout);
      var result = DetailStoryModel.fromJson(json.decode(response.body));
      if (_isResponseSuccess(response.statusCode)) {
        return result;
      } else {
        throw Exception('(${response.statusCode}) ${result.message}');
      }
    } on TimeoutException catch (_) {
      throw Exception('Request Timeout. Please try again later');
    } on SocketException catch (_) {
      throw Exception('No Internet Connection. Please try again');
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponse> addStory({required RequestAddStoryModel request}) async {
    try {
      var pref = PreferencesHelper();
      var token = await pref.getToken;

      final req = http.MultipartRequest('POST', _stories);
      req.headers['Authorization'] = 'Bearer $token';
      req.fields['description'] = request.description;
      req.files.add(
        http.MultipartFile(
          'photo',
          request.photo.readAsBytes().asStream(),
          request.photo.lengthSync(),
          filename: request.photo.path.split('/').last,
        ),
      );
      if (request.lat != null) {
        req.fields['lat'] = request.lat.toString();
        req.fields['lon'] = request.lon.toString();
      }

      final response = await req.send().timeout(timeout);
      String responseBody = await response.stream.bytesToString();
      var result = BaseResponse.fromJson(json.decode(responseBody));

      if (_isResponseSuccess(response.statusCode)) {
        return result;
      } else {
        throw Exception('(${response.statusCode}) ${result.message}');
      }
    } on TimeoutException catch (_) {
      throw Exception('Request Timeout. Please try again later');
    } on SocketException catch (_) {
      throw Exception('No Internet Connection. Please try again');
    } catch (e) {
      rethrow;
    }
  }
}
