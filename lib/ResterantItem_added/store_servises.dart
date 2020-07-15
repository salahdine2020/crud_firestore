import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/ResterantItem_added/itemlist_modale.dart';
import 'package:food_delivery/ResterantItem_added/reslist_modale.dart';
import 'constant.dart';

class Store {
  final Firestore _firestore = Firestore.instance;

 // final Firestore _firestore2 = Firestore.instance.collection(restsubcoll).document();

  final  res = ResList();
  addResturant(ResList resturant) {
    try {
      _firestore.collection(retecoll).add({
        'namer': resturant.pName,
        'locationr': resturant.pLocation,
        'path': resturant.pImage,
      });
    } catch (e) {
      print(e.toString());
    }
  }
  addItems(ItemList items , documentId) {
    try {
      _firestore.collection(retecoll).document(documentId).collection(restsubcoll).add({
        'namef': items.iName,
        'pricef': items.iPrice,
        'descf': items.idesc,
        'pathf' : items.iPath,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  deleteRest(documentId) {
    _firestore.collection(retecoll).document(documentId).delete();
  }
  deleteItems(documentId1,documentId2) {
    _firestore.collection(retecoll).document(documentId1).collection(restsubcoll).document(documentId2).delete();

  }
  editRest(documentId, ResList resturant) {
    _firestore.collection(retecoll).document(documentId).updateData({
      'namer': resturant.pName,
      'locationr': resturant.pLocation,
    });
  }
  editItems(documentId1, documentId2, ItemList items) {
    var s =_firestore.collection(retecoll).document(documentId1).collection(restsubcoll);
    s.document(documentId2).updateData({
      'namef': items.iName,
      'pricef': items.iPrice,
      'descf': items.idesc,
    });
  }
}
