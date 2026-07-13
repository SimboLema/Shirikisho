import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/services/region_service.dart';
import 'package:shirikisho/utils/WAColors.dart';

class HakikiKituoScreen extends StatefulWidget {
  @override
  _HakikiKituoScreenState createState() => _HakikiKituoScreenState();
}

class _HakikiKituoScreenState extends State<HakikiKituoScreen> {
  final _storage = const FlutterSecureStorage();

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  int? parkingId;
  double? latitude;
  double? longitude;
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounce;
  bool isUploading = false;

  bool _loadingState = false;

  String _errorText = '';

  // Search API call
  Future<void> _searchApi(String query) async {
    const storage = FlutterSecureStorage();

    var token = await storage.read(key: 'token');

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
          Uri.parse(
              'https://mfumo.shirikisho.co.tz/api/search-parking?search=$query'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token}'
          });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          setState(() {
            _searchResults = jsonResponse['data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _searchResults = [];
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  // Fill form when "Add" is clicked
  void _fillForm(Map<String, dynamic> parking) {
    setState(() {
      _nameController.text = parking['name'] ?? '';
      _regionController.text = parking['region'] ?? '';
      _districtController.text = parking['district'] ?? '';
      _wardController.text = parking['ward'] ?? '';
      _capacityController.text = parking['members_capacity'].toString();
      parkingId = parking['id'];
      _searchController.clear(); // Clear search field
      _searchResults = []; // Hide dropdown
    });
  }

  @override
  void initState() {
    super.initState();

    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WAPrimaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Fomu ya Uhakiki wa Kituo',
          textScaler: TextScaler.noScaling,
          style: boldTextStyle(
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Tafuta kituo',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: WAPrimaryColor, width: 2),
                  ),
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) _debounce?.cancel();
                  _debounce = Timer(Duration(milliseconds: 300), () {
                    _searchApi(value);
                  });
                },
              ),
              SizedBox(height: 10),

              // Dropdown Results
              if (_isLoading)
                Center(
                    child: CircularProgressIndicator(
                  color: WAPrimaryColor,
                ))
              else if (_searchResults.isNotEmpty)
                Container(
                  constraints: BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final parking = _searchResults[index];
                      return InkWell(
                        onTap: () => _fillForm(parking),
                        child: ListTile(
                          title: Text(parking['name'] ?? 'No Name'),
                          subtitle: Text(
                              '${parking['region'] ?? ''}, ${parking['district'] ?? ''}'),
                              trailing: ElevatedButton(
                            onPressed: () => _fillForm(parking),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: WAPrimaryColor,
                              foregroundColor: Colors.white,
                              minimumSize: Size(80, 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: Text(
                              'Chagua',
                              style: boldTextStyle(size: 14, color: Colors.white),
                            ),
                          ),
                          
                          // trailing: IconButton(
                          //   icon: Icon(Icons.add),
                          //   onPressed: () => _fillForm(parking),
                          // ),
                        ),
                      );
                    },
                  ),
                ),

              SizedBox(height: 20),

              // Form Below
              Text(
                'Taarifa za Kituo',
                style: boldTextStyle(size: 20),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _regionController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Mkoa',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: WAPrimaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _districtController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Wilaya',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: WAPrimaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _wardController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Kata',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: WAPrimaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Jina la Kituo',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: WAPrimaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),

              10.height,
              ElevatedButton(
                // onPressed: () async {
                //   var res = await saveKituo(dropdownWard!.id,
                //       kituoController.text, latitude, longitude);
                // },
                onPressed: _loadingState
                    ? null
                    : () {
                        setState(() {
                          _loadingState = true;
                        });

                        sendForm();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: WAPrimaryColor,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: _loadingState
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Hakiki Kituo',
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(size: 14, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> sendForm() async {
    await getCurrentLocation();
    // print("Location fetched succesfully");
    if (latitude == null ||
        longitude == null ||
        latitude == 0 ||
        longitude == 0) {
      setState(() {
        _errorText =
            'Taarifa za eneo lako hazikamatwa hivyo huwezi kuhakiki kituo, tafadhali wezesha huduma ya GPS katika simu na application yako na kisha jaribu tena.';
        _loadingState = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorText)),
      );
      return 0;
    }
    var res = await updateKituo(
        parkingId, parkingId, _nameController.text, latitude, longitude);
    // var res = {};
    // print("response $res");

    if (res['status'] == "success") {
      toast(res['message'],
          bgColor: Colors.green,
          textColor: Colors.white,
          length: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
      setState(() {
        _errorText = '';
        _loadingState = false;
      });
      Navigator.pop(context);
      return 1;
    } else {
      setState(() {
        _errorText = '${res['message']}';
        _loadingState = false;
      });
      return 0;
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      toast("Huduma ya Location imezimwa. Tafadhali washa GPS.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        toast("Ruhusa ya Location imekataliwa.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // toast(
      //     "Ruhusa ya Location imezuiliwa milele. Tafadhali washa kwenye settings.");
      await Geolocator.openAppSettings(); // Opens the location settings
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });

    @override
    void dispose() {
      _searchController.dispose();
      _nameController.dispose();
      _regionController.dispose();
      _districtController.dispose();
      _capacityController.dispose();
      _debounce?.cancel();
      super.dispose();
    }
  }
}
