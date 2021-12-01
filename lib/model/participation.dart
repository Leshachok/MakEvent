class Participation{
  String event_id = "";
  String user_id = "";
  int status = 0;

  Participation(this.event_id, this.user_id, this.status);

  Map toJson() => {
    'event_id': event_id,
    'user_id': user_id,
    'status': status,
  };

}