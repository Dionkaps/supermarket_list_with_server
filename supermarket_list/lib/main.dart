import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.pink,
    ),
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  createSuperListEl() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("SupermarketList").doc(input);

    Map<String, String> superList = {"Itemtitle": input};

    documentReference.set(superList).whenComplete(() {
      print("$input Created");
    });
  }

  deleteSuperListEl(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("SupermarketList").doc(item);

    documentReference.delete().whenComplete(() {
      print("Deleted");
    });
  }

  String input = "";
  TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("SuperMarket"),
          backgroundColor: Colors.pink[600],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 35.0),
          child: FloatingActionButton(
            backgroundColor: Colors.pink,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      elevation: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: const Text('Add'),
                      content: TextField(
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Add new item',
                          border: InputBorder.none,
                        ),
                        controller: _textFieldController,
                        onChanged: (String value) {
                          input = value;
                        },
                      ),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              _textFieldController.clear();
                              createSuperListEl();

                              //Navigator.of(context).pop(); De nomizw pws einai voliko na prostethei
                            },
                            child: const Text("Add"))
                      ],
                    );
                  });
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("SupermarketList")
              .snapshots(),
          builder: (context, snapshots) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: (snapshots.data)?.docs.length ?? 0,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot =
                    (snapshots.data!).docs[index];
                return Dismissible(
                    onDismissed: (direction) {
                      deleteSuperListEl(documentSnapshot["Itemtitle"]);
                    },
                    key: Key(documentSnapshot["Itemtitle"]),
                    child: Card(
                      elevation: 3,
                      margin: const EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        title: Text(documentSnapshot["Itemtitle"]),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            setState(() {
                              deleteSuperListEl(documentSnapshot["Itemtitle"]);
                            });
                          },
                        ),
                      ),
                    ));
              },
            );
          },
        ));
  }
}
