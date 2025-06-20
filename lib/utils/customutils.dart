import 'dart:convert';
import 'dart:typed_data';

import 'package:bitsure/utils/textstyle.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

Widget custombuttons(
  double height,
  double width,
  BoxDecoration decoration,
  void Function()? onTap,
  Widget child,
) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height,
      width: width,
      decoration: decoration,
      child: child,
    ),
  );
}

Widget customcontainer(
  double height,
  double width,
  BoxDecoration decoration,
  Widget child,
) {
  return Container(
    height: height,
    width: width,
    decoration: decoration,
    child: child,
  );
}

Widget customStatusIndicator(final bool isActive) {
  return Text(
    isActive ? 'Active' : 'Backup',
    style: TextStyle(
      color: isActive ? kgreencolors : kredcolor,
      fontWeight: FontWeight.bold,
    ),
  );
}

customdialog(BuildContext context, Color color, Widget content, bool dismisal) {
  return showDialog(
    barrierDismissible: dismisal,
    context: context,
    builder: (context) {
      return AlertDialog(backgroundColor: color, content: content);
    },
  );
}

int btcToSats(double btcAmount) {
  return (btcAmount * 100000000).round();
}

double satsToBtc(num sats) {
  return sats / 100000000;
  }

customSnackBar(String text, Color colors, BuildContext context) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(text), backgroundColor: colors));
}

String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final isToday = now.year == dateTime.year &&
      now.month == dateTime.month &&
      now.day == dateTime.day;

  final timeFormat = DateFormat('h:mm a');
  final formattedTime = timeFormat.format(dateTime);

  if (isToday) {
    return 'Today, $formattedTime';
  } else {
    final dateFormat = DateFormat('MMM d, h:mm a'); 
    return dateFormat.format(dateTime);
  }
}
  void launchURL(BuildContext context, url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }

customNetworkErrorDialog(BuildContext context, {String? message}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Network Error"),
        content: Text(
          message ?? "Please check your internet connection and try again.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}


String formatNumber(num? value, {int decimalDigits = 2, bool short = false}) {
  if (value == null) return "--";

  bool hasDecimal = value % 1 != 0;

  if (short) {
    if (!hasDecimal) {
      return NumberFormat.decimalPattern().format(value);
    } else {
      return NumberFormat("0.00").format(value);
    }
  } else {
    return NumberFormat.currency(
      decimalDigits: hasDecimal ? decimalDigits : 0,
      symbol: "",
    ).format(value);
  }
}

customErrorShowMeme(BuildContext context) {
  customdialog(
    context,
    ktransarentcolor,
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customcontainer(
          300,
          800,
          BoxDecoration(
            color: kwhitecolor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 20),
              Text('Wrong'),
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/meme8.png'),
              ),
              SizedBox(height: 20),
              Text('Your finger lies, Try again'),
              Padding(
                padding: const EdgeInsets.all(20),
                child: custombuttons(
                  40,
                  250,
                  BoxDecoration(
                    color: klightbluecolor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  () {
                    Navigator.pop(context);
                  },
                  Center(child: Text('Retry', style: vsubheadingstextstyle)),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    true,
  );
}
customLoader(BuildContext context){
  showDialog(context: context, builder: (context){
    return Center(
      child: CircularProgressIndicator(),
    );
  });
}

String encode(String emoji,String address) {
    final bytesArray = utf8.encode(address);
    final encoded = _encodeEmojiWithVariationSelector(emoji, bytesArray);
    return encoded;
  }

  String decode(String data) {
    final decodedBytesArray = _decodeEmojiWithVariationSelector(data);
    final decoded = utf8.decode(decodedBytesArray);
    return decoded;
  }
  String _encodeEmojiWithVariationSelector(String base, List<int> bytes) {
    final result = StringBuffer();
    result.write(base);
    for (final byte in bytes) {
      result.write(_byteToVariationSelector(byte));
    }
    return result.toString();
  }
  String _byteToVariationSelector(int byte) {
    if (byte < 16) {
      return String.fromCharCode(0xFE00 + byte);
    } else {
      return String.fromCharCode(0xE0100 + (byte - 16));
    }
  }
  int? _variationSelectorToByte(String variationSelector) {
    if (variationSelector.isEmpty) return null;

    final rune = variationSelector.runes.first;
    if (rune >= 0xFE00 && rune <= 0xFE0F) {
      return rune - 0xFE00;
    } else if (rune >= 0xE0100 && rune <= 0xE01EF) {
      return (rune - 0xE0100) + 16;
    }
    return null;
  }
  Uint8List _decodeEmojiWithVariationSelector(String variationSelectors) {
    final result = <int>[];
    bool foundFirstSelector = false;

    for (final char in variationSelectors.runes) {
      final variationSelector = String.fromCharCode(char);
      final byte = _variationSelectorToByte(variationSelector);

      if (byte != null) {
        foundFirstSelector = true;
        result.add(byte);
      } else if (foundFirstSelector) {
        break;
      }
    }

    return Uint8List.fromList(result);
  }

