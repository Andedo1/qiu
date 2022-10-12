import 'dart:async';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qiu/models/auto_complete_result.dart';
import 'package:qiu/new_order.dart';
import 'package:qiu/providers/search_places.dart';
import 'package:qiu/services/map_services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Completer<GoogleMapController>_controller = Completer();

  //Debounce to throttle the async calls to search places API
  Timer? _debounce;

  //Toggle UIs on tap
  bool searchToggle = false;
  bool radiusSlider = false;
  bool cardTapped = false;
  bool pressedNear = false;
  bool getDirections = false;

  // Set markers
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();

  int markerIdCounter = 1;
  int polylineIdCounter = 1;

  //Text Editing Controller
  TextEditingController searchController = TextEditingController();
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  //Initial camera position
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  // Set the marker points here
  void _setMarker(point){
    var counter = markerIdCounter++;
    final Marker marker = Marker(markerId: MarkerId('marker_$counter'),
      position: point,
      onTap: () {},
      icon: BitmapDescriptor.defaultMarker
    );

    setState(() {
      _markers.add(marker);
    });

  }
  // Set the Polyline points here
  void _setPolylines(List<PointLatLng> points){
    final String polylineIdVal = 'polyline_$polylineIdCounter';
    polylineIdCounter++;
    _polylines.add(Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.red,
        points: points.map((e) => LatLng(e.latitude, e.longitude)).toList()
    ));
  }

  @override
  Widget build(BuildContext context) {

    // Consuming providers
    final allSearchResults = ref.watch(placeResultsProvider);
    final searchFlag = ref.watch(searchToggleProvider);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:  [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the application
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: MaterialButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                color: Colors.deepOrangeAccent,
                child: const Text('Sign Out'),
              ),
            ),

          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*1,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    markers: _markers,
                    polylines: _polylines,
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
                  top: 20,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 30, 15.0, 5.0),
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
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                border: InputBorder.none,
                                hintText: 'Search',
                                suffixIcon: IconButton(onPressed: (){
                                  setState(() {
                                    searchToggle = false;
                                    searchController.text = "";
                                    _markers = {};
                                    _polylines = {};
                                    if (searchFlag.searchToggle){
                                      searchFlag.toggleSearch();
                                    }
                                  });
                                },
                                  icon: const Icon(Icons.close),
                                ),
                                prefixIcon: IconButton(
                                  onPressed: (){
                                    // Show Drawer on clicking menu.
                                  },
                                  icon: const Icon(Icons.menu),
                                )
                            ),
                            onChanged: (value){
                              if(_debounce?.isActive ?? false) {
                                _debounce?.cancel();
                              }
                              _debounce = Timer(const Duration(milliseconds: 700), () async {
                                if (value.length > 2) {
                                  if(!searchFlag.searchToggle){
                                    searchFlag.toggleSearch();
                                    _markers = {};
                                  }
                                  List<AutoCompleteResult> searchPlaces = await MapServices().searchPlaces(value);

                                  allSearchResults.setResults(searchPlaces);
                                } else{
                                  List<AutoCompleteResult> emptyList = [];
                                  allSearchResults.setResults(emptyList);
                                }
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ) : Container(),
                searchFlag.searchToggle ?
                allSearchResults.allReturnedResults.length != 0 ?
                Positioned(
                  top: 105,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width*0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.white.withOpacity(0.7),
                      ),
                      child: ListView(
                        children: [
                          ...allSearchResults.allReturnedResults.map((e) => buildListItem(e, searchFlag)),
                        ],
                      ),
                    ),
                  ),
                ): Positioned(
                  top: 105,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.white.withOpacity(0.8),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            const Text('No results to display'),
                            const SizedBox(height: 15.0,),
                            Container(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () {
                                  searchFlag.toggleSearch();
                                },
                                child: const Center(
                                  child: Text(
                                    'Close this',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'WorkSans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ) : Container(),
                // Directions search field
                getDirections ?
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 5.0),
                    child: Column(
                      children: [
                        Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: _originController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                              border: InputBorder.none,
                              hintText: 'origin',
                            ),
                          ),
                        ),
                        const SizedBox(height: 5.0,),
                        Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: _destinationController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                              border: InputBorder.none,
                              hintText: 'destination',
                              suffixIcon: Container(
                                width: 96,
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async{
                                        var directions = await MapServices().getDirections(
                                            _originController.text,
                                            _destinationController.text
                                        );
                                        _markers = {};
                                        _polylines = {};
                                        gotoPlace(
                                            directions['start_location']['lat'],
                                            directions['start_location']['lng'],
                                            directions['end_location']['lat'],
                                            directions['end_location']['lng'],
                                            directions['bounds_ne'],
                                            directions['bounds_sw']
                                        );
                                        _setPolylines(directions['polyline_decoded']);
                                      },
                                      icon: Icon(Icons.search),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          getDirections = false;
                                          _originController.text = "";
                                          _destinationController.text = "";
                                          _polylines = {};
                                          _markers = {};
                                        });
                                      },
                                      icon: Icon(Icons.close),
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ): Container(),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: SlidingUpPanel(
                    minHeight: MediaQuery.of(context).size.height*0.21,
                    maxHeight: MediaQuery.of(context).size.height*0.4,
                    backdropEnabled: true,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(22),
                      topLeft: Radius.circular(22),
                    ),
                    panel: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
                            child: Container(
                              height: 5,
                              width: MediaQuery.of(context).size.width*0.2,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(12)
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  'Make a new order',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.blue,
                            thickness: 1,
                            indent: 25,
                            endIndent: 25,
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    height: 65,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(16)
                                    ),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.water_drop_outlined,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          Text(
                                            'New',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ]
                                    ),
                                  ),
                                  onTap: (){
                                    showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(22)
                                      ),
                                      context: context,
                                      builder: (context){
                                        return const New();
                                      },
                                    );
                                  },
                                ),
                                GestureDetector(
                                  child: Container(
                                    height: 65,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.orangeAccent,
                                        borderRadius: BorderRadius.circular(16)
                                    ),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.water_drop,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          Text(
                                            'Group',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ]
                                    ),
                                  ),
                                  onTap: () {
                                    showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(22)
                                      ),
                                      context: context, 
                                      builder: (context) {
                                        return const New();
                                      },
                                    );
                                  },
                                ),
                                GestureDetector(
                                  child: Container(
                                      height: 65,
                                      width: 90,
                                      decoration: BoxDecoration(
                                          color: Colors.lightBlueAccent,
                                          borderRadius: BorderRadius.circular(16)
                                      ),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.watch_later_outlined,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                            Text(
                                              'Schedule',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ]
                                      )
                                  ),
                                  onTap: () {
                                    showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      context: context,
                                      builder: (context) {
                                      return const New();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),

          ],
        ),
      ),
      floatingActionButton: FabCircularMenu(
        alignment: Alignment.centerRight,
        fabColor: Colors.lightBlueAccent,
        ringDiameter: 170,
        ringColor: Colors.white,
        fabOpenColor: Colors.red,
        ringWidth: 40,
        fabSize: 40,
        children: [
          IconButton(
            onPressed: (){
              setState(() {

              });
            },
            icon: const Icon(Icons.add_location_alt_outlined),
          ),
          IconButton(
            onPressed: (){
              setState(() {
                searchToggle = false;
                radiusSlider = false;
                getDirections = true;
                pressedNear = false;
                cardTapped = false;
              });
            },
            icon: const Icon(Icons.navigation),
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
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
  // Move the camera position to the clicked search results.
  Future<void> gotoSearchedPlace(double lat, double lng) async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom:12)));
    
    _setMarker(LatLng(lat, lng));
  }

  gotoPlace(double lat, double lng, double endLat,
      double endLng, Map<String, dynamic> boundsNe,
      Map<String, dynamic> boundsSw)
  async{
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng'])
        ), 25)
    );

    _setMarker(LatLng(lat, lng));
    _setMarker(LatLng(endLat, endLng));
  }

  // List of autocomplete search results
  Widget buildListItem(AutoCompleteResult placeItem, searchFlag){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () async {
          var place = await MapServices().getPlace(placeItem.placeId);
          gotoSearchedPlace(place['geometry']['location']['lat'], place['geometry']['location']['lng']);
          searchFlag.toggleSearch();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.green, size: 25,),
            const SizedBox(width: 4.0,),
            Container(
              height: 40.0,
              width: MediaQuery.of(context).size.width*0.6,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  placeItem.description ?? ''
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
