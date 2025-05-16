import 'package:flutter/material.dart';
// Ensure GreenTip is accessible. If it's in GreentipsScreen.dart, this import is correct.
import 'package:my_new_sustain_app/screens/Homepages/GreenTips_screen.dart';
import 'package:my_new_sustain_app/screens/Homepages/Profile_Screen.dart';
import 'package:intl/intl.dart';

// Helper function for category colors (similar to GreentipsScreen)
// In a real app, you might put this in a shared utility file.
Color _getCategoryColorForTrackScreen(String category) {
  switch (category.toLowerCase().trim()) {
    case 'home':
      return Colors.teal;
    case 'travel':
    case 'transport':
      return Colors.indigo;
    case 'food':
      return Colors.orange.shade700;
    case 'work':
      return Colors.purple.shade400;
    case 'water':
      return Colors.lightBlue.shade600;
    case 'energy':
      return Colors.amber.shade700;
    default:
      return Colors.blueGrey;
  }
}

class TrackScreen extends StatelessWidget {
  final List<GreenTip>
      selectedTips; // These tips are already "selected" from the previous screen

  TrackScreen({super.key, required this.selectedTips});

  @override
  Widget build(BuildContext context) {
    // In this screen, 'isSelected' likely means "completed for today"
    // If selectedTips comes from GreentipsScreen, it might be all tips chosen by the user,
    // and 'isSelected' within GreenTip class could track completion.
    // Let's assume selectedTips are the ones the user *wants* to track,
    // and tip.isSelected means "is completed today".

    int completedCount = selectedTips.where((tip) => tip.isSelected).length;
    double progress =
        selectedTips.isNotEmpty ? completedCount / selectedTips.length : 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Track Today\'s Green Wins',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        // If you need a back button and it's not appearing automatically (e.g., if this screen is pushed)
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Tag
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.yellow.shade700, // Slightly darker yellow
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '🌞 Today: ${DateFormat('d MMMM yyyy').format(DateTime.now())}', // Added year
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 20), // Increased spacing

            // Progress bar and text
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12, // Slightly thicker
                      backgroundColor: Colors.grey.shade300,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.green.shade600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "${(progress * 100).round()}%",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                      fontSize: 16),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "$completedCount of ${selectedTips.length} actions completed.",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),

            const Text(
              'Your Green Actions for Today:', // Changed title slightly
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18), // Increased font size
            ),
            const SizedBox(height: 12),

            // List of tips with checkboxes and category tags
            Expanded(
              child: selectedTips.isEmpty
                  ? const Center(
                      child: Text(
                      "No green actions selected for tracking yet.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ))
                  : ListView.builder(
                      itemCount: selectedTips.length,
                      itemBuilder: (context, index) {
                        final tip = selectedTips[index];
                        final categoryColor =
                            _getCategoryColorForTrackScreen(tip.category);
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: CheckboxListTile(
                            title: Text(
                              tip.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                decoration: tip.isSelected
                                    ? TextDecoration
                                        .lineThrough // Strikethrough if completed
                                    : TextDecoration.none,
                                color: tip.isSelected
                                    ? Colors.grey.shade600
                                    : Colors.black87,
                              ),
                            ),
                            // Using subtitle to display the category tag neatly
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: categoryColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: categoryColor.withOpacity(0.4)),
                                  ),
                                  child: Text(
                                    tip.category,
                                    style: TextStyle(
                                      color: categoryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            value: tip.isSelected,
                            onChanged: (bool? newValue) {
                              // To make this interactive, TrackScreen needs to be StatefulWidget
                              // and you'd call setState here to update the tip's isSelected state.
                              // For now, it's disabled as per original code.
                              // If you want to enable:
                              // setState(() {
                              //   tip.isSelected = newValue ?? false;
                              // });
                            },
                            activeColor: Colors.green.shade600,
                            controlAffinity: ListTileControlAffinity.leading,
                            // Optional: add a secondary widget if subtitle is used for something else
                            // secondary: Container( ... category tag ... ),
                          ),
                        );
                      },
                    ),
            ),

            // Progress note - refined
            if (selectedTips.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Text(
                  completedCount == selectedTips.length
                      ? "🎉 Awesome! All green actions completed for today! 🌍"
                      : "Keep going, you're making a difference! 🌱",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey.shade600,
        showSelectedLabels: false, // Hides labels for a cleaner look
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.track_changes_rounded),
              label: 'Track'), // Changed icon
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        currentIndex: 0, // Assuming TrackScreen is the first tab
        onTap: (index) {
          if (index == 1) {
            // Check if the current route is already ProfileScreen to avoid pushing it multiple times
            if (!(ModalRoute.of(context)?.settings.name == '/profile')) {
              // You'd need to set route names
              Navigator.pushReplacement(
                // Use pushReplacement if you don't want to stack track screens
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfileScreen(selectedTips: selectedTips),
                  settings: const RouteSettings(
                      name: '/profile'), // For route checking
                ),
              );
            }
          }
          // If index == 0 (TrackScreen), do nothing as we are already here.
        },
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';


import 'package:my_new_sustain_app/screens/Homepages/GreenTips_screen.dart';
import 'package:my_new_sustain_app/screens/Homepages/Profile_Screen.dart';
import 'package:intl/intl.dart';

// Assuming this has the GreenTip class

class TrackScreen extends StatelessWidget {
  final List<GreenTip> selectedTips;

  TrackScreen({required this.selectedTips});

  @override
  Widget build(BuildContext context) {
    int completedCount = selectedTips.where((tip) => tip.isSelected).length;
    double progress =
        selectedTips.isNotEmpty ? completedCount / selectedTips.length : 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Track Today\'s Green Wins',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Tag
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.yellow.shade600,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '🌞 Today: ${DateFormat('d MMMM').format(DateTime.now())}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Tips Completed:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            // List of tips with checkboxes
            Expanded(
              child: ListView.builder(
                itemCount: selectedTips.length,
                itemBuilder: (context, index) {
                  final tip = selectedTips[index];
                  return CheckboxListTile(
                    title: Text(tip.title),
                    value: tip.isSelected,
                    onChanged: (_) {}, // Disabled here – use setState if needed
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
              ),
            ),

            // Progress note
            Text(
              "You're ${(progress * 100).round()}% there — small steps, big impact! 🌍",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                    selectedTips: selectedTips), // Replace 'tips' if needed
              ),
            );
          }
          // If you want index 0 (main screen), you can also handle it here if needed
        },
      ),
    );
  }
}
*/
