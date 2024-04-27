import 'dart:async';
import 'dart:math';
import 'walk_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Pets/db/cubit/pet_db_cubit.dart';
//TODO: Separate the state.

class CurrentWalkPage extends StatefulWidget {
  @override
  _CurrentWalkPageState createState() => _CurrentWalkPageState();
}

class _CurrentWalkPageState extends State<CurrentWalkPage> {
  GoogleMapController? _googleMapController;
  Location location = Location();
  bool isWalkStarted = false;
  Stopwatch stopwatch = Stopwatch();
  double totalDistance = 0.0;
  LatLng? lastLocation;
  StreamSubscription<LocationData>? _locationSubscription;
  final Set<Marker> _markers = {};
  final List<LatLng> _path = [];

  @override
  void dispose() {
    _googleMapController?.dispose();
    _locationSubscription?.cancel(); // Cancel the subscription
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndSetInitialPosition();
  }

  Future<void> _getCurrentLocationAndSetInitialPosition() async {
    LocationData? locationData = await location.getLocation();
    LatLng userLocation = LatLng(locationData!.latitude!, locationData.longitude!);
    _setInitialCameraPosition(userLocation);
  }

  void _setInitialCameraPosition(LatLng userLocation) {
    _googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: userLocation,
          zoom: 15,
        ),
      ),
    );
    // Add marker for user's location
    _markers.add(
      Marker(
        markerId: const MarkerId('userLocation'),
        position: userLocation,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    setState(() {});
  }

  void startWalk() {
    setState(() {
      isWalkStarted = true;
      stopwatch.reset();
      stopwatch.start();
      _path.clear();
      _locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
        if (lastLocation != null) {
          totalDistance += _calculateDistance(lastLocation!, LatLng(currentLocation.latitude!, currentLocation.longitude!));
        }
        lastLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        // Update marker position
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('userLocation'),
            position: lastLocation!,
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
        // Add current location to the path
        _path.add(lastLocation!);
        setState(() {});
      });
    });
  }

  void stopWalk() {
    setState(() {
      isWalkStarted = false;
      stopwatch.stop();
      if (_locationSubscription != null) {
        _locationSubscription?.cancel(); // Cancel the subscription
      }
      WalkData walkData = WalkData(
        distance: totalDistance,
        duration: stopwatch.elapsed,
        timestamp: DateTime.now(),
        path: List.from(_path), // Create a copy of the path list
      );
      _showSummaryDialog(walkData);
      //Add distance to pet's distance variable
      final selectedPets = context.read<PetDBCubit>().state.selectedPets;
      for (var pet in selectedPets) {
        //Update each pet's distance and walks count via the Cubit
        context.read<PetDBCubit>().updatePetWalkData(pet, walkData.distance);
      }
    });
  }

  void _showSummaryDialog(WalkData walkData) {
    //Retrieve names of selected pets
    final selectedPets = context
        .read<PetDBCubit>()
        .state
        .selectedPets;
    String petNames = "";
    for (var i = 0; i < selectedPets.length; i++) {
      petNames = "$petNames${selectedPets[i].name} and ";
    }
    if (petNames.isNotEmpty) {
      //Trim the trailing "and"
      petNames = petNames.substring(0, petNames.length - 5);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Walk Summary'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Distance: ${walkData.distance.toStringAsFixed(2)} km'),
              Text('Time: ${walkData.duration.inMinutes} minutes'),
              Text('Pets walked: $petNames'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  double _calculateDistance(LatLng start, LatLng end) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((end.latitude - start.latitude) * p) / 2 +
        c(start.latitude * p) * c(end.latitude * p) * (1 - c((end.longitude - start.longitude) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: Image.asset('assets/dogIcon.png'),
        middle: const Text('Hound Chaser'),
        backgroundColor: CupertinoColors.systemBrown,
      ),
      child: Material(
        child: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (controller) => _googleMapController = controller,
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 15,
              ),
              markers: _markers,
              polylines: {
                Polyline(
                  polylineId: const PolylineId('path'),
                  points: _path,
                  color: Colors.blue,
                  width: 3,
                ),
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end, // Aligns children to the end (bottom) of the column
              children: <Widget>[
                Center( // Centers the button horizontally
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CupertinoButton.filled(
                      onPressed: () {
                        if (isWalkStarted) {
                          stopWalk();
                        } else {
                          startWalk();
                        }
                      },
                      child: Text(isWalkStarted ? 'Stop Walk' : 'Start Walk'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}