// terms_and_conditions.dart

import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo Section
              Center(
                child: Image.asset(
                  'assets/logo1.png', // Replace with your actual logo path
                  width: 120,
                  height: 120,
                ),
              ),
              const SizedBox(height: 16),
              // Title Section
              const Text(
                "Terms and Conditions",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Terms and Conditions Content
              const Text(
                '''
Joining the Philippine Red Cross (PRC) Membership Program gives an individual self-worth as you are extending help to the most vulnerable Filipinos.

Membership Eligibility
1. Membership is open to individuals aged 3 to 85 years old.

Membership Benefits
- Accidental Death Coverage: Financial support in the event of accidental death.
- Disablement and Dismemberment Coverage: Compensation for accidental injuries.
- Hospitalization Reimbursement: Financial assistance for hospitalization costs due to accidents.
- Burial Assistance: Assistance for burial expenses.

Responsibilities of Members
1. Members must provide accurate information during registration.
2. Any changes to personal details should be communicated promptly to PRC.

Privacy and Data Protection
- All personal information will be securely handled in compliance with applicable data protection laws.

By continuing to use this app and the services of the PRC Membership Program, you agree to these terms and conditions. For further information, contact the Philippine Red Cross through official channels.
                ''',
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              // Close Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
