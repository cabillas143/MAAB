import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redcross_mp/landing_page.dart'; // Make sure this path is correct

class MainDashboard extends StatelessWidget {
  final String email;

  const MainDashboard({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    String username = "CLEMENTINE"; // Replace with dynamic username if needed

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red[700],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    username,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const Text(
                    "HERO FOR BABIES",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About Us"),
              onTap: () {
                Navigator.pop(context);
                // Add navigation logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Confirm Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(dialogContext).pop();
                            await _signOutAndNavigate(context);
                          },
                          child: const Text('Sign Out'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: Colors.red[700],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const Text(
                            "HERO FOR BABIES",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('assets/profile.png'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // BODY CONTENT
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Ready to donate card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Ready to donate again?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Blood donation in the morning,\nnear California, 90210",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bloodtype, color: Colors.red),
                            SizedBox(width: 12),
                            Icon(Icons.wb_sunny, color: Colors.orange),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: const Text("BOOK ANOTHER LIKE THIS"),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Hero rewards section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("HERO FOR BABIES",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                        SizedBox(height: 6),
                        Text("Give Life.\nEarn Points.\nGet Rewarded.",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Schedule New Appointment
                  ListTile(
                    leading:
                        const Icon(Icons.calendar_today, color: Colors.red),
                    title: const Text("Schedule New Appointment"),
                    subtitle:
                        const Text("Choose a time, location and donation type"),
                    onTap: () {},
                  ),

                  const Divider(),

                  // Donor Card
                  ListTile(
                    leading: const Icon(Icons.credit_card, color: Colors.red),
                    title: const Text("Donor Card"),
                    subtitle: const Text("Your Digital Donor Card"),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _signOutAndNavigate(BuildContext context) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'lastLogout': FieldValue.serverTimestamp()});
    }

    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()),
      (route) => false,
    );
  } catch (e) {
    debugPrint("Sign out error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error signing out. Please try again.")),
    );
  }
}
}