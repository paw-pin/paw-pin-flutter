import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final bool isOwner;

  const MapScreen({super.key, this.isOwner = false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  final LatLng _center = const LatLng(40.7128, -74.0060);

  final List<Map<String, dynamic>> allDogs = [
    {
      'name': 'Luna',
      'location': LatLng(40.7128, -74.0060),
      'info': 'Pickup in 10 min\nOwner: John Doe',
    },
    {
      'name': 'Rocky',
      'location': LatLng(40.7135, -74.0055),
      'info': 'Pickup in 15 min\nOwner: John Doe',
    },
    {
      'name': 'Bella',
      'location': LatLng(40.7142, -74.0048),
      'info': 'Pickup in 20 min\nOwner: John Doe',
    },
  ];

  final Set<Marker> _walkerMarkers = {};
  List<LatLng> _route = [];
  final List<String> _selectedDogs = [];

  bool routeGenerated = false;
  bool walkStarted = false;

  void _updateMarkersAndRoute() {
    _walkerMarkers.clear();
    _route.clear();
    for (var dog in allDogs) {
      if (_selectedDogs.contains(dog['name'])) {
        _walkerMarkers.add(
          Marker(
            markerId: MarkerId(dog['name']),
            position: dog['location'],
            infoWindow: InfoWindow(
              title: '🐶 ${dog['name']}',
              snippet: dog['info'],
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange,
            ),
          ),
        );
        _route.add(dog['location']);
      }
    }
  }

  void _selectAllDogs() {
    _selectedDogs.clear();
    for (var dog in allDogs) {
      _selectedDogs.add(dog['name']);
    }
    setState(() {
      _updateMarkersAndRoute();
      routeGenerated = false;
      walkStarted = false;
    });
  }

  void _resetWalk() {
    setState(() {
      _selectedDogs.clear();
      _walkerMarkers.clear();
      _route.clear();
      routeGenerated = false;
      walkStarted = false;
    });
  }

  final LatLng _dogLocation = LatLng(40.7128, -74.0060);
  final LatLng _walkerLocation = LatLng(40.7133, -74.0055);
  bool showOwnerInfo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dog Walk Tracker')),
      body: widget.isOwner ? _buildOwnerMap() : _buildWalkerMap(),
    );
  }

  Widget _buildOwnerMap() {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) => _controller = controller,
          initialCameraPosition: CameraPosition(target: _center, zoom: 16),
          myLocationEnabled: true,
          markers: {
            Marker(
              markerId: MarkerId('dog'),
              position: _dogLocation,
              infoWindow: InfoWindow(title: '📍 Dog: Luna (Golden Retriever)'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure,
              ),
            ),
            Marker(
              markerId: MarkerId('walker'),
              position: _walkerLocation,
              infoWindow: InfoWindow(title: '🐾 Walker approaching'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRose,
              ),
              onTap: () => setState(() => showOwnerInfo = true),
            ),
          },
        ),
        Positioned(
          top: 20,
          left: MediaQuery.of(context).size.width / 2 - 50,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.deepPurple, width: 2),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.pets,
                  size: 40,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.purpleAccent],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Pickup in 5 min',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showOwnerInfo)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Walker Info",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text("👤 Alex John - ⭐ 4.9"),
                    const Text("🐶 Walk Type: Solo"),
                    const Text("⏳ Walk Time: 45 min"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => setState(() => showOwnerInfo = false),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWalkerMap() {
    _updateMarkersAndRoute();
    bool hasSelectedDogs = _selectedDogs.isNotEmpty;
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) => _controller = controller,
          initialCameraPosition: CameraPosition(target: _center, zoom: 16),
          myLocationEnabled: true,
          markers: _walkerMarkers,
          polylines: routeGenerated
              ? {
                  Polyline(
                    polylineId: PolylineId('route'),
                    color: Colors.blue,
                    width: 6,
                    points: _route,
                  ),
                }
              : {},
        ),
        Positioned(
          top: 20,
          left: MediaQuery.of(context).size.width / 2 - 50,
          child: Column(
            children: [
              GestureDetector(
                // onPressed: hasSelectedDogs && !routeGenerated
                //     ? () => setState(() => routeGenerated = true)
                //     : null,
                onTap: !hasSelectedDogs && !routeGenerated ? _selectAllDogs : null,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.deepPurple, width: 2),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.pets, size: 40, color: Colors.deepPurple),
                ),
              ),
              SizedBox(height: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.purpleAccent],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Text(
                  'Walk all dogs!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),

                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: null,
                    hint: const Text("Select dogs"),
                    items: allDogs
                        .map(
                          (dog) => DropdownMenuItem(
                            value: dog['name'].toString(),
                            child: Text('🐶 ${dog['name']}'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          if (_selectedDogs.contains(value)) {
                            _selectedDogs.remove(value);
                          } else {
                            _selectedDogs.add(value);
                          }
                          routeGenerated = false;
                          walkStarted = false;
                        });
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Select dogs'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasSelectedDogs
                                ? Colors.deepPurple
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                          ),
                          onPressed: hasSelectedDogs && !routeGenerated
                              ? () => setState(() => routeGenerated = true)
                              : null,
                          child: const Text('Generate Route'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasSelectedDogs && routeGenerated
                                ? walkStarted
                                      ? Colors.red
                                      : Colors.green
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                          ),
                          onPressed: hasSelectedDogs && routeGenerated
                              ? () {
                                  if (!walkStarted) {
                                    setState(() => walkStarted = true);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '🚶 Walk started: ${_selectedDogs.join(", ")}',
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '✅ Walk ended. Distance: ${_route.length * 300}m',
                                        ),
                                      ),
                                    );
                                    _resetWalk();
                                  }
                                }
                              : null,
                          child: Text(walkStarted ? 'End Walk' : 'Start Walk'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
