import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_new_sustain_app/screens/Homepages/GreenTips_screen.dart';
import 'package:my_new_sustain_app/screens/Login and Signup/SignIn.dart';

Color _getCategoryColorForProfileScreen(String category) {
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
    case 'shopping':
      return Colors.pink.shade400;
    case 'general':
      return Colors.brown.shade400;
    default:
      return Colors.blueGrey;
  }
}

class ProfileScreen extends StatelessWidget {
  final List<GreenTip> selectedTips;

  const ProfileScreen({super.key, required this.selectedTips});

  // Fixed list of all possible categories
  List<String> get activeCategories {
    return selectedTips
        .map((tip) => tip.category.toLowerCase().trim())
        .toSet()
        .toList()
      ..sort(); // optional sorting
  }

  double _calculateCategoryProgress(String category) {
    final categoryTips = selectedTips.where(
      (tip) =>
          tip.category.toLowerCase().trim() == category.toLowerCase().trim(),
    );

    if (categoryTips.isEmpty) return 0.0;

    final completedInCategory =
        categoryTips.where((tip) => tip.isSelected).length;
    return completedInCategory / categoryTips.length;
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Signin()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error signing out: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error signing out: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String fullName = user?.displayName ?? "Eco Warrior";
    String email = user?.email ?? "No email";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'My Profile & Progress',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green.shade100,
                child: Text(
                  fullName.isNotEmpty ? fullName[0].toUpperCase() : "EW",
                  style: TextStyle(fontSize: 40, color: Colors.green.shade700),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                fullName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Green Stats Overview',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Show progress bars for all possible categories
              ...activeCategories.map((category) {
                return _buildStatBar(
                  category,
                  _calculateCategoryProgress(category),
                  _getCategoryColorForProfileScreen(category),
                );
              }).toList(),

              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Log Out',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () => _signOut(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label[0].toUpperCase() + label.substring(1), // Capitalize label
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 12,
                    backgroundColor: color.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${(value * 100).round()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';
// // Ensure GreenTip is accessible. If it's in GreentipsScreen.dart, this import is correct.
// import 'package:my_new_sustain_app/screens/Homepages/GreenTips_screen.dart';
// import 'package:my_new_sustain_app/screens/Login%20and%20Signup/SignIn.dart'; // Ensure this path is correct

// // Helper function for category colors (consistent with other screens)
// // In a real app, you might put this in a shared utility file.
// Color _getCategoryColorForProfileScreen(String category) {
//   switch (category.toLowerCase().trim()) {
//     case 'home':
//       return Colors.teal;
//     case 'travel':
//     case 'transport':
//       return Colors.indigo;
//     case 'food':
//       return Colors.orange.shade700;
//     case 'work':
//       return Colors.purple.shade400;
//     case 'water':
//       return Colors.lightBlue.shade600;
//     case 'energy':
//       return Colors.amber.shade700;
//     default:
//       return Colors.blueGrey; // A default color for any other categories
//   }
// }

// class ProfileScreen extends StatelessWidget {
//   final List<GreenTip> selectedTips;

//   const ProfileScreen({super.key, required this.selectedTips});

//   double _calculateCategoryProgress(String category) {
//     // Ensure case-insensitive comparison for category matching
//     final categoryTips = selectedTips.where((tip) =>
//         tip.category.toLowerCase().trim() == category.toLowerCase().trim());
//     if (categoryTips.isEmpty) return 0.0;
//     final completed = categoryTips.where((tip) => tip.isSelected).length;
//     return completed / categoryTips.length;
//   }

//   // Function to log out user
//   Future<void> _signOut(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       // Navigate to Signin screen and remove all previous routes
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => const Signin()),
//         (Route<dynamic> route) => false, // This predicate removes all routes
//       );
//     } catch (e) {
//       // Handle potential errors during sign out, e.g., show a SnackBar
//       print("Error signing out: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error signing out: ${e.toString()}")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     String fullName = user?.displayName ?? "Eco Warrior"; // Fallback name
//     String email = user?.email ?? "No email"; // Fallback email

//     // Dynamically get unique categories from the selectedTips
//     // Use a Set to store unique category names, then convert to List and sort if needed
//     final List<String> uniqueCategories = selectedTips
//         .map((tip) => tip.category)
//         .toSet() // Gets unique category strings
//         .toList();
//     uniqueCategories.sort(); // Optional: sort categories alphabetically

//     return Scaffold(
//       backgroundColor:
//           Colors.grey[100], // Light grey background for better contrast
//       appBar: AppBar(
//         title: const Text(
//           'My Profile & Progress', // Updated title
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 1,
//         // Add a settings icon or other actions if needed
//         // actions: [
//         //   IconButton(icon: Icon(Icons.settings, color: Colors.black), onPressed: () {}),
//         // ],
//       ),
//       body: SingleChildScrollView(
//         // Added SingleChildScrollView for longer content
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 20),
//               CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.green.shade100,
//                 child: Text(
//                   fullName.isNotEmpty
//                       ? fullName[0].toUpperCase()
//                       : "EW", // Initials
//                   style: TextStyle(fontSize: 40, color: Colors.green.shade700),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 fullName,
//                 style:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 email,
//                 style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
//               ),
//               const SizedBox(height: 30),
//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'My Green Stats Overview', // Slightly updated text
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18, // Increased font size
//                       color: Colors.black87),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // Dynamically build stat bars for each unique category
//               if (uniqueCategories.isNotEmpty)
//                 ...uniqueCategories.map((category) {
//                   return _buildStatBar(
//                     category,
//                     _calculateCategoryProgress(category),
//                     _getCategoryColorForProfileScreen(category),
//                   );
//                 }).toList()
//               else
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 20.0),
//                   child: Text(
//                     "No tips are being tracked yet to show stats.",
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),

