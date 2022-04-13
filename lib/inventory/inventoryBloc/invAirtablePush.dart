import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AirtableAPI {

  Future pushImage(List images, String price, User? user) async {

    String secret = '';
    String apiKey = '';
    String table = '';

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then((doc) {
      secret = (doc.data() as dynamic)['airtablesecret'];
      apiKey = (doc.data() as dynamic)['airtableAPIKey'];
      table = (doc.data() as dynamic)['airtableTable'];
    });


    var map = images.map((url) => { 'url': url }).toList();

    String url = 'https://api.airtable.com/v0/$secret/$table';
    Map<String, String> header = {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'};
    
    var data = {
      "fields": {
        "Pictures": map,
          "Variation": "Original",
          "Price": double.parse(price),
      } 
    };
    print('FINAL JSON: ${json.encode(data)}');
    http.Response res = await http.post(Uri.parse(url), headers: header, body: json.encode(data));
    print('Response Code: ${res.statusCode}');
    print(res.headers);
    print(res.body);
  }
}