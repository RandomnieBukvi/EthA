import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_go/constans.dart';
import 'package:lets_go/shared_prefs.dart';
import 'package:lets_go/Utils.dart';
import 'package:firebase_database/firebase_database.dart';

class Register extends StatefulWidget {
  const Register({Key? key, required Function this.changeReg})
      : super(key: key);

  final Function changeReg;
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isLoading = false;
  bool isCheked = true;
  bool isUsernameCorrect = true;
  bool isEmailCorrect = true;
  bool isPasswordCorrect = true;
  bool isPassword2Correct = true;

  var userName = TextEditingController();
  var eMail = TextEditingController();
  var passWord = TextEditingController();
  var passWord2 = TextEditingController();

  var databseInstance = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    var ref = databseInstance.ref();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'EthA',
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: userName,
                  onChanged: (text) {
                    if (text.length < 2) {
                      setState(() {
                        isUsernameCorrect = false;
                      });
                    } else {
                      setState(() {
                        isUsernameCorrect = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    label: Text('Username'),
                    floatingLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        style: BorderStyle.none,
                        width: 0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Color(0xffff0000),
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Color(0xffff0000),
                        width: 2,
                      ),
                    ),
                    errorText: isUsernameCorrect || userName.text.isEmpty
                        ? null
                        : "Type 2 or more symbols",
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                TextField(
                  controller: eMail,
                  onChanged: (text) {
                    if (!text.contains('@')) {
                      setState(() {
                        isEmailCorrect = false;
                      });
                    } else {
                      setState(() {
                        isEmailCorrect = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    label: const Text('Email'),
                    floatingLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        style: BorderStyle.none,
                        width: 0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Color(0xffff0000),
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Color(0xffff0000),
                        width: 2,
                      ),
                    ),
                    errorText: isEmailCorrect || eMail.text.isEmpty
                        ? null
                        : "Type correct email",
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                TextField(
                  controller: passWord,
                  onChanged: (text) {
                    if (text.length < 8) {
                      setState(() {
                        isPasswordCorrect = false;
                      });
                    } else {
                      setState(() {
                        isPasswordCorrect = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    label: const Text('Password'),
                    floatingLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        style: BorderStyle.none,
                        width: 0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Color(0xffff0000),
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Color(0xffff0000),
                        width: 2,
                      ),
                    ),
                    errorText: isPasswordCorrect || passWord.text.isEmpty
                        ? null
                        : "Type 8 or more symbol",
                  ),
                  obscuringCharacter: '*',
                  obscureText: isCheked,
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                TextField(
                  controller: passWord2,
                  onChanged: (text) {
                    if (text.length < 8) {
                      setState(() {
                        isPassword2Correct = false;
                      });
                    } else {
                      setState(() {
                        isPassword2Correct = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    label: const Text('Repeat password'),
                    floatingLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        style: BorderStyle.none,
                        width: 0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Color(0xffff0000),
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Color(0xffff0000),
                        width: 2,
                      ),
                    ),
                    errorText: isPassword2Correct || passWord2.text.isEmpty
                        ? null
                        : "Type 8 or more symbols",
                  ),
                  obscuringCharacter: '*',
                  obscureText: isCheked,
                ),
                Row(children: [
                  Checkbox(
                    value: isCheked,
                    onChanged: (value) {
                      setState(() {
                        isCheked = !isCheked;
                      });
                    },
                  ),
                  const Text('Hide password'),
                ]),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isLoading == false) {
                          setState(() {
                            isLoading = true;
                          });
                          print(
                              '${userName.text} & ${passWord.text} / ${passWord2.text}');
                          ScaffoldMessenger.of(context).clearSnackBars();
                          var event = await ref
                              .child("usernames/${userName.text.trim()}")
                              .once();
                          if (event.snapshot.exists) {
                            Utils.showDialogCustom(
                                context: context,
                                title: 'Oops!',
                                content:
                                    'User with this username alredy exist');
                          } else if (userName.text.isNotEmpty &&
                              isUsernameCorrect &&
                              eMail.text.isNotEmpty &&
                              isEmailCorrect &&
                              passWord.text.isNotEmpty &&
                              isPasswordCorrect &&
                              (passWord.text == passWord2.text)) {
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: eMail.text.trim(),
                                password: passWord.text.trim(),
                              )
                                  .then((uC) {
                                uC.user!
                                    .updateDisplayName(userName.text.trim());
                                ref
                                    .child('usernames')
                                    .child(userName.text.trim())
                                    .set(uC.user!.email);
                                ref
                                    .child('usersData')
                                    .child(userName.text.trim())
                                    .set({
                                  'experience' : 0,
                                  'level' : 1,
                                  'cash' : 0,
                                  'inventory' : {
                                    '1' : {
                                      'level' : 0
                                    },
                                    '2' : {
                                      'level' : 0
                                    }
                                  }
                                });
                              });
                              return;
                            } on FirebaseAuthException catch (e) {
                              Utils.showDialogCustom(
                                  context: context,
                                  title: 'Oops!',
                                  content: e.message.toString());
                            }
                          } else if (userName.text.isEmpty ||
                              eMail.text.isEmpty ||
                              passWord.text.isEmpty ||
                              passWord2.text.isEmpty) {
                            Utils.showSnackBar(
                                context: context,
                                text: 'There are some empty fields!',
                                color: Color(0xffff0000));
                          } else if (passWord.text != passWord2.text) {
                            Utils.showSnackBar(
                                context: context,
                                text: "Passwords don\'t match!",
                                color: Color(0xffff0000));
                          } else {
                            Utils.showSnackBar(
                                context: context,
                                text: "Please, fulfill the requirements!",
                                color: Color(0xffff0000));
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: kTextWhiteColor))
                          : const Text('Register'),
                    )),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    print('login');
                    widget.changeReg();
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 17,
                        color: kSecondaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    eMail.dispose();
    passWord2.dispose();
    passWord.dispose();
    userName.dispose();
    super.dispose();
  }

  Future register() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: eMail.text.trim(),
      password: passWord.text.trim(),
    );
  }
}
