import 'package:bitsure/onboarding/restorewalletflow/restore_new_code.dart';
import 'package:flutter/material.dart';
import 'package:bdk_flutter/bdk_flutter.dart' as bdk;
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/theme.dart';

class ManualRestoreScreen extends StatefulWidget {
  const ManualRestoreScreen({super.key});

  @override
  State<ManualRestoreScreen> createState() => _ManualRestoreScreenState();
}

class _ManualRestoreScreenState extends State<ManualRestoreScreen> {
  final List<TextEditingController> _controllers =  List.generate(12, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    // Add the listener to the first text field's controller.
    _controllers[0].addListener(_onFirstFieldChanged);
  }
  void _onFirstFieldChanged() {
    final text = _controllers[0].text;
    final words = text.trim().split(RegExp(r'\s+'));
    if (words.length == 12) {
      setState(() {
        for (int i = 0; i < 12; i++) {
          _controllers[i].text = words[i];
        }
      });
    }
  }

  /// Verifies the seed phrase and navigates to the Create PIN screen on success.
  Future<void> _verifyAndProceed() async {
    final bool isAnyFieldEmpty =
        _controllers.any((controller) => controller.text.trim().isEmpty);

    if (isAnyFieldEmpty) {
      customSnackBar("Fields cannot be empty", Colors.redAccent, context);
      return;
    }

    final mnemonicString = _controllers
        .map((controller) => controller.text.trim().toLowerCase())
        .join(' ');

    try {
      await bdk.Mnemonic.fromString(mnemonicString);
      if (!mounted) return;

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const RestoreNewCode()));
    } catch (e) {
      customSnackBar(
          "Invalid seed phrase. Please check your words.", klightbluecolor, context);
    }
  }

  @override
  void dispose() {
    // IMPORTANT: Remove the listener to prevent memory leaks.
    _controllers[0].removeListener(_onFirstFieldChanged);
    // Dispose all controllers
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final boxWidth = (size.width - 72) / 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Restore from Phrase"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Stack(
              alignment: Alignment.center,
              children: [
                customcontainer(
                  180,
                  size.width * 0.9,
                  const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/vector2.png'),
                        fit: BoxFit.contain),
                  ),
                  const SizedBox(),
                ),
                Positioned(
                  top: 35,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage('assets/meme9.png'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Import Your Wallet',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your 12-word seed phrase in the correct order.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 18,
                children: List.generate(12, (index) {
                  final position = index + 1;
                  return Container(
                    width: boxWidth,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            "$position.",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _controllers[index],
                            textAlign: TextAlign.left,
                            decoration: const InputDecoration(
                              hintText: 'Word',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(bottom: 2.0),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 70),
            custombuttons(
              40,
              size.width * 0.9,
              BoxDecoration(
                color: klightbluecolor,
                borderRadius: BorderRadius.circular(30),
              ),
              _verifyAndProceed,
              const Center(
                child: Text(
                  "Import Wallet",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}
