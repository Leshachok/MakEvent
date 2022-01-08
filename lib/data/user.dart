class User{

  late String image;
  late String name;
  late int status;
  late String _id;

  User(this.image, this.name, this._id);

  User.getUser(this.name, this._id, this.image);

  factory User.fromJsonAsUser(dynamic json){
    json['image'] ??= "";
    return User.getUser(json['name'] as String, json['_id'] as String, json['image'] as String );
  }

  factory User.fromJsonAsParticipiant(dynamic json){
    return User(json['photo'] as String, json['name'] as String, json['_id'] as String);
  }

  String getId() => _id;

}