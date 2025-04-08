import 'dart:io';

class RequestAddStoryModel {
  final File photo;
  final String description;
  final double? lat;
  final double? lon;

  RequestAddStoryModel({
    required this.photo,
    required this.description,
    this.lat,
    this.lon,
  });
}
