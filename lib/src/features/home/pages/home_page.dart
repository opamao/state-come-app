import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class CommercialDetail {
  final String? nom;
  final String? description;
  final LatLng? coordinates;

  CommercialDetail({
    this.nom,
    this.description,
    this.coordinates,
  });
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _mapController = Completer();
  Position? _currentPosition;
  Marker? _currentPositionMarker;
  BitmapDescriptor? _customIcon;
  LatLng? _startPoint;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  late StreamSubscription<Position>? _positionStream;

  Timer? _timer;

  final List<CommercialDetail> _positions = [
    CommercialDetail(nom: 'Yapi', description: 'Objectif 40/100', coordinates: const LatLng(5.326444, -4.019020)),
    CommercialDetail(nom: 'Theodore', description: 'Objectif 60/100', coordinates: const LatLng(5.370156, -4.086372)),
    CommercialDetail(nom: 'Nguessan', description: 'Objectif 80/100', coordinates: const LatLng(5.372196, -4.089644)),
    CommercialDetail(nom: 'Kouassi', description: 'Objectif 15/100', coordinates: const LatLng(5.371807, -4.088491)),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _getCurrentLocation();
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    if (await Permission.location.request().isGranted) {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _startPoint = LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        _currentPositionMarker = Marker(
          markerId: const MarkerId("current_position"),
          position: _startPoint!,
          icon: _customIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );
        _markers.add(_currentPositionMarker!);
      });

      _positionStream = Geolocator.getPositionStream(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      ).listen((Position position) {
        setState(() {
          _currentPosition = position;
          _currentPositionMarker = Marker(
            markerId: const MarkerId("current_position"),
            position: LatLng(position.latitude, position.longitude),
            icon: _customIcon ??
                BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
          );
          _markers.removeWhere((marker) =>
              marker.markerId == const MarkerId("current_position"));
          _markers.add(_currentPositionMarker!);
        });
        _addMarkers();
      });
    } else {
      // Permission non accordée
    }
  }

  void _addMarkers() {
    for (var position in _positions) {
      _markers.add(Marker(
        markerId: MarkerId(position.nom!),
        position: position.coordinates!,
        infoWindow: InfoWindow(
          title: position.nom,
          snippet: position.description,
        ),
        onTap: () {
          //_showDetails(position);
        },
      ));
    }
  }

  void _showDetails(CommercialDetail position) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(position.nom!),
          content: Text(position.description!),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _currentPosition == null
            ? const Center(child: CircularProgressIndicator())
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                  zoom: 15,
                ),
                mapType: MapType.normal,
                markers: _markers,
                polylines: _polyLines,
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
              ),
      ),
    );
  }
}
