import 'package:admin/approval.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MembershipsApplicantsPage extends StatelessWidget {
  const MembershipsApplicantsPage({super.key, required List membershipTiers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('membershipApplicants')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final applicants = snapshot.data!.docs;

          return LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 600;

              return Column(
                children: [
                  // Title Row
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.grey.shade200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: isWide ? 2 : 5,
                          child: const Text(
                            'Full Name',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: isWide ? 2 : 5,
                          child: const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: isWide ? 2 : 5,
                          child: const Text(
                            'Membership Category',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: isWide ? 2 : 5,
                          child: const Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Actions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.grey, height: 1),
                  // Applicants List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: applicants.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final applicant = applicants[index];
                        return _buildApplicantRow(context, applicant, isWide);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildApplicantRow(
      BuildContext context, DocumentSnapshot applicant, bool isWide) {
    final data = applicant.data() as Map<String, dynamic>?;

    // Fetching applicant details
    final String firstName = data?['firstName'] ?? 'No firstname';
    final String middleName = data?['middleName'] ?? '';
    final String lastName = data?['lastName'] ?? 'No lastname';
    final String fullName = '$firstName $middleName $lastName';
    final String email = data?['email'] ?? 'No email';
    final String membershipCategory =
        data?['membershipCategory'] ?? 'No category';
    final String status = data?['status'] ?? 'pending';
    final String userId = applicant.id; // Use the document ID as the user ID
    final String bloodType = data?['bloodType'] ?? 'No blood type';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: isWide ? 2 : 5,
            child: Text(
              fullName,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: isWide ? 2 : 5,
            child: Text(
              email,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: isWide ? 2 : 5,
            child: Text(
              membershipCategory,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: isWide ? 2 : 5,
            child: Text(
              status,
              style: TextStyle(
                fontSize: 14,
                color: status == 'approved' ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, color: Colors.blue),
                onPressed: () {
                  // Navigate to the approval page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApprovalPage(
                        fullName: fullName,
                        userId: userId,
                        bloodType: bloodType,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Delete'),
                      content:
                          Text('Are you sure you want to delete $fullName?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    try {
                      await FirebaseFirestore.instance
                          .collection('membershipApplicants')
                          .doc(userId)
                          .delete();

                      // Use the correct ScaffoldMessenger context
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(Navigator.of(context).context)
                          .showSnackBar(
                        SnackBar(
                          content: Text('$fullName deleted successfully.'),
                        ),
                      );
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(Navigator.of(context).context)
                          .showSnackBar(
                        SnackBar(
                          content: Text('Failed to delete $fullName.'),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
