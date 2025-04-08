class BaseResponse {
  final bool error;
  final String message;

  BaseResponse({
    required this.error,
    required this.message,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      error: json["error"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "message": message,
    };
  }
}
