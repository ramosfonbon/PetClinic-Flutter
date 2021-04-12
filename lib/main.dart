import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'VetModel.dart';

Future<List<Vet>> fetchVet() async {
  final String jwt = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiJwZXRKV1QiLCJzdWIiOiJ2aWN0b3IiLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwiaWF0IjoxNjE4MjQ5NDIwLCJleHAiOjE2MTgyNTU0MjB9.kphJEkd_21QStdlAUWKzhuBflYJ2FTqN9elgRU51ZOKa-oNFO0PvmHQwVr7qxVODI2Ib_ELMER9ul8iwRZX8tA";


  final response = await http.get(
    Uri.http('192.168.0.117:19000', 'API/vetsJSON'),
    headers: {HttpHeaders.authorizationHeader: jwt },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    
    var l = json.decode(response.body);
    var al = VetList.fromJson(l);
    return al.vets;

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('No se pueden cargar los datos: ' +
          response.statusCode.toString());
  }
}



void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Vet>> futureVet;

  @override
  void initState() {
    super.initState();
    futureVet = fetchVet();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vet API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Vet API'),
        ),
        body: Center(
          child: FutureBuilder<List<Vet>>(
            future: futureVet,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Center(child: CircularProgressIndicator());
              }
             if (snapshot.connectionState == ConnectionState.done
                  && snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }


              if (snapshot.connectionState == ConnectionState.done
                  && snapshot.hasData) {
                return _buildVetList(snapshot);
              }
              //  spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVetList(AsyncSnapshot<List<Vet>> snapshot) {
    return ListView.separated(
        padding: EdgeInsets.all(16.0),
        itemCount: snapshot.data!.length,
        itemBuilder: /*1*/ (context, i) {
          return ListTile(
            title: Text(snapshot.data![i].firstName + ' ' +
                snapshot.data![i].lastName),
            subtitle: Text(snapshot.data![i].id.toString()),
            trailing: Icon(Icons.pets_outlined),

            );
          },
          separatorBuilder: (BuildContext context, int index) {
          return Divider(
            indent: 20,
            endIndent: 20,
            );
          },
    );
  }

}
