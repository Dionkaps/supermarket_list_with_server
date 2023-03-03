import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
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
  @override
  void initState() {
    super.initState();
    supermarket.add("Item 1");
    supermarket.add("Item 2");
    supermarket.add("Item 3");
    supermarket.add("Item 4");
  }

  var supermarket = List<String>.empty(growable: true);
  String input = "";
  TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Nai poios einai"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    elevation: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text('Add new Item'),
                    content: TextField(
                      controller: _textFieldController,
                      onChanged: (String value) {
                        input = value;
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            _textFieldController.clear();
                            setState(() {
                              supermarket.add(input);
                            });
                            
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
        body: ListView.builder(
          itemCount: supermarket.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(supermarket[index]),
                child: Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    title: Text(supermarket[index]),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          supermarket.removeAt(index);
                        });
                      },
                    ),
                  ),
                ));
          },
        ));
  }
}
