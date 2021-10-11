class User{

  late String image;
  late String name;
  late int status;

  User(this.image, this.name, this.status);

  factory User.fromJson(dynamic json){
    return User(json['image'] as String, json['name'] as String, json['status'] as int);
  }

}