import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:admin/users.dart';
import 'package:admin/memberships_applicants.dart';
import 'package:admin/membership_category.dart'; // Import the new page

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedSection =
      'Home'; // Keeps track of the selected sidebar section

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: Colors.red,
            child: Column(
              children: [
                // Sidebar Header
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.red,
                  child: const Center(
                    child: Text(
                      'Admin Dashboard',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Sidebar Menu Items
                _buildSidebarItem(Icons.home, 'Home', () {
                  setState(() {
                    _selectedSection = 'Home';
                  });
                }),
                _buildSidebarItem(Icons.group, 'Users', () {
                  setState(() {
                    _selectedSection = 'Users';
                  });
                }),
                _buildSidebarItem(Icons.person_add, 'Membership Applicants',
                    () {
                  setState(() {
                    _selectedSection = 'Membership Applicants';
                  });
                }),
                _buildSidebarItem(Icons.category, 'Membership Category', () {
                  setState(() {
                    _selectedSection = 'Membership Category';
                  });
                }),
                const Spacer(),
                // Logo and Message at the bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/logo1.png', // Replace with your logo asset path
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Dugtong Buhay,Together We Will Save Lives',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildMainContent() {
    switch (_selectedSection) {
      case 'Home':
        return _buildHomeContent();
      case 'Users':
        return const UsersPage();
      case 'Membership Applicants':
        return const MembershipsApplicantsPage(
          membershipTiers: [],
        );
      case 'Membership Category':
        return const MembershipCategoryPage(); // Navigate to MembershipCategoryPage
      default:
        return const Center(child: Text('Section not found.'));
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Top Navigation Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 60,
            color: Colors.grey.shade200,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome, Admin!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Metrics Row
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetricCard('Active Users', 'users'),
                _buildMetricCard(
                    'Membership Applicants', 'membershipApplicants'),
              ],
            ),
          ),
          // Bar Chart
          Padding(
            padding: const EdgeInsets.all(20),
            child: _buildBarChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String collection) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, snapshot) {
        int count = 0;

        if (snapshot.hasData) {
          count = snapshot.data!.docs
              .where((doc) =>
                  doc.data() is Map<String, dynamic> &&
                  (doc['email']?.toString().isNotEmpty ?? false))
              .length;
        }

        return Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBarChart() {
    return StreamBuilder<List<QuerySnapshot>>(
      stream: Rx.zip(
        [
          FirebaseFirestore.instance.collection('users').snapshots(),
          FirebaseFirestore.instance
              .collection('membershipApplicants')
              .snapshots(),
        ],
        (List<QuerySnapshot> results) => results,
      ).asBroadcastStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Extract data from the streams
        final userSnapshot = snapshot.data![0];
        final applicantSnapshot = snapshot.data![1];

        // Count valid users and applicants
        final activeUsers = userSnapshot.docs
            .where((doc) =>
                doc.data() is Map<String, dynamic> &&
                (doc['email']?.toString().isNotEmpty ?? false))
            .length;
        final membershipApplicants = applicantSnapshot.docs
            .where((doc) =>
                doc.data() is Map<String, dynamic> &&
                (doc['email']?.toString().isNotEmpty ?? false))
            .length;

        // Build the BarChart widget
        return SizedBox(
          width: 800,
          height: 500,
          child: BarChart(
            BarChartData(
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      switch (value.toInt()) {
                        case 0:
                          return const Text('Active Users');
                        case 1:
                          return const Text('Applicants');
                        default:
                          return const Text('');
                      }
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              borderData: FlBorderData(show: true),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: activeUsers.toDouble(),
                      color: Colors.blue,
                      width: 15,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: membershipApplicants.toDouble(),
                      color: Colors.green,
                      width: 15,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                  showingTooltipIndicators: [0],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
