import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';

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

customSnackBar(String text, Color colors, BuildContext context) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(text), backgroundColor: colors));
}
