class LoginModel {
  final bool error;
  final String message;
  final LoginResult? loginResult;

  LoginModel({required this.error, required this.message, this.loginResult});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      error: json["error"],
      message: json["message"],
      loginResult:
          json['loginResult'] != null
              ? LoginResult.fromJson(json['loginResult'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "message": message,
      "loginResult": (loginResult != null) ? loginResult!.toJson() : null,
    };
  }
}

class LoginResult {
  final String userId;
  final String name;
  final String token;

  LoginResult({required this.userId, required this.name, required this.token});

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      userId: json["userId"],
      name: json["name"],
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"userId": userId, "name": name, "token": token};
  }
}
