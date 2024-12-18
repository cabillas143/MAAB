import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart'; // For formatting amounts and dates
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redcross_mp/user/dashboard.dart';
import 'package:redcross_mp/user/notification_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key, required String email}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _barangayController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? _bloodType;
  String? _membershipCategory;
  String? _prcChapter;
  String? _paymentMethod;

  bool _isLoading = false;
  String? _errorMessage;

  // List of cities, barangays, membership categories, blood types, and chapters
  final List<String> _cities = ["Oroquieta"];
  final List<String> _barangays = [
    "Apil",
    "Binuangan",
    "Bolibol",
    "Buenavista",
    "Bunga",
    "Buntawan",
    "Burgos",
    "Canubay",
    "Ciriaco C. Pastrano",
    "Clarin Settlement",
    "Dolipos Alto",
    "Dolipos Bajo",
    "Dulapo",
    "Dullan Norte",
    "Dullan Sur",
    "Lamac Lower",
    "Lamac Upper",
    "Langcangan Lower",
    "Langcangan Proper",
    "Langcangan Upper",
    "Layawan",
    "Loboc Lower",
    "Loboc Upper",
    "Malindang",
    "Mialen",
    "Mobod",
    "Paypayan",
    "Pines",
    "Poblacion 1",
    "Poblacion 2",
    "Rizal Lower",
    "Rizal Upper",
    "San Vicente Alto",
    "San Vincente Bajo",
    "Sebucal",
    "Senote",
    "Taboc Norte",
    "Taboc Sur",
    "Talairon",
    "Talic",
    "Tipan",
    "Toliyok",
    "Tuyabang Alto",
    "Tuyabang Bajo",
    "Tuyabang Proper",
    "Victoria",
    "Villaflor"
  ];
  final Map<String, Map<String, dynamic>> _membershipDetails = {
    "Enhanced Platinum": {
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
    },
    "Classic": {
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
    },
    "Premier Bronze": {
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
    },
    "Premier Silver": {
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
    },
    "Premier Gold": {
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
    },
    "Premier Senior": {
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
    },
    "Premier Senior Plus": {
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
    },
  };
  final List<String> _bloodTypes = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-"
  ];
  final List<String> _prcChapters = ["Misamis Occidental-Oroquieta"];

  // Initialize Firebase
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  // Function to generate GCash receipt
  String _generateReceipt() {
    final String receiptNumber =
        'Bank Account-${DateTime.now().millisecondsSinceEpoch}';
    final String formattedAmount =
        NumberFormat.currency(locale: 'en_US', symbol: '₱')
            .format(double.tryParse(_amountController.text) ?? 0.0);
    final DateTime now = DateTime.now();
    final String formattedDate =
        DateFormat('yMMMd').format(now); // e.g., Dec 8, 2024
    final String formattedTime =
        DateFormat('hh:mm a').format(now); // e.g., 04:30 PM

    return 'Receipt No: $receiptNumber\n'
        'Account Number: ${_accountNumberController.text}\n'
        'Amount: $formattedAmount\n'
        'Date: $formattedDate\n'
        'Time: $formattedTime';
  }

  // Function to register the membership with payment details
  // Registration function with notifications logic
  // After registration, navigate to the dashboard and update notifications
  // Replace the relevant parts in your registration function with this code
  Future<void> _registerMembership() async {
    final firstName = _firstNameController.text.trim();
    final middleName = _middleNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final address = _addressController.text.trim();
    final barangay = _barangayController.text.trim();
    final city = _cityController.text.trim();
    final birthday = _birthdayController.text.trim();
    final age = _ageController.text.trim();
    final contact = _contactController.text.trim();
    final email = _emailController.text.trim();

    // Field validation
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        address.isEmpty ||
        barangay.isEmpty ||
        city.isEmpty ||
        birthday.isEmpty ||
        age.isEmpty ||
        contact.isEmpty ||
        contact.length < 10 ||
        email.isEmpty ||
        _bloodType == null ||
        _membershipCategory == null ||
        _prcChapter == null ||
        _paymentMethod == null ||
        (_paymentMethod == 'Bank Account' &&
            _accountNumberController.text.isEmpty) ||
        (_paymentMethod == 'Bank Account' && _amountController.text.isEmpty)) {
      setState(() {
        _errorMessage = "All fields are required.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Save registration data to Firestore
      final memberRef = await FirebaseFirestore.instance
          .collection('membershipApplicants')
          .add({
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'address': address,
        'barangay': barangay,
        'city': city,
        'birthday': birthday,
        'age': age,
        'contact': contact,
        'email': email,
        'bloodType': _bloodType,
        'membershipCategory': _membershipCategory,
        'prcChapter': _prcChapter,
        'paymentMethod': _paymentMethod,
        'accountNumber': _paymentMethod == 'Bank Account'
            ? _accountNumberController.text
            : null,
        'amountPaid':
            _paymentMethod == 'Bank Account' ? _amountController.text : null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (_paymentMethod == 'Bank Account') {
        String receipt = _generateReceipt();
        await memberRef.update({'receipt': receipt});

        // Displaying the notification in the dashboard
        Fluttertoast.showToast(
            msg: "Payment Successful! Wait for approval. Receipt: $receipt");
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitted successfully!')),
      );

      // Navigate to the Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const DashboardPage(
                  email: '',
                )),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to submit. Error: $error";
      });
    }
  }

  // Function to show Date Picker for Birthday
  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        _birthdayController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Registration'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name Fields
              TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                      labelText: 'First Name', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(
                  controller: _middleNameController,
                  decoration: const InputDecoration(
                      labelText: 'Middle Name', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                      labelText: 'Last Name', border: OutlineInputBorder())),
              const SizedBox(height: 10),

              // Address Fields
              TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                      labelText: 'Street Address',
                      border: OutlineInputBorder())),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                  value: _barangayController.text.isEmpty
                      ? null
                      : _barangayController.text,
                  items: _barangays
                      .map((barangay) => DropdownMenuItem(
                          value: barangay, child: Text(barangay)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _barangayController.text = value!),
                  decoration: const InputDecoration(
                      labelText: 'Barangay', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                  value: _cityController.text.isEmpty
                      ? null
                      : _cityController.text,
                  items: _cities
                      .map((city) =>
                          DropdownMenuItem(value: city, child: Text(city)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _cityController.text = value!),
                  decoration: const InputDecoration(
                      labelText: 'City', border: OutlineInputBorder())),
              const SizedBox(height: 10),

              // Birthday, Age, and Contact
              TextField(
                  controller: _birthdayController,
                  decoration: const InputDecoration(
                      labelText: 'Birthday', border: OutlineInputBorder()),
                  onTap: () => _selectDate(context),
                  readOnly: true),
              const SizedBox(height: 10),
              TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                      labelText: 'Age', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              TextField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                      labelText: 'Contact Number',
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 10),
              TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 10),

              // Payment Method
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                items: ['Bank Account', 'Cash on Hand']
                    .map((method) =>
                        DropdownMenuItem(value: method, child: Text(method)))
                    .toList(),
                onChanged: (value) => setState(() => _paymentMethod = value),
                decoration: const InputDecoration(
                    labelText: 'Payment Method', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),

              // GCash Details
              if (_paymentMethod == 'Bank Account') ...[
                TextField(
                    controller: _accountNumberController,
                    decoration: const InputDecoration(
                        labelText: 'Account Number',
                        border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                        labelText: 'Amount Paid (₱)',
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number),
                const SizedBox(height: 10),
              ],

              // Dropdowns for other info
              DropdownButtonFormField<String>(
                  value: _bloodType,
                  items: _bloodTypes
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) => setState(() => _bloodType = value),
                  decoration: const InputDecoration(
                      labelText: 'Blood Type', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _membershipCategory,
                items: _membershipDetails.keys
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(category),
                              if (_membershipCategory == null)
                                IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {
                                    final details =
                                        _membershipDetails[category];
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(category),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                "Coverage: ${details?['coverage']}"),
                                            Text("Fee: PHP ${details?['fee']}"),
                                            Text(
                                                "Age Range: ${details?['age_range']}"),
                                            const SizedBox(height: 10),
                                            const Text("Benefits:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            ...details?['benefits']
                                                .map<Widget>((benefit) =>
                                                    Text("• $benefit"))
                                                .toList(),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) => setState(() {
                  _membershipCategory = value;
                }),
                decoration: const InputDecoration(
                  labelText: 'Membership Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _prcChapter,
                items: _prcChapters
                    .map((chapter) =>
                        DropdownMenuItem(value: chapter, child: Text(chapter)))
                    .toList(),
                onChanged: (value) => setState(() => _prcChapter = value),
                decoration: const InputDecoration(
                    labelText: 'PRC Chapter', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),

              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true; // Start loading animation
                        });

                        // Call the _registerMembership function
                        await _registerMembership();

                        setState(() {
                          _isLoading = false; // Stop loading animation
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Submit Form'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
