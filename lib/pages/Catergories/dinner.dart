import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_tracker/pages/Catergories/breakfast.dart';
import 'package:food_tracker/services/firebase.dart';

class Food {
  String name;
  int calories;

  Food({required this.name, required this.calories});
}

class Dinner extends StatefulWidget {
  const Dinner({Key? key}) : super(key: key);

  @override
  _DinnerState createState() => _DinnerState();
}

class _DinnerState extends State<Dinner> {
  List<Food> entries = <Food>[];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dinner"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(""),
              FutureBuilder(
                  future:
                      firestoreServices.getCollections("users", uid, "Dinner"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final QuerySnapshot<Map<String, dynamic>> collectionData =
                          snapshot.data as QuerySnapshot<Map<String, dynamic>>;
                      final List<QueryDocumentSnapshot> data =
                          collectionData.docs;
                      return ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                              left: 30, top: 100, right: 30, bottom: 20),
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              tileColor: Colors.orange[400],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: Text("Qty"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Text("QTY:"),
                                                Card(
                                                  elevation: 5.0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0)),
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                          splashRadius: 15.0,
                                                          onPressed: () {},
                                                          icon: Icon(
                                                              Icons.remove)),
                                                      Text("1"),
                                                      IconButton(
                                                          splashRadius: 15.0,
                                                          onPressed: () {},
                                                          icon:
                                                              Icon(Icons.add)),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                "Ok",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1,
                                              ))
                                        ],
                                      );
                                    });
                              },
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    var x = collectionData
                                        .docs[index].reference.id
                                        .toString();
                                    final collection = FirebaseFirestore
                                        .instance
                                        .collection('users')
                                        .doc(uid)
                                        .collection('Dinner');
                                    collection.doc(x).delete();
                                  });
                                },
                                icon: Icon(Icons.delete_outline),
                              ),
                              title: Center(
                                  child: Center(
                                child: Text(
                                  '${(data[index].data() as Map<String, dynamic>)["name"]}',
                                ),
                              )),
                            );
                          });
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelText: "Item Name",
                                        border: OutlineInputBorder()),
                                    controller: _nameController,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelText: "Calories",
                                        border: OutlineInputBorder()),
                                    controller: _caloriesController,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      entries.add(Food(
                                          name: _nameController.text,
                                          calories: int.tryParse(
                                                  _caloriesController.text
                                                      .trim()) ??
                                              0));

                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(uid)
                                          .collection("Dinner")
                                          .doc()
                                          .set({
                                        'name': _nameController.text,
                                        'calories': int.tryParse(
                                            _caloriesController.text)
                                      });
                                    });
                                    _nameController.clear();
                                    _caloriesController.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Text("Save")),
                              TextButton(
                                  onPressed: () {
                                    _nameController.clear();
                                    _caloriesController.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel")),
                            ],
                          );
                        });
                  },
                  child: Text("Add Item"))
            ],
          ),
        ));
  }
}
