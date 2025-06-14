import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';

class Restorewalletvalidatescreen extends StatefulWidget {
   final String subpagetext;
  final String  pagetext ;
  final String text;
  
   Restorewalletvalidatescreen({super.key, required this.subpagetext, required this.pagetext, required this.text,});

  @override
  State<Restorewalletvalidatescreen> createState() => _RestorewalletvalidatescreenState();
}

class _RestorewalletvalidatescreenState extends State<Restorewalletvalidatescreen> {
   final _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  final passwordRegex = RegExp(
    r'^(?=.*[0-9])(?=.*[!@#\$&*~])[A-Za-z0-9!@#\$&*~]{8}$',
  );

  void _validateAndProceed() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _passwordController.text);

     
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(backgroundColor: kwhitecolor),
      backgroundColor: kwhitecolor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Images
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      customcontainer(
                        200,
                        size.width / 1.2,
                        const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/vector3.png'),
                          ),
                        ),
                        const SizedBox(),
                      ),
                      Positioned(
                        left: 4,
                        top: 5,
                        child: customcontainer(
                          200,
                          size.width / 1.2,
                          const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/meme5.png'),
                            ),
                          ),
                          const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Text( widget.pagetext,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
               Text(
                widget.subpagetext,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 45),

              // Password field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  maxLength: 8,
                  controller: _passwordController,
                  obscureText: obscureText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    } else if (!passwordRegex.hasMatch(value)) {
                      return "Please enter an 8-character password with at least\n1 number and 1 special character";
                    } else if (value.length < 8) {
                      return "Your password is not up to 8 characters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    hintText: 'Password',
                    border: const OutlineInputBorder(),
                    counterText: '', 
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Confirm password field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  maxLength: 8,
                  controller: _confirmController,
                  obscureText: obscureText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    } else if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Confirm password',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
              ),

              const SizedBox(height: 150),
              custombuttons(40, size.width/1.4, BoxDecoration(
                color: klightbluecolor,
                borderRadius: BorderRadius.circular(20)
              ),_validateAndProceed , Center(
                child: 
                Text(widget.text),
              ))
            ],
          ),
        ),
      ),
    );
  }
}