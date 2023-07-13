import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );
  runApp(MaterialApp(debugShowCheckedModeBanner: false,home: Home(),));
}
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  String ver_id="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OTP verification"),),
      body: Column(children: [
      Card(
        margin: EdgeInsets.all(5),
          color: Colors.grey,
          child: TextField(controller: t1,keyboardType: TextInputType.number,decoration: InputDecoration(hintText: "Enter Mobaile"),)),

        ElevatedButton(onPressed: () async {
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: '+91 ${t1.text}',
            verificationCompleted: (PhoneAuthCredential credential) async {
              await auth.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              if (e.code == 'invalid-phone-number') {
                print('The provided phone number is not valid.');
              }
            },
            codeSent: (String verificationId, int? resendToken) {
              ver_id=verificationId;
              setState(() {

              });

            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );

        }, child: Text("Send OTP")),
        Card(
            margin: EdgeInsets.all(5),
            color: Colors.grey,
            child: TextField(controller: t2,keyboardType: TextInputType.number,decoration: InputDecoration(hintText: "Enter OTP"),)),

        ElevatedButton(onPressed: () async {
          String smsCode = '${t2.text}';

          // Create a PhoneAuthCredential with the code
          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: ver_id, smsCode: smsCode);

          // Sign the user in (or link) with the credential
          await auth.signInWithCredential(credential).then((value) {
            print(value);
          });

        }, child: Text("Verify OTP")),

      ],),
    );
  }
}
