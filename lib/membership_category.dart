import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MembershipCategoryPage extends StatefulWidget {
  const MembershipCategoryPage({super.key});

  @override
  State<MembershipCategoryPage> createState() => _MembershipCategoryPageState();
}

class _MembershipCategoryPageState extends State<MembershipCategoryPage> {
  // Membership categories
  final List<String> _categories = [
    'Enhanced Platinum',
    'Classic',
    'Premier Bronze',
    'Premier Silver',
    'Premier Gold',
    'Premier Senior',
    'Premier Senior Plus',
  ];

  // Data holder for membership counts
  Map<String, int> _categoryCounts = {};

  @override
  void initState() {
    super.initState();
    _fetchCategoryCounts();
  }

  Future<void> _fetchCategoryCounts() async {
    try {
      // Initialize counts
      Map<String, int> counts = {for (var category in _categories) category: 0};

      // Fetch all documents from membershipApplicants collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('membershipApplicants')
          .get();

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String? category = data['membershipCategory'];

        // Increment count for the category if valid
        if (category != null && counts.containsKey(category)) {
          counts[category] = counts[category]! + 1;
        }
      }

      // Update state with fetched counts
      setState(() {
        _categoryCounts = counts;
      });
    } catch (e) {
      debugPrint('Error fetching category counts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                'Membership Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Numbers at the top
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (_categoryCounts[category] ?? 0).toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        category,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Main Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Membership Category Breakdown',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Bar Chart
                Expanded(
                  child: _categoryCounts.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : BarChart(
                          BarChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    if (value.toInt() >= 0 &&
                                        value.toInt() < _categories.length) {
                                      return Text(
                                        _categories[value.toInt()],
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                  reservedSize: 40,
                                ),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            barGroups: List.generate(
                              _categories.length,
                              (index) => BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: (_categoryCounts[_categories[index]] ??
                                            0)
                                        .toDouble(),
                                    color: Colors.blue,
                                    width: 20,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
