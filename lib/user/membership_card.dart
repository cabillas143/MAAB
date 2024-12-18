import 'package:flutter/material.dart';
import 'package:redcross_mp/user/dashboard.dart';

class MembershipCardsPage extends StatelessWidget {
  const MembershipCardsPage({Key? key, required List membershipTiers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Membership Tiers Data
    final List<Map<String, dynamic>> membershipTiers = [
      {
        'title': 'Enhanced Platinum',
        'coverage': '300,000',
        'fee': '1,000',
        'age_range': 'Ages 5-65 years old',
        'benefits': [
          "PHP 300,000: Accidental Death, Disablement & Dismemberment",
          "PHP 300,000: Unprovoked Murder & Assault",
          "PHP 10,000: Accidental Medical Reimbursement",
          "PHP 5,000: Accidental Burial Assistance",
          "PHP 200: Hospital Daily Allowance per day (Max of 60 days)",
          "Free ambulance and 1 unit of whole blood annually",
        ],
        'image': 'assets/Enhanced Platinum.png',
      },
      {
        'title': 'Classic',
        'coverage': 'PHP 12,000',
        'fee': '60',
        'age_range': 'Ages 5-25 years old',
        'benefits': [
          "PHP 12,000: Accidental Death, Disablement & Dismemberment",
          "PHP 12,000: Unprovoked Murder & Assault",
          "PHP 5,000: Accidental Medical Reimbursement",
          "PHP 5,000: Accidental Burial Assistance",
          "PHP 150: Hospital Daily Allowance per day (Max of 60 days)",
        ],
        'image': 'assets/Classic.png',
      },
      {
        'title': 'Premier Bronze',
        'coverage': 'PHP 12,000',
        'fee': '150',
        'age_range': 'Ages 5-65 years old',
        'benefits': [
          "PHP 35,000: Accidental Death, Disablement & Dismemberment",
          "PHP 35,000: Unprovoked Murder & Assault",
          "PHP 5,000: Accidental Medical Reimbursement",
          "PHP 5,000: Accidental Burial Assistance",
          "PHP 150: Hospital Daily Allowance per day (Max of 60 days)",
        ],
        'image': 'assets/Premier Bronze.png',
      },
      {
        'title': 'Premier Silver',
        'coverage': 'PHP 100,000',
        'fee': '300',
        'age_range': 'Ages 5-65 years old',
        'benefits': [
          "PHP 100,000: Accidental Death, Disablement & Dismemberment",
          "PHP 100,000: Unprovoked Murder & Assault",
          "PHP 10,000: Accidental Medical Reimbursement",
          "PHP 5,000: Accidental Burial Assistance",
          "PHP 200: Hospital Daily Allowance per day (Max of 60 days)",
        ],
        'image': 'assets/Premier Silver.png',
      },
      {
        'title': 'Premier Gold',
        'coverage': 'PHP 200,000',
        'fee': '500',
        'age_range': 'Ages 5-65 years old',
        'benefits': [
          "PHP 200,000: Accidental Death, Disablement & Dismemberment",
          "PHP 200,000: Unprovoked Murder & Assault",
          "PHP 10,000: Accidental Medical Reimbursement",
          "PHP 5,000: Accidental Burial Assistance",
          "PHP 200: Hospital Daily Allowance per day (Max of 60 days)",
        ],
        'image': 'assets/Premier Gold.png',
      },
      {
        'title': 'Premier Senior',
        'coverage': 'PHP 50,000',
        'fee': '300',
        'age_range': 'Ages 66-80 years old',
        'benefits': [
          "PHP 50,000: Accidental Death, Disablement & Dismemberment",
          "PHP 50,000: Unprovoked Murder & Assault",
          "PHP 5,000: Accidental Medical Reimbursement",
          "PHP 5,000: Accidental Burial Assistance",
          "PHP 100: Hospital Daily Allowance per day (Max of 60 days)",
        ],
        'image': 'assets/Premier Senior.png',
      },
      {
        'title': 'Premier Senior Plus',
        'coverage': 'PHP 50,000',
        'fee': '350',
        'age_range': 'Ages 81-85 years old',
        'benefits': [
          "PHP 50,000: Accidental Death, Disablement & Dismemberment",
          "PHP 50,000: Unprovoked Murder & Assault",
          "PHP 5,000: Accidental Medical Reimbursement",
          "PHP 5,000: Accidental Burial Assistance",
          "PHP 100: Hospital Daily Allowance per day (Max of 60 days)",
        ],
        'image': 'assets/Premier Senior Plus.png',
      },
    ];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: membershipTiers.length,
        itemBuilder: (context, index) {
          final tier = membershipTiers[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: Colors.black45,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.asset(
                      tier['image'],
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tier['title'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 7, 98),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Fee: ₱${tier['fee']}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              tier['age_range'],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CardDetailsPage(tier: tier),
                                ),
                              );
                            },
                            child: const Text(
                              "View Details",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CardDetailsPage extends StatelessWidget {
  final Map<String, dynamic> tier;

  const CardDetailsPage({Key? key, required this.tier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous page
          },
        ),
        backgroundColor: Colors.red, // You can customize the color as needed
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Image.asset(
                    tier['image'],
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tier['title'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Coverage: ₱${tier['coverage']}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Membership Fee: ₱${tier['fee']}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tier['age_range'],
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Benefits:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tier['benefits']
                  .map<Widget>((benefit) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check,
                                size: 18, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                benefit,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