//               const SizedBox(height: 30), // Add some space before the button
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.logout, color: Colors.white),
//                 label: const Text(
//                   'Log Out',
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//                 onPressed: () => _signOut(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent, // Slightly different red
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12), // More rounded
//                   ),
//                   minimumSize:
//                       const Size(double.infinity, 50), // Make button full width
//                 ),
//               ),
//               const SizedBox(height: 20), // Bottom padding
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatBar(String label, double value, Color color) {
//     return Padding(
//       padding:
//           const EdgeInsets.symmetric(vertical: 8), // Adjusted vertical padding
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//           ),
//           const SizedBox(height: 6),
//           Row(
//             children: [
//               Expanded(
//                 child: ClipRRect(
//                   borderRadius:
//                       BorderRadius.circular(8), // Slightly less rounded
//                   child: LinearProgressIndicator(
//                     value: value,
//                     minHeight: 12, // Increased height
//                     backgroundColor: color.withOpacity(
//                         0.2), // Lighter background based on category color
//                     valueColor: AlwaysStoppedAnimation<Color>(color),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 '${(value * 100).round()}%',
//                 style: TextStyle(
//                     fontSize: 14, fontWeight: FontWeight.bold, color: color),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:my_new_sustain_app/screens/Homepages/GreenTips_screen.dart';
// import 'package:my_new_sustain_app/screens/Login%20and%20Signup/SignIn.dart';

// class ProfileScreen extends StatelessWidget {
//   final List<GreenTip> selectedTips;

//   const ProfileScreen({super.key, required this.selectedTips});

//   double _calculateCategoryProgress(String category) {
//     final categoryTips = selectedTips.where((tip) => tip.category == category);
//     if (categoryTips.isEmpty) return 0.0;
//     final completed = categoryTips.where((tip) => tip.isSelected).length;
//     return completed / categoryTips.length;
//   }

//   // Function to log out user
//   Future<void> _signOut(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const Signin()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ✅ Get current user
//     User? user = FirebaseAuth.instance.currentUser;
//     String fullName =
//         user?.displayName ?? "Your Name"; // fallback if no name set

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'My Profile',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 1,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 20),
//           Text(
//             fullName, // ✅ Use full name here
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//           ),
//           const SizedBox(height: 30),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'My Stats Overview',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           _buildStatBar(
//               'Home', _calculateCategoryProgress('Home'), Colors.green),
//           _buildStatBar(
//               'Travel', _calculateCategoryProgress('Travel'), Colors.blue),
//           _buildStatBar('Food', _calculateCategoryProgress('Food'), Colors.red),
//           const Spacer(),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: () => _signOut(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text(
//                 'Log Out',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatBar(String label, double value, Color color) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label),
//           const SizedBox(height: 4),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: LinearProgressIndicator(
//               value: value,
//               minHeight: 10,
//               backgroundColor: Colors.grey.shade300,
//               valueColor: AlwaysStoppedAnimation<Color>(color),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text('${(value * 100).round()}% completed',
//               style: const TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }
