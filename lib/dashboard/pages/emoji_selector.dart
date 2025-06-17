import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/theme.dart';

class EmojiSelectorScreen extends StatefulWidget {
  final String address;
  const EmojiSelectorScreen({super.key, required this.address});

  @override
  State<EmojiSelectorScreen> createState() => _EmojiSelectorScreenState();
}

class _EmojiSelectorScreenState extends State<EmojiSelectorScreen> {
  String? selectedEmoji;

  final List<String> emojis = [
    "🔔", "⚠️", "❌", "♦️", "♣️", "🍐", "❤️", "🚫", "😐", "😮",
    "😅", "😎", "😢", "🤔", "😳", "😆", "😤", "👀", "🤠", "🧐",
    "🤓", "🙃", "😇", "👨‍🎓", "👩‍🎓", "😷", "🤒", "👶", "🧒", "👧",
    "👦", "👨", "👩", "🧑", "👵", "👴", "🎅", "🤶", "👼", "🧜",
    "🧚", "🍓", "🍎", "🍔", "🥤", "🍜", "☕",
  ];

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> sendEmojiAndAddress(String emoji, String address) async {
    final url = Uri.parse('https://test-api-ratle.littledrop.co/api/v1/emoji-token/encode/');
    final payload = {'emoji': emoji, 'address': address};

    debugPrint("Sending POST to $url");
    debugPrint("Payload: ${jsonEncode(payload)}");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data.containsKey('emoji_alias')) {
          final token = data['emoji_alias'];
          await secureStorage.write(key: 'emoji_token', value: token);
          debugPrint("Token saved: $token");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Emoji linked and token saved!")),
          );
        } else {
          debugPrint("No emoji_alias found in response.");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Token not found in response")),
          );
        }
      } else {
        debugPrint("Failed with status code ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 24),
                  ),
                  const Text(
                    "James Bond, Is that you 😎",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 8),
              Text(widget.address, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xfff7f7f7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text("Select your preferred emoji", textAlign: TextAlign.left),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 6,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: emojis.map((emoji) {
                    final isSelected = selectedEmoji == emoji;
                    return GestureDetector(
                      onTap: () => setState(() => selectedEmoji = emoji),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue[100] : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(emoji, style: const TextStyle(fontSize: 24)),
                      ),
                    );
                  }).toList(),
                ),
              ),
             
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: klightbluecolor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(3, 4),
                            blurRadius: 2,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: klightbluecolor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Back to bag"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: klightbluecolor,
                            offset: const Offset(3, 4),
                            blurRadius: 2,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: selectedEmoji == null
                            ? null
                            : () => sendEmojiAndAddress(selectedEmoji!, widget.address),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Share Emoji", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
