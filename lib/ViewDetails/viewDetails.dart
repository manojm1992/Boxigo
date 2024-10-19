import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:untitled/ViewDetails/viewModel.dart';

import '../floor_info.dart';

// Model for Items and related classes

// ViewDetailsScreen UI with TabBar
class ViewDetailsScreen extends StatefulWidget {
  @override
  _ViewDetailsScreenState createState() => _ViewDetailsScreenState();
}

class _ViewDetailsScreenState extends State<ViewDetailsScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool isLoading = false;
  Items? itemsData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3 tabs
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> fetchSampleData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://test.api.boxigo.in/sample-data/'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Debug: Print the entire response to inspect its structure
        print('API response: $jsonData');

        // Check if 'Customer_Estimate_Flow' exists and has valid data
        if (jsonData.containsKey('Customer_Estimate_Flow')) {
          var customerEstimateFlow = jsonData['Customer_Estimate_Flow'];

          if (customerEstimateFlow is List && customerEstimateFlow.isNotEmpty) {
            var flowData = customerEstimateFlow[0];

            // Debug: Print flowData to verify its structure
            print('Customer_Estimate_Flow data: $flowData');

            // Now check if 'items' is present
            if (flowData.containsKey('items')) {
              var itemsData = flowData['items'];

              // Check if items contains 'inventory'
              if (itemsData.containsKey('inventory')) {
                var inventoryData = itemsData['inventory'];
                print('Inventory data: $inventoryData');

                // Check if inventoryData is a list and not empty
                if (inventoryData is List && inventoryData.isNotEmpty) {
                  // Assuming Items model can handle 'inventory' data
                  this.itemsData = Items.fromJson(flowData);

                  // Debug: Print parsed inventory data
                  print('Parsed inventoryData: ${this.itemsData?.inventory}');
                } else {
                  throw Exception('Inventory field exists but is empty');
                }

                setState(() {
                  isLoading = false;
                });
              } else {
                throw Exception('Inventory field is missing in the items');
              }
            } else {
              throw Exception('Items field is missing in the API response');
            }
          } else {
            throw Exception('No items in the Customer_Estimate_Flow array');
          }
        } else {
          throw Exception("Response format invalid: 'Customer_Estimate_Flow' field is missing.");
        }
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching data: $e'))
      );
    }
  }








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [

            SizedBox(width: 10),
            Text('New Leads', style: TextStyle(fontWeight: FontWeight.bold)),
            Spacer(),
            IconButton(
              icon: const Stack(
                children: [
                  Icon(Icons.notifications),
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text('99', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                // Handle notification press
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Handle search press
              },
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Items'),
            Tab(text: 'Floor Info'),
            Tab(text: 'Send Quote'),
          ],
          indicatorColor: Colors.red,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildItemsTab(),         // First tab: Items
          _buildFloorInfoTab(),     // Second tab: Floor Info
          _buildSendQuoteTab(),     // Third tab: Send Quote
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchSampleData,
        child: Icon(Icons.refresh),
      ),
    );
  }

  // Build the Items tab content
  Widget _buildItemsTab() {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildCategorySection("Living Room", itemsData?.inventory ?? []),
        _buildCategorySection("Bedroom", itemsData?.inventory ?? []),
        _buildCategorySection("Custom Items", itemsData?.customItems ?? []),
      ],
    );
  }

  // Build the Floor Info tab content
  Widget _buildFloorInfoTab() {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FloorInfoPage()),
        );

      },

    );
  }

  // Build the Send Quote tab content
  Widget _buildSendQuoteTab() {
    return Center(child: Text('Send Quote Section'));
  }

  Widget _buildCategorySection(String title, List<Item> items) {
    return ExpansionTile(
      title: Text(title),
      children: items.isNotEmpty
          ? items.map((item) => _buildItemTile(item)).toList()
          : [Text("No items available")],
    );
  }

  Widget _buildItemTile(Item item) {
    return ListTile(
      leading: Icon(Icons.check_box_outline_blank),
      title: Text(item.name),
      subtitle: Text(item.meta.selectType),
      trailing: Text(item.qty.toString()),
    );
  }
}
