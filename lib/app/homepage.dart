import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled/app/edit.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool loading = true;
  List<QueryDocumentSnapshot> data = [];
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    await Future.delayed(Duration(seconds: 1));
    data.addAll(querySnapshot.docs);
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).pushNamed("addcategory");
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              try {
                // Handle Google sign-out
                GoogleSignIn googleSignIn = GoogleSignIn();
                if (await googleSignIn.isSignedIn()) {
                  await googleSignIn.disconnect();
                }

                // Handle Firebase log-out
                await FirebaseAuth.instance.signOut();

                // Navigate to the login page
                Navigator.of(context).pushNamedAndRemoveUntil(
                  "login",
                  (route) => false,
                );
              } catch (e) {
                // Handle errors
                print("Error during sign out: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error during sign out: $e")),
                );
              }
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
        title: Text('Homepage'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: data.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onLongPress: () {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            title: 'Warning',
                            desc: 'What do you want to do',
                            btnCancelOnPress: () async {
                              await FirebaseFirestore.instance
                                  .collection('categories')
                                  .doc(data[i].id)
                                  .delete();
                              // ignore: use_build_context_synchronously
                              Navigator.of(context)
                                  .pushReplacementNamed("homepage");
                            },
                            btnOkOnPress: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Editcategory(
                                        docid: data[i].id,
                                        oldname: '${data[i]["name"]}',
                                      )));
                            },
                            btnOkText: 'Edit',
                            btnCancelText: 'delete')
                        .show();
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          //  color: Colors.red,
                          margin: const EdgeInsets.only(bottom: 15),
                          // padding: EdgeInsets.all(15),
                          height: 120,
                          child: Image.asset('images/logo.png'),
                        ),
                        Text("${data[i]["name"]}")
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
