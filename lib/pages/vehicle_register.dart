import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bus_tracker/pages/mainpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:firebase_core/firebase_core.dart';
//Import firestore database
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Objects/bus.dart';
import '../Objects/storage.dart';


class QRFetch extends StatefulWidget {
  const QRFetch({super.key});

  @override
  State<QRFetch> createState() => _QRFetchState();
}

class _QRFetchState extends State<QRFetch> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MainPage(bus: new Bus())), (route) => false),
          ),
          title: Text("New Page"),
        ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          ),
           ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData)  {
      if(scanData != Null){
        fetchInfo(scanData);

      }
      setState(() {
        result = scanData;
      });
    });
  }

 
  fetchInfo(Barcode scanData) async {
  log("in fetching still fetching");
  var docSnapshot;
  var uid = scanData.code;
  var VehicleId;
  if(uid != null){
    docSnapshot = await FirebaseFirestore.instance.collection("Vehicles").doc('$uid').get();
    if (docSnapshot.exists) {
  Map<String, dynamic>? data = docSnapshot.data();
  VehicleId = data?['Vehicle No']; // <-- The value you want to retrieve. 
  // Call setState if needed.
}
  }

  if(VehicleId != Null){
    log("this might be working!!");
    // var b1 = 
    FileStorage.writeCounter(VehicleId, uid.toString());
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage(bus: new Bus.namedConst( uid.toString(),VehicleId)) ), (route) => false);
    }
}

 @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

