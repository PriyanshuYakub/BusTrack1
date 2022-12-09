import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bus_tracker/pages/mainpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Objects/bus.dart';
import '../Objects/storage.dart';

class MapWidget extends StatefulWidget {

  MapWidget({Key? key}):super(key: key);

  @override
  State<MapWidget> createState() => MapWidgetState();


  
}



class MapWidgetState extends State<MapWidget> {
  

  
  Location location = new Location();
  // DocumentSnapshot snap;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  var _locationData = null;
  double Vehicle_lon = 0;
  double Vehicle_lat = 0;
  bool showMarkers = true;

  @override
  void initState() {
    super.initState();

    eneableservices();
    location.onLocationChanged.listen((LocationData currentLocation) {
      if(!showMarkers){
        
      updateRDB(currentLocation.longitude, currentLocation.latitude);
      log("Service enabled");

      }
      _firebaselocget();
});

  }

  updateRDB(lon, lat) async {
    
     await FirebaseFirestore.instance.collection("Vehicles").doc('tv5KocyXppBxmlkuMPSx').update({'location':{"lon":lon,"lat":lat}});
    

  }

  void markerSet(bool val){
    setState(() {
      showMarkers = val;
    });
  }
  
  eneableservices() async {
    _serviceEnabled = await location.serviceEnabled();
if (!_serviceEnabled) {
  _serviceEnabled = await location.requestService();
  if (!_serviceEnabled) {
    return;
  }
}



_permissionGranted = await location.hasPermission();
if (_permissionGranted == PermissionStatus.denied) {
  _permissionGranted = await location.requestPermission();
  if (_permissionGranted != PermissionStatus.granted) {
    return;
  }
}
location.getLocation().then((value) {setState(() {
  _locationData = value;
});});
  }

    late GoogleMapController _controller;

  onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _controller.setMapStyle(value);
  }


_firebaselocget() async {
  
  final db =  FirebaseFirestore.instance.collection("Vehicles").doc('tv5KocyXppBxmlkuMPSx').get().then((DocumentSnapshot doc){
    var data = doc.data() as Map<String, dynamic>;
    Map<String, dynamic> location= data['location'];
    log(location['lon'].toString());
    setState(() {
      Vehicle_lon = location['lon'];
      Vehicle_lat = location['lat'];
    });
  });
}

Set<Marker> _createMarker()  {
    
      return {Marker(
      markerId: MarkerId("Vehicle"),
      position: LatLng(Vehicle_lat, Vehicle_lon),
    ),};
    
    
}

  @override
  Widget build(BuildContext context) {
    final LatLng _kMapCenter = LatLng(16.4952391,80.498479);
      

final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);
      if(_locationData != null){
        return  GoogleMap(
        initialCameraPosition: _kInitialPosition,
        onMapCreated: onMapCreated,
  myLocationEnabled: true,
      onLongPress: (argument) => setState(() {
        print("obi wan : hello there!");
        // print(widget.beacon);
        updateRDB(11111, 111111);
        
      }),
      markers:showMarkers && Vehicle_lat!=0 ?  _createMarker():{},
zoomControlsEnabled: false,
myLocationButtonEnabled: false,
      );
      } else {
        return Center(child: LoadingAnimationWidget.fallingDot(color: Color.fromARGB(255, 29, 17, 70), size: 30));
      }
  }
}