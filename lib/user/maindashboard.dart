import 'package:flutter/material.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key, required email});

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
                Navigator.pop(context);
                // Add sign out logic
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
                    builder: (context) => // Menu icon opens drawer
                        IconButton(
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
                          Text(username,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          const Text("HERO FOR BABIES",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(width: 12),
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            AssetImage('assets/profile.png'), // Replace with real image
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
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
                    subtitle: const Text(
                        "Choose a time, location and donation type"),
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
}
