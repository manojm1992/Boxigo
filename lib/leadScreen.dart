import 'package:flutter/material.dart';
import 'apiService.dart';

import 'model.dart';
import 'newScreen.dart';  // Contains fetchLeads()

class LeadScreen extends StatefulWidget {
  @override
  _LeadsScreenState createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
          Image.asset('asset/c.png',width: 20,height: 20,),
            SizedBox(width: 10),
            Text('Leads', style: TextStyle(fontWeight: FontWeight.bold)),
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
            Tab(text: 'All'),
            Tab(text: 'New'),
            Tab(text: 'Follow Up'),
            Tab(text: 'Booked'),
          ],
          indicatorColor: Colors.red,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: Text('All Leads')),
          Center(child: NewScreen()),
          Center(child: Text('Follow Up')),
          Center(child: Text('Booked Leads')),
        ],
      ),
    );
  }
}


