class Story {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double? lat;
  final double? lon;

  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      photoUrl: json["photoUrl"],
      createdAt: DateTime.parse(json["createdAt"]),
      lat: json['lat'],
      lon: json['lon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "photoUrl": photoUrl,
      "createdAt": createdAt.toIso8601String(),
      "lat": lat,
      "lon": lon,
    };
  }
}
