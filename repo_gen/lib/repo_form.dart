import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RepoForm extends StatefulWidget{
  const RepoForm({super.key, required this.id});

  final int id;
  
  State<RepoForm> createState() => _MyRepoFormState();
}

class _MyRepoFormState extends State<RepoForm> {
  late Future<Map<String, dynamic>> courseData;

  // GET data for requested course
  Future<Map<String, dynamic>> getCourseData(int id) async {
    var url = Uri.http('10.100.100.29:8080', '/api/courses');
    var response = await http.get(url,
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "content-type": "application/json",
        "Accept": "*/*"
      }
    );
    if(kDebugMode){
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    if(response.statusCode == 200){
      var jsonResponse = jsonDecode(response.body);
      if(kDebugMode){
        print(jsonResponse[0]['coursename']);
      }
      return jsonResponse[id];
    }
    return {};
  }

  @override
  void initState() {
    super.initState();
    courseData = getCourseData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Repo Generation Form'),
      ),
      body: FutureBuilder<Map>(
        future: courseData,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData){
            final data = snapshot.data!;
            if(kDebugMode){
              print(data);
            }
            return Text(data['coursename']);
          } else {
            return const Text('No data available');
          }
        },
      )
    );
  }
}