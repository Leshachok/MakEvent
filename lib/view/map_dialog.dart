import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meeting_app/viewmodel/create_event_view_model.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:collection/collection.dart';

class GoogleMapDialog extends StatefulWidget {


  late CreateEventViewModel model;
  GoogleMapDialog(this.model, {Key? key}) : super(key: key);

  @override
  _GoogleMapDialogState createState() => _GoogleMapDialogState(model);
}

class _GoogleMapDialogState extends State<GoogleMapDialog> {

  late CreateEventViewModel model;
  Set<Marker> markers = Set();

  _GoogleMapDialogState(this.model);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
          target: LatLng(48.835, 31.463),
        zoom: 7
      ),
      markers: markers,
      onTap: onMapTapped,
    );
  }

  void onMapTapped(LatLng latLng){
    geoCode(latLng);
    setState(() {
      markers.add(
          Marker(
              markerId: MarkerId('chosen position'),
            position: latLng
          )
      );
    });
  }

  geoCode(LatLng latLng) async{
    var googleGeocoding = GoogleGeocoding("AIzaSyD4HeEGDDGBismjzrzZgn0dDYcNFGW2d6Q");
    var result = await googleGeocoding.geocoding.getReverse(LatLon(latLng.latitude, latLng.longitude), language: 'uk');
    var components = result!.results!.first.addressComponents!;
    var place = "";
    //TODO
    components.forEachIndexed((index, element) {
      if(index==1) place += element.longName!;
    });
    model.setLocation(place);
    model.latitude = latLng.latitude;
    model.longitude = latLng.longitude;
  }

}
