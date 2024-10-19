import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class FloorInfoPage extends StatefulWidget {
  @override
  _FloorInfoPageState createState() => _FloorInfoPageState();
}

class _FloorInfoPageState extends State<FloorInfoPage> {
  Map<String, dynamic>? houseData;

  @override
  void initState() {
    super.initState();
    fetchHouseData();
  }

  Future<void> fetchHouseData() async {
    try {
      final response = await http.get(Uri.parse('http://test.api.boxigo.in/sample-data/'));
      if (response.statusCode == 200) {
        print('Response data: ${response.body}'); // Debugging - print the API response
        setState(() {
          houseData = json.decode(response.body);
          print('Parsed house data: $houseData'); // Debugging - print the parsed data
        });
      } else {
        throw Exception('Failed to load house data');
      }
    } catch (error) {
      print('Error fetching house data: $error'); // Debugging - print any errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: houseData == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          // Check if 'existingHouse' and 'newHouse' exist in the response
          if (houseData!['existingHouse'] != null)
            buildHouseDetails('Existing House Details', houseData!['existingHouse']),
          SizedBox(height: 20),
          if (houseData!['newHouse'] != null)
            buildHouseDetails('New House Details', houseData!['newHouse']),
        ],
      ),
    );
  }

  Widget buildHouseDetails(String title, Map<String, dynamic> data) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            buildRow('Floor No.', data['floorNo'].toString()),
            buildRow('Elevator Available', data['elevatorAvailable'] ? 'Yes' : 'No'),
            buildRow('Packing Required', data['packingRequired'] ? 'Yes' : 'No'),
            buildRow('Distance from Door to Truck', '${data['distanceFromDoorToTruck']} mtrs'),
            buildRow('Additional Information', data['additionalInfo'] ?? 'None'),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
