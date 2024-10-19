import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ViewDetails/viewDetails.dart';
import 'model.dart';

class NewScreen extends StatefulWidget {
  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  Future<List<Move>>? _moveDetails;

  @override
  void initState() {
    super.initState();
    _moveDetails = fetchMoveDetails();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Move>>(
            future: _moveDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                // Now you can use the fetched Move data to populate your UI
                final moves = snapshot.data!;
                return ListView.builder(
                  itemCount: moves.length,
                    itemBuilder: (context, index){
                    final move = moves[index];
                    return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date and Time
                          Row(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    move.movingOn,
                                    style: TextStyle(fontSize: 10, color: Colors.red),
                                  ),

                                ],
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      move.movingFrom,
                                      style: TextStyle(fontSize: 16, color: Colors.grey),
                                    ),
                                    Text(
                                      move.movingTo,
                                      style: TextStyle(fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                move.estimateId,
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          // Icons and Details (BHK, Items, Boxes, Distance)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              _buildInfoColumn(Icons.home, move.propertySize),
                              SizedBox(width: 50,),
                              _buildInfoColumn(Icons.location_on, '${move.distance} '),
                            ],
                          ),
                          SizedBox(height: 30),

                          // View Details and Submit Quote Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildButton('View Details'),
                              _buildButton('Submit Quote'),
                            ],
                          ),
                          Divider(thickness: 1,color: Colors.grey[500],),
                        ],

                      ),
                    );
                    },
                );

              } else {
                return Center(child: Text('No data available'));
              }
            },
          ),
        ),
      ),
    );
  }

  // Helper widget to create info column
  Widget _buildInfoColumn(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.red),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  // Helper widget to create a button
  Widget _buildButton(String label) {
    return
     ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewDetailsScreen()));
      },
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}
Future<List<Move>> fetchMoveDetails() async {
  final response = await http.get(Uri.parse('http://test.api.boxigo.in/sample-data/'));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);

    if (jsonData.containsKey('Customer_Estimate_Flow')) {
      var customerEstimateFlow = jsonData['Customer_Estimate_Flow'];

      if (customerEstimateFlow is List && customerEstimateFlow.isNotEmpty) {
        return customerEstimateFlow.map((moveData) => Move.fromJson(moveData)).toList();
      } else {
        throw Exception('No items in the Customer_Estimate_Flow array');
      }
    } else {
      throw Exception("Response format invalid: 'Customer_Estimate_Flow' field is missing.");
    }
  } else {
    throw Exception('Failed to load move details. Status code: ${response.statusCode}');
  }
}






