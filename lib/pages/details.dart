import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../Objects/bus.dart';
import '../Objects/storage.dart';



class DetailsPage extends StatefulWidget {
  Bus bus;

   DetailsPage({super.key,required this.bus});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Bus bus = Bus();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Filecheck();

  }

  Filecheck() async {
    var temp = await FileStorage.readJson();
    if(temp != "null value"){
      print(temp);
      setState(() {
        bus = Bus.fromJson(temp);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return bus.VehicleId != ""?Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            child: Image(image: AssetImage("assets/images/bus_temp.jpg")),
          ),
          Text("Bus id =  " + bus.getVid())
        ],
      ),
    ):Center(child: LoadingAnimationWidget.bouncingBall(color: const Color.fromARGB(255, 16, 20, 53), size: 40));
  }
}