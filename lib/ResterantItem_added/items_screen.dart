import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/ResterantItem_added/additems.dart';
import 'package:food_delivery/ResterantItem_added/addresturant.dart';
import 'package:food_delivery/ResterantItem_added/store_servises.dart';
import 'constant.dart';

class FoodItem extends StatefulWidget {

  String dc;

  FoodItem({
    this.dc,
  });

  @override
  _FoodItemState createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items Board'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddResItems(dc: widget.dc,),
                  ),
                );
              }),
          IconButton(icon: Icon(Icons.info), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection(retecoll)
                .document(widget.dc)
                .collection(restsubcoll)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  return new ListView(
                    children:
                        snapshot.data.documents.map((DocumentSnapshot document) {
                      return Card(
                        color: Colors.yellowAccent,
                        child: ListTile(
                          title: Text(document['namef']),
                          subtitle: Text(document['pricef']),
                          leading: Image.network(document['pathf']),
                          trailing: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // do delet code
                                  //_store.deleteRest(document.documentID);
                                  // delet frome items
                                 _store.deleteItems(widget.dc, document.documentID);
                                },
                              ),
                            ],
                          ),
                          onLongPress: () {
                            // code to update the resturant informations
                            //print('clicked');
//                          Navigator.pushReplacement(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => UpdaeItems(dc: widget.dc,dc1: document.documentID,),
//                            ),
//                          );
//                          print(document.documentID);
                          },
                        ),
                      );
                    }).toList(),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
