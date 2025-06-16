import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/theme.dart';

class EmojiSelectorScreen extends StatefulWidget {
  const EmojiSelectorScreen({super.key});

  @override
  State<EmojiSelectorScreen> createState() => _EmojiSelectorScreenState();
}

class _EmojiSelectorScreenState extends State<EmojiSelectorScreen> {
  String? selectedEmoji;
  final List<String> emojis = [
    "🔔",
    "⚠️",
    "❌",
    "♦️",
    "♣️",
    "🍐",
    "❤️",
    "🚫",
    "😐",
    "😮",
    "😅",
    "😎",
    "😢",
    "🤔",
    "😳",
    "😆",
    "😤",
    "👀",
    "🤠",
    "🧐",
    "🤓",
    "🙃",
    "😇",
    "👨‍🎓",
    "👩‍🎓",
    "😷",
    "🤒",
    "👶",
    "🧒",
    "👧",
    "👦",
    "👨",
    "👩",
    "🧑",
    "👵",
    "👴",
    "🎅",
    "🤶",
    "👼",
    "🧜",
    "🧚",
    "🍓",
    "🍎",
    "🍔",
    "🥤",
    "🍜",
    "☕",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(48)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),

                  // Icon(Icons.close),
                  Text(
                    "James Bond, Is that you 😎",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "gstr27467289834tyghsoiwehjdf",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xfff7f7f7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Select your preferred emoji",
                  textAlign: TextAlign.left,
                ),
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
                          color: isSelected
                              ? Colors.blue[100]
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected
                              ? Border.all(color: Colors.blue, width: 2)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xfff7f7f7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedEmoji != null
                            ? "Copy and share: $selectedEmoji"
                            : "",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.copy),

                      onPressed: selectedEmoji != null
                          ? () {
                              Clipboard.setData(
                                ClipboardData(text: selectedEmoji ?? ""),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Emoji copied!")),
                              );
                            }
                          : null,
                    ),
                  ],
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
                        boxShadow:  [
                          BoxShadow(
                            color: klightbluecolor,
                            offset: Offset(3, 4),
                            blurRadius: 2,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: selectedEmoji == null
                            ? null
                            : () {
                                // Share logic or callback here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Shared: $selectedEmoji"),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Share Emoji", style: TextStyle(color: Colors.white),),
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
