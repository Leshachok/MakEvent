
import 'dart:ffi';

class Event{

  String _id = "";
  String title = "";
  String description = "";
  String date = "";
  String location = "";
  double latitude = 0;
  double longitude = 0;

  Event(this.title, this.description, this.date, this.location, this.latitude, this.longitude);

  Event.get(this._id, this.title, this.description, this.date, this.location, this.latitude, this.longitude);

  Event.create();
  
  String getId() => _id;

  Map toJson() => {
    'title': title,
    'description': description,
    'date': date,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory Event.fromJson(Map<String, dynamic> json) => Event.get(
      json["_id"],
      json["title"],
      json["description"],
      json["date"],
      json["location"],
      json["latitude"],
      json["longitude"]
  );

}
