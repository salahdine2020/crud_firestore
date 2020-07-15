import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/ResterantItem_added/addresturant.dart';
import 'package:food_delivery/ResterantItem_added/items_screen.dart';
import 'package:food_delivery/ResterantItem_added/store_servises.dart';


import 'constant.dart';

class RestItems extends StatefulWidget {


  @override
  _RestItemsState createState() => _RestItemsState();
}

class _RestItemsState extends State<RestItems> {
  List<RestItems> li = [];
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resturants Board'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddResInf(),
                  ),
                );
              }),
          IconButton(icon: Icon(Icons.info), onPressed: () {
            //print(widget.urlp);
          }),
        ],
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection(retecoll).snapshots(),
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
                        title: Text(document['namer'] !=null ? document['namer']: null ),
                        subtitle: Text(document['locationr'] != null ? document['locationr']  : null),
                        leading: Image.network(document['path']),
                        trailing: Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // do delet code
                                _store.deleteRest(document.documentID);
                              },
                            ),
                          ],
                        ),
                        onLongPress: () {
                          // code to update the resturant informations
                          //print('clicked');
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => UpdaeRes(
//                                dc: document.documentID,
//                              ),
//                            ),
//                          );
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodItem(
                                dc: document.documentID,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
            }
          },
        ),
      ),
    );
  }
}
