import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redcross_mp/user/profile.dart';
import 'package:redcross_mp/user/membership_card.dart';
import 'package:redcross_mp/user/registration_page.dart';
import 'package:redcross_mp/user/notification_page.dart'; // Import the external notification page

class DashboardPage extends StatefulWidget {
  final String email;

  const DashboardPage({Key? key, required this.email}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Initialize pages with email
    _pages = [
      HomeContentPage(email: widget.email),
      const MembershipCardsPage(membershipTiers: []),
      const ProfilePage(),
      const NotificationPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership),
            label: 'Card',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: const Color(0xFF002855),
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContentPage extends StatelessWidget {
  final String email;

  const HomeContentPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('User email: $email');
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildHeader(),
        const SizedBox(height: 20),
        _buildMembershipCard(context),
      ],
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/logo1.png',
            height: 120,
            width: 120,
          ),
          const SizedBox(height: 10),
          const Text(
            "Welcome to the MAAB Dashboard!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "Manage your membership, view benefits, and stay updated.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipCard(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('membershipApplicants')
          .where('email', isEqualTo: email)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Error loading membership data.',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildJoinNowCard(context);
        }

        final doc = snapshot.data!.docs.first;
        final data = doc.data() as Map<String, dynamic>;

        final String status = data['status']?.toLowerCase() ?? 'pending';
        final String membershipCategory = data['membershipCategory'] ?? '';
        final String imagePath = 'assets/$membershipCategory.png';

        if (status == 'approved' && membershipCategory.isNotEmpty) {
          return _buildMembershipImageCard(imagePath);
        }

        return _buildPendingApplicationCard();
      },
    );
  }

  Widget _buildJoinNowCard(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.redAccent, Color(0xFF002855)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Not a Member Yet?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Join the Philippine Red Cross Membership Program to help vulnerable Filipinos and enjoy accident assistance benefits.",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationPage(
                      email: '',
                    ),
                  ),
                );
              },
              child: const Text("Join Now"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipImageCard(String imagePath,
      {double width = double.infinity}) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          height: 300, // Maintain fixed height
          width: 530, // Use the passed or default width
          errorBuilder: (context, error, stackTrace) {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: const Text(
                'Image not found',
                style: TextStyle(color: Colors.red),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPendingApplicationCard() {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Membership Pending",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Your application is under review. Please check back later.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
