import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:my_new_sustain_app/screens/Homepages/GreenTips_screen.dart';

class ChatbotScreen extends StatefulWidget {
  final Function(String message)? onSendMessage;

  const ChatbotScreen({super.key, this.onSendMessage});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();

  List<String> messages = []; // ✅ Fixed: added messages list

  String _generatedTips = '';
  bool _loading = false;

  final String _apiKey = 'AIzaSyDr2RKA_3zysW5CfYSY_BQLsGcEH4EklEM';

  Future<void> generateGreenTips() async {
    setState(() {
      _loading = true;
      _generatedTips = '';
    });

    final model = GenerativeModel(model: "gemini-2.0-flash", apiKey: _apiKey);
    final selectedInterests = _controller.text.trim();
    final userRoutine = _controller.text.trim();

    final prompt = '''
Based on the user daily routine, generate precise 3-7 personalized eco-friendly "green tips" to help the user reduce their carbon footprint and live more sustainably.

Only include the tips in the response.Tips should be in following format:
"category1,title1,description1;category2,title2,description2;"
such as"Travel,Use Public Transport,Opt for buses or trains to reduce carbon footprint.;"
    
User Preferences has these interests: "$selectedInterests"
User Daily Routine is: $userRoutine
Generate some green tips. Remember: response should only generate tips, nothing else!

    ''';
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      setState(() {
        _generatedTips = response.text ?? 'No tips generated.';
        messages.add("Gemini: $_generatedTips");
      });

      // ✅ Navigate to GreenTips screen after getting response
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GreentipsScreen(
            tipsText: _generatedTips,
          ),
        ),
      );

    } catch (e) {
      setState(() {
        _generatedTips = 'Error: $e';
        messages.add("Gemini: Error occurred.");
      });
    }

    setState(() {
      _loading = false;
    });
  }

  void sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add("You: $text");
      });

      widget.onSendMessage?.call(text);
      _controller.clear();

      // Show loading indicator
      setState(() {
        messages.add("Gemini: Generating your green tips...");
      });



      // ✅ Call Gemini API
      generateGreenTips();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Your Daily Routine",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(messages[index]),
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Write your answer",
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      sendMessage(); // ✅ Fixed: removed broken line and only send message
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
