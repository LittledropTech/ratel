import 'package:bitsure/dashboard/pages/dashboard.dart';
import 'package:bitsure/gen/assets.gen.dart';
import 'package:bitsure/onboarding/screens/backupscreen.dart';
import 'package:bitsure/provider/backup_logic_provider.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/textstyle.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllBagsscreen extends StatefulWidget {
  const AllBagsscreen({super.key});

  @override
  State<AllBagsscreen> createState() => _AllBagsscreenState();
}

class _AllBagsscreenState extends State<AllBagsscreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kbackupcolor,
        centerTitle: true,
        title: Text('All your bags'),
      ),
      backgroundColor: kbackupcolor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: custombuttons(
                      70,
                      size.width / 0.9,
                      BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: kblackcolor,
                            spreadRadius: 0.5,
                            blurRadius: 0.5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        color: kwhitecolor,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      () async {
                        Navigator.pop(context);
                      },
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Image.asset(
                                      Assets.meme1.path,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text('Main Wallet 1', style: vbacktextstyle),
                            ],
                          ),

                          Padding(
                            padding: EdgeInsets.only(right: 12.0),
                            child: InkWell(
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
