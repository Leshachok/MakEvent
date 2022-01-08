import 'package:meeting/data/user.dart';

class Participant {
  int status = 0;
  late User user;

  Participant(this.status, this.user);

  factory Participant.fromJson(dynamic json){
    return Participant(json['status'] as int, User.fromJsonAsParticipiant(json['user']));
  }

}