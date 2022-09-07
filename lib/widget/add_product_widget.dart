// aggiungi prodotto
// ignore_for_file: prefer_const_constructors, unnecessary_new, camel_case_types
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:core';
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensa/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;

var nameController = new TextEditingController();
var numberController = new TextEditingController();
var dateController = new TextEditingController();

class addProductClass extends StatefulWidget {
  @override
  _addProductClassState createState() => _addProductClassState();
}

DateTime date = DateTime.now();

class _addProductClassState extends State<addProductClass> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Text('Aggiungi un prodotto',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Nome del prodotto',
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: numberController,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Quantità'),
              )),
          Text('${date.year}-${date.month}-${date.day}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          ElevatedButton(
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));
                if (newDate == null) return;
                setState(() => date = newDate);
              },
              child: Text("Inserisci la data di scadenza")),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: PALETTE_BLUE,
                minimumSize: Size.fromHeight(50), // NEW
              ),
              child: Text('Aggiungi'),
              onPressed: () {
                insertData(
                    nameController.text,
                    int.parse(numberController.text),
                    '${date.year}-${date.month}-${date.day}');
              },
            ),
          )
        ]));
  }
}

void insertData(String name, int number, String expirationDate) {
  db
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid.toString())
      .collection('dispensa')
      .doc(nameController.text)
      .set({
    'name': name,
    'number': number,
    'expirationDate': expirationDate,
  });
}
