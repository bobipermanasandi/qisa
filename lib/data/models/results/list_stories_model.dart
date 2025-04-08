import 'story.dart';

class ListStoriesModel {
  final bool error;
  final String message;
  final List<Story> listStory;

  ListStoriesModel({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory ListStoriesModel.fromJson(Map<String, dynamic> json) {
    return ListStoriesModel(
      error: json["error"],
      message: json["message"],
      listStory:
          (json['listStory'] != null)
              ? List<Story>.from(
                json["listStory"].map((x) => Story.fromJson(x)),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "message": message,
      "listStory": List<dynamic>.from(listStory.map((x) => x.toJson())),
    };
  }
}
