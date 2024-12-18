import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovalPage extends StatelessWidget {
  final String fullName;
  final String userId;
  final String bloodType;

  const ApprovalPage({
    super.key,
    required this.fullName,
    required this.userId,
    required this.bloodType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$fullName - Details'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('membershipApplicants')
            .doc(userId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
                child: Text('Error fetching applicant details.'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Applicant not found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Applicant Information',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                _buildInfoCard('Full Name', fullName),
                _buildInfoCard('Email', data?['email'] ?? 'N/A'),
                _buildInfoCard('PRC Chapter', data?['PrcChapter'] ?? 'N/A'),
                _buildInfoCard(
                    'Account Number', data?['accountNumber'] ?? 'N/A'),
                const SizedBox(height: 16.0),
                Text(
                  'Additional Details',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                _buildInfoCard('Address', data?['address'] ?? 'N/A'),
                _buildInfoCard('Age', data?['age']?.toString() ?? 'N/A'),
                _buildInfoCard('Amount Paid', data?['amountPaid'] ?? 'N/A'),
                _buildInfoCard('Barangay', data?['barangay'] ?? 'N/A'),
                _buildInfoCard('Birthday', data?['birthday'] ?? 'N/A'),
                _buildInfoCard('Blood Type', data?['bloodType'] ?? bloodType),
                _buildInfoCard('City', data?['city'] ?? 'N/A'),
                _buildInfoCard('Contact', data?['contact'] ?? 'N/A'),
                _buildInfoCard('Membership Category',
                    data?['membershipCategory'] ?? 'N/A'),
                _buildInfoCard(
                    'Payment Method', data?['paymentMethod'] ?? 'N/A'),
                _buildInfoCard('Receipt', data?['receipt'] ?? 'N/A'),
                _buildInfoCard('Status', data?['status'] ?? 'N/A'),
                _buildInfoCard('Created At',
                    data?['createdAt']?.toDate().toString() ?? 'N/A'),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _updateStatus(context, userId, 'approved');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20.0),
                      ),
                      child: const Text('Approve'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _updateStatus(context, userId, 'rejected');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20.0),
                      ),
                      child: const Text('Reject'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Text(
                value,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(
      BuildContext context, String userId, String newStatus) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('membershipApplicants')
          .doc(userId)
          .get();

      if (!docSnapshot.exists) {
        throw Exception("Applicant not found.");
      }

      final data = docSnapshot.data();
      if (data == null) {
        throw Exception("Invalid data for applicant.");
      }

      final String firstName = data['firstName'] ?? '';
      final String middleName = data['middleName'] ?? '';
      final String lastName = data['lastName'] ?? '';
      final String combinedFullName = [firstName, middleName, lastName]
          .where((name) => name.isNotEmpty)
          .join(' ');

      final String email = data['email'] ?? '';
      String message;
      if (newStatus == 'approved') {
        message = 'Congratulations!! You are now a member!';
      } else if (newStatus == 'rejected') {
        message = 'Unfortunately, your membership was rejected.';
      } else {
        message = 'Your membership status has been updated.';
      }

      await FirebaseFirestore.instance
          .collection('membershipApplicants')
          .doc(userId)
          .update({'status': newStatus});

      await FirebaseFirestore.instance.collection('notifications').add({
        'fullname': combinedFullName,
        'email': email,
        'message': message,
        'receivedAt': FieldValue.serverTimestamp(),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to $newStatus and user notified.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status. Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
