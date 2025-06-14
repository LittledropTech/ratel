import 'package:bitsure/utils/textstyle.dart';
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
