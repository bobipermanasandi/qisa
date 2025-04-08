import 'story.dart';

class DetailStoryModel {
  final bool error;
  final String message;
  final Story story;

  DetailStoryModel({
    required this.error,
    required this.message,
    required this.story,
  });

  factory DetailStoryModel.fromJson(Map<String, dynamic> json) {
    return DetailStoryModel(
      error: json["error"],
      message: json["message"],
      story: Story.fromJson(json['story']),
    );
  }

  Map<String, dynamic> toJson() {
    return {"error": error, "message": message, "story": story.toJson()};
  }
}
