import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:untitled/components/custombuttonauth.dart';
import 'package:untitled/components/customtextformfieldadd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Editcategory extends StatefulWidget {
  final String docid;
  final String oldname;

  const Editcategory({super.key, required this.docid, required this.oldname});

  @override
  State<Editcategory> createState() => _EditcategoryState();
}

class _EditcategoryState extends State<Editcategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool loading = false;

  // ignore: non_constant_identifier_names
  Future<void> Editcategory() async {
    if (formstate.currentState!.validate()) {
      try {
        loading = true;
        setState(() {});
        await categories.doc(widget.docid).update({"name": controller.text});

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
  void initState() {
    controller.text = widget.oldname;
    super.initState();
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
                padding: const EdgeInsets.all(30),
                child: CustomTextFormadd(
                  hinttext: "Enter Name",
                  mycontroller: controller,
                  validator: (val) {
                    if (val == "") {
                      return "Can not be empty";
                    }
                    return null;
                  },
                ),
              ),
              CustomButtonAuth(
                title: 'Save',
                onPressed: () {
                  Editcategory();
                },
              )
            ],
          )),
    );
  }
}
