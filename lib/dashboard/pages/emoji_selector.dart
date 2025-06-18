import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:bitsure/utils/customutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../utils/theme.dart';

class EmojiSelectorScreen extends StatefulWidget {
  final String address;
  const EmojiSelectorScreen({super.key, required this.address});

  @override
  State<EmojiSelectorScreen> createState() => _EmojiSelectorScreenState();
}

class _EmojiSelectorScreenState extends State<EmojiSelectorScreen> {
  String? selectedEmoji;
  String? storedEmojiToken; // Store the full token here
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

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
  void initState() {
    super.initState();
    loadStoredEmojiToken();
  }

  Future<void> loadStoredEmojiToken() async {
    final token = await secureStorage.read(key: 'emoji_token');
    if (token != null) {
      setState(() {
        storedEmojiToken = token;
      });
    }
  }

  Future<void> sendEmojiAndAddress(String emoji, String address) async {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    final url = Uri.parse('$baseUrl/emoji-token/encode/');
    final payload = {'emoji': emoji, 'address': address};
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data.containsKey('emoji_alias')) {
          final emojiAlias = data['emoji_alias'];
          await secureStorage.write(key: 'emoji_token', value: emojiAlias);

          setState(() {
            storedEmojiToken = emojiAlias;
          });

          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$emoji Ready to share!')));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Token not found in response")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    }
  }

  Future<void> copyStoredTokenToClipboard({bool copyOnlyEmoji = false}) async {
    final hiddenToken = await secureStorage.read(key: 'emoji_token');
    if (hiddenToken == null) return;

    // Extract the emoji prefix
    String emoji = '';
    for (String knownEmoji in emojis) {
      if (hiddenToken.startsWith(knownEmoji)) {
        emoji = knownEmoji;
        break;
      }
    }

    // Copy either the emoji alone or the full token
    final contentToCopy = copyOnlyEmoji ? emoji : hiddenToken;
    await Clipboard.setData(ClipboardData(text: contentToCopy));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            copyOnlyEmoji ? '$emoji copied!' : '$emoji Ready to share!',
          ),
        ),
      );
    }
  }

  void copyEmojiandAddress(String emoji, String address) {
    var pickemoji = encode(emoji, address);
    Clipboard.setData(ClipboardData(text: pickemoji));

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$emoji copied to clipboard!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
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
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const Text(
                    "James Bond, Is that you 😎",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.address,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xfff7f7f7),
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
                            : () => copyEmojiandAddress(
                                selectedEmoji!,
                                widget.address,
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Share Emoji"),
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
