import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the logged-in user's email
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;

    // If no user is logged in, display a fallback screen
    if (userEmail == null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Remove the back button
          title: const Text("Notifications"),
          backgroundColor: Colors.redAccent,
        ),
        body: const Center(
          child: Text(
            "No user logged in. Please log in to view notifications.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back button
        title: const Text("Notifications"),
        backgroundColor: Colors.redAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('notifications').snapshots(),
        builder: (context, snapshot) {
          // Show a loading spinner while the data is being fetched
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Display an error message if there is an error
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "An error occurred while loading notifications.",
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          // Show a message if no notifications are available
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No notifications available.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          // Filter notifications based on user email and ensure required fields exist
          final userNotifications = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['email'] == userEmail &&
                data.containsKey('fullname') &&
                data.containsKey('message');
          }).toList();

          // Show a message if no notifications match the user's email or required fields are missing
          if (userNotifications.isEmpty) {
            return const Center(
              child: Text(
                "No notifications available.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Display notifications in a list
          return ListView.builder(
            itemCount: userNotifications.length,
            itemBuilder: (context, index) {
              final notification = userNotifications[index];
              final data = notification.data() as Map<String, dynamic>;

              final fullname = data['fullname'] as String;
              final message = data['message'] as String;
              final receivedAt = data.containsKey('receivedAt')
                  ? (data['receivedAt'] as Timestamp).toDate()
                  : null;

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.notifications_active,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    fullname,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 4.0),
                      if (receivedAt != null)
                        Text(
                          "Date: ${receivedAt.toLocal()}",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Notification: $message"),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
