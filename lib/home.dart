import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  //final Geolocator geolocator = Geolocator();
  //final ImagePicker _picker = ImagePicker();

  Future<void> _getCurrentPosition() async {
    // verify permissions

    CollectionReference positions =
        FirebaseFirestore.instance.collection('positions');

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
    }

    Position _currentPosition;
    // get current position
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    /*positions.add({
      'location': _currentPosition,
    });*/

    positions.add({
      'latitude': _currentPosition.latitude,
      'longitude': _currentPosition.longitude,
    });

    // get address
  }

  CollectionReference _telephones =
      FirebaseFirestore.instance.collection('telephones');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'ajout';
    if (documentSnapshot != null) {
      action = 'modification';
      _nomController.text = documentSnapshot['nom'];
      _prixController.text = documentSnapshot['prix'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        elevation: 20,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: const EdgeInsets.all(60.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nomController,
                  decoration: InputDecoration(labelText: 'nom'),
                ),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _prixController,
                  decoration: InputDecoration(
                    labelText: 'prix',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  textColor: Colors.white,
                  color: Colors.pink,
                  onPressed: () {
                    _imagePicker();
                  },
                  child: Text("Select Image"),
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  textColor: Colors.white,
                  color: Colors.pink,
                  onPressed: () {
                    _getCurrentPosition();
                  },
                  child: Text("votre position"),
                ),
                ElevatedButton(
                  child: Text(action == 'ajout' ? 'ajout' : 'modifier'),
                  onPressed: () async {
                    final String? nom = _nomController.text;
                    final double? prix = double.tryParse(_prixController.text);
                    if (nom != null && prix != null) {
                      if (action == 'ajout') {
                        await _telephones.add({"nom": nom, "prix": prix});
                      }

                      if (action == 'modifier') {
                        await _telephones
                            .doc(documentSnapshot!.id)
                            .update({"nom": nom, "prix": prix});
                      }

                      _nomController.text = '';
                      _prixController.text = '';

                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _deleteProduct(String productId) async {
    await _telephones.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('vous avez supprimer une commende')));
  }

  _imagePicker() async {
    File imagefile;
    //final fileName = imagefile !=null ? basename(file!.path)
    //final String path;
    final String destination;
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      imagefile = File(photo.name);
      destination = 'files/$imagefile';
      final ref = FirebaseStorage.instance.ref(destination);
      ref.putFile(imagefile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _telephones.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  elevation: 8,
                  shadowColor: Colors.blueAccent,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    title: Text(documentSnapshot['nom']),
                    subtitle: Text(documentSnapshot['prix'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: Icon(Icons.add),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
      ),
    );
  }
}
