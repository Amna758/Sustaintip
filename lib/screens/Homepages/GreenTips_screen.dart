import 'package:flutter/material.dart';
import 'package:my_new_sustain_app/screens/Homepages/Profile_Screen.dart'; // Make sure this path is correct

// GreenTip class remains the same
class GreenTip {
  final String category;
  final String title;
  final String description;
  bool isSelected;

  GreenTip({
    required this.category,
    required this.title,
    required this.description,
    this.isSelected = false,
  });
}

class GreentipsScreen extends StatefulWidget {
  final String
      tipsText; // Accepts tips from the previous screen in the new format

  const GreentipsScreen({super.key, required this.tipsText});

  @override
  State<GreentipsScreen> createState() => _GreentipsScreenState();
}

class _GreentipsScreenState extends State<GreentipsScreen> {
  List<GreenTip> selectedTips = [];

  @override
  void initState() {
    super.initState();
    _parseTips(); // Call the new parsing method
  }

  // New method to parse tips based on the "category, title, description; ..." format
  void _parseTips() {
    if (widget.tipsText.isEmpty) {
      setState(() {
        selectedTips = [];
      });
      return;
    }

    // 1. Split the entire string by ';' to get individual tip data strings
    final tipDataStrings = widget.tipsText.split(';');

    final List<GreenTip> parsedTips = tipDataStrings
        .map((singleTipData) {
          // 2. Trim whitespace from the individual tip data string
          final trimmedTipData = singleTipData.trim();

          // If after trimming, the string is empty, skip it
          if (trimmedTipData.isEmpty) {
            return null;
          }

          // 3. Split the trimmed tip data string by ',' to get category, title, and description
          // Trim each part as well to handle spaces like "category , title , description"
          final parts =
              trimmedTipData.split(',').map((part) => part.trim()).toList();

          // 4. Validate that we have exactly 3 parts
          if (parts.length == 3) {
            final category = parts[0];
            final titlePart = parts[1];
            final description = parts[2];

            // Optional: Keep title truncation if desired, or remove if Gemini provides good titles
            final String title =
                titlePart.length > 35 // Adjusted length slightly
                    ? '${titlePart.substring(0, 35)}...'
                    : titlePart;

            return GreenTip(
              category: category,
              title: title,
              description: description,
            );
          } else {
            // Handle malformed tip data
            print(
                'Warning: Malformed tip data ignored (expected 3 parts, got ${parts.length}): "$trimmedTipData"');
            return null;
          }
        })
        .whereType<GreenTip>() // Filters out nulls and ensures the list type
        .toList();

    setState(() {
      selectedTips = parsedTips;
    });
  }

  // _guessCategory method is no longer needed and has been removed.

  // Updated _getCategoryColor method with different colors
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase().trim()) {
      // Added trim() for robustness
      case 'home':
        return Colors.teal; // Changed from green
      case 'travel':
      case 'transport': // Added 'transport' as an alias
        return Colors.indigo; // Changed from blue
      case 'food':
        return Colors.orange.shade700; // Changed from red
      case 'work':
        return Colors.purple.shade400;
      case 'water':
        return Colors.lightBlue.shade600;
      case 'energy':
        return Colors.amber.shade700;
      default:
        return Colors.blueGrey; // Changed from grey
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Choose Your Green Actions',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        // Example: If you want to keep settings icon
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.settings, color: Colors.black),
        //     onPressed: () {
        //       // Handle settings tap
        //     },
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: selectedTips.isEmpty
                  ? Center(
                      child: widget.tipsText.isEmpty
                          ? const Text("No tips provided.")
                          : const Text(
                              "Processing tips or no valid tips found.\nCheck format: 'category, title, description;...'",
                              textAlign: TextAlign.center,
                            ),
                    )
                  : ListView.builder(
                      itemCount: selectedTips.length,
                      itemBuilder: (context, index) {
                        final tip = selectedTips[index];
                        final categoryColor = _getCategoryColor(tip.category);
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4), // Adjusted padding
                              decoration: BoxDecoration(
                                  color: categoryColor.withOpacity(
                                      0.15), // Slightly more opacity
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: categoryColor
                                          .withOpacity(0.5)) // Optional border
                                  ),
                              child: Text(
                                tip.category, // Display category directly
                                style: TextStyle(
                                  color: categoryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12, // Adjusted font size
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            title: Text(
                              tip.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(tip.description),
                            trailing: Checkbox(
                              value: tip.isSelected,
                              activeColor: Colors.green
                                  .shade600, // Set active color for checkbox
                              onChanged: (value) {
                                setState(() => tip.isSelected = value ?? false);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0), // Increased padding
            child: ElevatedButton(
              onPressed: selectedTips.any((tip) => tip
                      .isSelected) // Enable only if at least one tip is selected
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            // Pass only selected tips or all tips, depending on requirement
                            selectedTips: selectedTips
                                .where((tip) => tip.isSelected)
                                .toList(),
                          ),
                        ),
                      );
                    }
                  : null, // Disable button if no tips are selected
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green.shade600, // Use a consistent green
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                minimumSize:
                    const Size(double.infinity, 50), // Make button wider
              ),
              child: const Text(
                'Track My Selected Tips ➜',
                style: TextStyle(
                    fontSize: 16, color: Colors.white), // Ensure text is white
              ),
            ),
          ),
        ],
      ),
    );
  }
}



/*

import 'package:flutter/material.dart';



import 'package:my_new_sustain_app/screens/Homepages/Profile_Screen.dart';

class GreenTip {
  final String category;
  final String title;
  final String description;
  bool isSelected;

  GreenTip({
    required this.category,
    required this.title,
    required this.description,
    this.isSelected = false,
  });
}

class GreentipsScreen extends StatefulWidget {
  final String tipsText; // ✅ Accept tips from previous screen

  const GreentipsScreen({super.key, required this.tipsText});

  @override
  State<GreentipsScreen> createState() => _GreentipsScreenState();
}

class _GreentipsScreenState extends State<GreentipsScreen> {
  List<GreenTip> selectedTips = [];

  @override
  void initState() {
    super.initState();

    final tips = widget.tipsText
        .split('\n')
        .where((tip) => tip.trim().isNotEmpty)
        .toList();

    selectedTips = tips.map((tip) {
      return GreenTip(
        category: _guessCategory(tip),
        title: tip.length > 30 ? '${tip.substring(0, 30)}...' : tip,
        description: tip,
      );
    }).toList();
  }

  String _guessCategory(String tip) {
    final tipLower = tip.toLowerCase();
    if (tipLower.contains('home')) return 'Home';
    if (tipLower.contains('transport') || tipLower.contains('car'))
      return 'Travel';
    if (tipLower.contains('food') || tipLower.contains('eat')) return 'Food';
    return 'General';
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'home':
        return Colors.green.shade600;
      case 'travel':
        return Colors.blue.shade600;
      case 'food':
        return Colors.red.shade400;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Choose Your Green Actions',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: selectedTips.length,
                itemBuilder: (context, index) {
                  final tip = selectedTips[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color:
                              _getCategoryColor(tip.category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "#${tip.category}",
                          style: TextStyle(
                            color: _getCategoryColor(tip.category),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        tip.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(tip.description),
                      trailing: Checkbox(
                        value: tip.isSelected,
                        onChanged: (value) {
                          setState(() => tip.isSelected = value ?? false);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      selectedTips: selectedTips,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
              ),
              child:
                  const Text('Track My Tips ➜', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
*/