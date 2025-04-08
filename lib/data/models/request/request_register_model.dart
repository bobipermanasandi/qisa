class RequestRegisterModel {
  final String name;
  final String email;
  final String password;

  RequestRegisterModel({
    required this.name,
    required this.email,
    required this.password,
  });

  factory RequestRegisterModel.fromJson(Map<String, dynamic> json) {
    return RequestRegisterModel(
      name: json["name"],
      email: json["email"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "email": email, "password": password};
  }
}
