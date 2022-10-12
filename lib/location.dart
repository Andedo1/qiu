import 'dart:async';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Completer<GoogleMapController>_controller = Completer();

  //Toggle UIs on tap
  bool searchToggle = false;
  bool radiusSlider = false;
  bool cardTapped = false;
  bool pressedNear = false;
  bool getDirections = false;

  //Text Editing Controller
  TextEditingController searchController = TextEditingController();

  //Initial camera position
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.91,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller){
                      _controller.complete(controller);
                    },
                  ),
                ),
                searchToggle ?
                Positioned(
                  left: 0,
                  right: 0,
                  top: 10,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 30, 15.0, 5.0),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                              border: InputBorder.none,
                              hintText: 'Search',
                              suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.close)),
                              prefixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.menu))
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ) : Container()
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FabCircularMenu(
        alignment: Alignment.bottomLeft,
        fabColor: Colors.lightBlueAccent,
        ringDiameter: 240,
        ringColor: Colors.white,
        fabOpenColor: Colors.red,
        ringWidth: 50,
        fabSize: 50,
        children: [
          IconButton(
            onPressed: (){
              setState(() {

              });
            },
            icon: Icon(Icons.navigation),
          ),
          IconButton(
            onPressed: (){
              setState(() {
                searchToggle = true;
                radiusSlider = false;
                getDirections = false;
                pressedNear = false;
                cardTapped = false;
              });
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
