import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'repo_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Repo Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Chico State Repo Generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<dynamic>> courses;

  // GET all available courses
  Future<List<dynamic>> getCourses() async {
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
      return jsonResponse;
    }
    return List.empty();
  }

  @override
  void initState() {
    super.initState();
    courses = getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: courses,
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if(snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              }
              else{
                //return Text(snapshot.data![0]['coursename']);
                return ListView.builder(
                  padding: const EdgeInsets.all(20.0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index){
                    return Card(
                      shadowColor: Colors.white70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              snapshot.data![index]['program'] + ' ' 
                              + snapshot.data![index]['number'].toString() + ' '
                              + snapshot.data![index]['coursename'],
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              snapshot.data![index]['semester'] + ' '
                              + snapshot.data![index]['year'].toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          //   child: Text(
                          //     snapshot.data![index]['program'] + ' ' 
                          //     + snapshot.data![index]['number'].toString(),
                          //     style: const TextStyle(
                          //       fontSize: 20.0,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          //   child: Text(snapshot.data![index]['coursename'],
                          //     style: const TextStyle(fontSize: 20.0),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          //   child: Text(
                          //     snapshot.data![index]['semester'] + ' '
                          //     + snapshot.data![index]['year'].toString(),
                          //     style: const TextStyle(fontSize: 16),
                          //   ),
                          // ),
                      
                        ],
                      ),
                    );
                  },
                );
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RepoForm(id: 0))
          );
        },
        tooltip: 'Get Courses',
        child: const Icon(Icons.school),
      ),
    );
  }
}
