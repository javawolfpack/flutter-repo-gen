//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';

class RepoForm extends StatefulWidget{
  const RepoForm({super.key, required this.course});

  final Map<String, dynamic> course;
  
  @override
  State<RepoForm> createState() => _MyRepoFormState();
}

class _MyRepoFormState extends State<RepoForm> {
  final _formKey = GlobalKey<FormState>();

  String? _textValidator(String? value){
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  void _submitForm() {
    if(_formKey.currentState!.validate()){
      _formKey.currentState?.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Processing...'),
          action: SnackBarAction(
            label: 'Return to Course Page',
            onPressed: () {
              Navigator.pop(context);
            }
          )
        )
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Repo Generation Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Generate a ${widget.course['program']} ${widget.course['number'].toString()} Repo',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.face),
                      labelText: 'First Name *',
                    ),
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    validator: _textValidator,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person_rounded),
                      labelText: 'Last Name *',
                    ),
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    validator: _textValidator,
                  ),
                  widget.course['github'] ? TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.code),
                      labelText: 'GitHub Username *',
                    ),
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    validator: _textValidator,
                  ) : const SizedBox.shrink(),
                  widget.course['gitlab'] ? TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.code),
                      labelText: 'GitLab Username *',
                    ),
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    validator: _textValidator,
                  ) : const SizedBox.shrink(),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.token),
                      labelText: 'Course Token (Given in Lecture) *',
                    ),
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    validator: _textValidator,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text(
                        'Generate Repo',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // body: FutureBuilder<Map>(
      //   future: courseData,
      //   builder: (context, snapshot){
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const CircularProgressIndicator();
      //     } else if (snapshot.hasError) {
      //       return Text('Error: ${snapshot.error}');
      //     } else if (snapshot.hasData){
      //       final data = snapshot.data!;
      //       if(kDebugMode){
      //         print(data);
      //       }
      //       return Text(data['coursename']);
      //     } else {
      //       return const Text('No data available');
      //     }
      //   },
      // )
    );
  }
}