import 'dart:async';

import 'package:bus_tracker/pages/vehicle_register.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:toggle_switch/toggle_switch.dart';

import "../pages/details.dart";
import "../pages/map.dart";
import '../Objects/bus.dart';

const Color selectedColor = Colors.white;
const Color normalColor = Colors.black54;
Color MainColor = Color.fromARGB(255, 29, 20, 110);

const double width = 246.0;
const double height = 44.0;

const double loginAlign = -1;
const double signInAlign = 1;

class MainPage extends StatefulWidget {
  Bus bus;
  MainPage({super.key, required this.bus});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<MapWidgetState> _mKey = GlobalKey();
  late List pages;
  bool isSwitched = false;
  late var pageNo;
   late double xAlign;
  late Color loginColor;
  late Color signInColor;
  Bus bus = new Bus();

    
  

  @override
  void initState() {
    super.initState();

    pageNo = 0; 
    
    pages = [
      MapWidget(key: _mKey,),
      DetailsPage(bus: widget.bus),
    ];
    xAlign = loginAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
  }
  methodInChild() => setState(() {
    print("jlkjlakjsldkj");
  },);
   void toggleSwitch(bool value) {  
    
      _mKey.currentState?.markerSet(!value);
    if(isSwitched == false)  
    {  
      print('Switch Button is ON');  
      setState(() {  
        isSwitched = true;  
      });  
      
    }  
    else  
    { print('Switch Button is OFF');  
      setState(() {  
        isSwitched = false;  
        
      });  
      
      
    }  

  }  
  @override
  Widget build(BuildContext context) {
    
    
   
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return Container(
              margin: EdgeInsets.fromLTRB(15, 8, 0, 0),
              child: SizedBox(
                width: 40,
                height: 40,
                child: FloatingActionButton(child: Icon(Icons.menu_book),onPressed: () => Scaffold.of(context).openDrawer(),backgroundColor: MainColor, 
                ),
              ),
            );
          }
        ),
        backgroundColor: Colors.transparent,
      ),

      body:pages[pageNo], 
      
      bottomNavigationBar: SizedBox(
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: height,
                margin: EdgeInsets.fromLTRB(50, 5, 50, 0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(235, 19, 20, 41),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      alignment: Alignment(xAlign, 0),
                      duration: Duration(milliseconds: 200),
                      child: Container(
                        width: width * 0.5,
                        height: height + 0.5,
                        decoration: BoxDecoration(
                          color: MainColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          xAlign = loginAlign;
                          pageNo = 0;
                        });
                      },
                      child: Align(
                        alignment: Alignment(-1, 0),
                        child: Container(
                          width: width * 0.5,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Text(
                            'Map',
                            style: TextStyle(
                              color: selectedColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if(!isSwitched){
                        setState(() {
                          xAlign = signInAlign;

                          pageNo = 1;
                        });}
                      },
                      child: Align(
                        alignment: Alignment(1, 0),
                        child: Container(
                          width: width * 0.5,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Text(
                            'Details',
                            style: TextStyle(
                              color: selectedColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

   
    
    
    drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 29, 20, 110),
        ),
        child: Container(child: Row(children: [
          Stack(
            children:[ SizedBox(height:50, width: 50
            ,child: Icon(Icons.person)),SizedBox(height:20, child: Icon(Icons.verified_user)),], 
            ),
            Text("Lorem Ipsum", style: TextStyle(color: Colors.white60, fontSize: 30),)
            ],
            ),
            ),
      ),
      ListTile(
        title: const Text('Register Vehicle'),
        onTap: () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => QRFetch()), (route) => false);
          
        },
      ),
      ListTile(
        title: const Text('Share Location'),
        trailing: Switch(  
              onChanged: toggleSwitch,  
              value: isSwitched,  
              activeColor: Colors.blue,  
              activeTrackColor: Colors.yellow,  
              inactiveThumbColor: Colors.redAccent,  
              inactiveTrackColor: Colors.orange,  
            )  ,
      ),
      ListTile(
        title: const Text('Logout'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
    ],
  ),)


    );


  }

}


