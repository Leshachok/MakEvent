class Authorization {
  String email = "";
  String password = "";

  Authorization(this.email, this.password);

  Map toJson() => {
    'email': email,
    'password': password,
  };

}