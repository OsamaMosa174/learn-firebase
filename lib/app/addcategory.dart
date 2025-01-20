import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/components/custombuttonauth.dart';
import 'package:untitled/components/customtextformfieldadd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Addcategory extends StatefulWidget {
  const Addcategory({super.key});

  @override
  State<Addcategory> createState() => _AddcategoryState();
}

class _AddcategoryState extends State<Addcategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool loading = false;

  Future<void> addcategory() async {
    if (formstate.currentState!.validate()) {
      try {
        loading = true;
        setState(() {});
        await categories
            .add({
              'name': controller.text,
              'id': FirebaseAuth.instance.currentUser!.uid
            })
            .then((value) => print("---------add category----------"))
            .catchError(
                (error) => print("Failed to add user:------ $error-----"));
        Navigator.of(context).pushNamedAndRemoveUntil(
          'homepage',
          (route) => false,
        );
      } catch (e) {
        loading = false;
        AwesomeDialog(
          // ignore: use_build_context_synchronously
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: '${e}',
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: Form(
          key: formstate,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                child: CustomTextFormadd(
                  hinttext: "Enter Name",
                  mycontroller: controller,
                  validator: (val) {
                    if (val == "") {
                      return "Can not be empty";
                    }
                  },
                ),
              ),
              CustomButtonAuth(
                title: 'Add',
                onPressed: () {
                  addcategory();
                },
              )
            ],
          )),
    );
  }
}
