// GitHub: test/token -> test/github/username -> test/github/repo -> test/github/team -> create/github/team -> create/github/repo
// GitLab: test/token -> test/gitlab/username -> create/gitlab/repo
// If successful: 200 OK
// Else: there is an error when testing token, github/gitlab username, github team, or github repo -> response.body will contain error message
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'success.dart';

class RepoForm extends StatefulWidget {
  const RepoForm({super.key, required this.course});

  final Map<String, dynamic> course;

  @override
  State<RepoForm> createState() => _MyRepoFormState();
}

class _MyRepoFormState extends State<RepoForm> {
  // Ref: https://docs.flutter.dev/cookbook/forms/validation
  final _formKey = GlobalKey<FormState>();

  final _fnamecontroller = TextEditingController();
  final _lnamecontroller = TextEditingController();
  final _githubcontroller = TextEditingController();
  final _gitlabcontroller = TextEditingController();
  final _tokencontroller = TextEditingController();

  Future<String>? _formError;

  /* Validators */
  String? _textValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  // Check if token is valid
  Future<String> _tokenValidate(String value) async {
    final response =
        await http.post(Uri.parse('https://repo.bryandixon.phd/api/test/token'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'id': widget.course['id'],
              'coursetoken': value,
            }));

    if (response.statusCode == 200) {
      // If server returns a 200 OK response, parse the JSON.
      if (kDebugMode) {
        print(response.statusCode);
      }
      return value;
    } else {
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }
      //throw Exception(response.body);
      throw Exception(
          'Course Token failure - Check that you have entered the correct Course Token.');
    }
  }

  // Check if GitHub username is valid
  Future<String> _githubValidate(String value) async {
    final response = await http.post(
        Uri.parse('https://repo.bryandixon.phd/api/test/github/username'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'githubusername': value,
        }));

    if (response.statusCode == 200) {
      // If server returns a 200 OK response, parse the JSON.
      return value;
    } else {
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }
      //throw Exception(response.body);
      throw Exception(
          'GitHub Username failure - check that the username you entered matches your GitHub username exactly.');
    }
  }

  // Check if GitHub Repo exists
  Future<String> _githubRepoValidate(String value) async {
    final response = await http.post(
        Uri.parse('https://repo.bryandixon.phd/api/test/github/repo/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': widget.course['id'],
          'githubusername': value,
          'firstname': widget.course['firstname'],
          'lastname': widget.course['lastname'],
        }));

    if (response.statusCode == 200) {
      // If server returns a 200 OK response, parse the JSON.
      if (kDebugMode) {
        print('GitHub Repo status code: ${response.statusCode}');
        print(response.body);
      }
      return value;
    } else {
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }
      // throw Exception('Repo not created');
      //throw Exception(response.body);
      throw Exception(
          'GitHub Repo failure - a repo has already been generated for you for ${widget.course['coursename']}. Contact your instructor about getting the repo renamed for this semester.');
    }
  }

  // Check if GitHub Team exists
  Future<String> _githubTeamValidate(String value) async {
    final response = await http.post(
        //Uri.parse('http://10.100.100.29:8080/api/testgithubteam/'),
        Uri.parse('https://repo.bryandixon.phd/api/test/github/team/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': widget.course['id'],
          'githubusername': value,
          'firstname': widget.course['firstname'],
          'lastname': widget.course['lastname'],
        }));

    if (response.statusCode == 200) {
      // If server returns a 200 OK response, parse the JSON.
      if (kDebugMode) {
        print('GitHub Team status code: ${response.statusCode}');
        print(response.body);
      }
      return value;
    } else {
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }
      //throw Exception("Team exists, same username");
      throw Exception(response.body);
      // throw Exception(
      //   'GitHub Team failure - a team has already been generated for you for ${widget.course['coursename']}. Contact your instructor about getting the repo renamed for this semester.');
    }
  }

  // Create GitHub Team
  Future<String> _createGithubTeam(String firstname, String lastname,
      String githubusername, String coursetoken) async {
    final response = await http.post(
        Uri.parse('https://repo.bryandixon.phd/api/create/github/team'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': widget.course['id'],
          'firstname': firstname,
          'lastname': lastname,
          'githubusername': githubusername,
          'coursetoken': coursetoken
        }));

    if (response.statusCode == 200) {
      // If the server returns 200 OK response, then parse the JSON.
      //return Repo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      if (kDebugMode) {
        print(response.body);
      }
      return response.body;
    } else {
      // If server did not return 200, then throw an exception.
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }
      //throw Exception('Team Creation Failed, team may already exist');
      throw Exception(response.body);
    }
  }

  // Create GitHub Repo
  Future<String> _createGithubRepo(String firstname, String lastname,
      String githubusername, String coursetoken) async {
    final response = await http.post(
        Uri.parse('https://repo.bryandixon.phd/api/create/github/repo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': widget.course['id'],
          'firstname': firstname,
          'lastname': lastname,
          'githubusername': githubusername,
          'coursetoken': coursetoken
        }));

    if (response.statusCode == 200) {
      // If the server returns 200 OK response, then parse the JSON.
      //return Repo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      if (kDebugMode) {
        print(response.body);
      }
      _fnamecontroller.clear();
      _lnamecontroller.clear();
      _githubcontroller.clear();
      _tokencontroller.clear();
      return response.body;
    } else {
      // If server did not return 200, then throw an exception.
      // throw Exception(response.body);
      throw Exception('GitHub Repo not created');
    }
  }

  // Validate GitLab Username
  Future<String> _gitlabValidate(String value) async {
    final response = await http.post(
        Uri.parse('https://repo.bryandixon.phd/api/test/gitlab/username'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'gitlabusername': value,
        }));

    if (response.statusCode == 200) {
      // If server returns a 200 OK response, parse the JSON.
      return value;
    } else {
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }
      throw Exception(
          'GitLab Username failure - check that the username you entered matches your GitLab username exactly.');
    }
  }

  // Create GitLab Repo
  Future<String> _createGitlabRepo(String firstname, String lastname,
      String gitlabusername, String coursetoken) async {
    final response = await http.post(
        Uri.parse('https://repo.bryandixon.phd/api/create/gitlab/repo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': widget.course['id'],
          'firstname': firstname,
          'lastname': lastname,
          'gitlabusername': gitlabusername,
          'coursetoken': coursetoken
        }));

    if (response.statusCode == 200) {
      // If the server returns 200 OK response, then parse the JSON.
      //return Repo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      if (kDebugMode) {
        print(response.body);
      }
      _fnamecontroller.clear();
      _lnamecontroller.clear();
      _gitlabcontroller.clear();
      _tokencontroller.clear();
      return response.body;
    } else {
      // If server did not return 200, then throw an exception.
      //throw Exception('GitLab Repo Already Exists for this Semester');
      throw Exception(response.body);
    }
  }

  /* Create Repo and Submit Form */
  // Ref: https://docs.flutter.dev/cookbook/networking/send-data
  Future<String> createRepo(String firstname, String lastname,
      String githubusername, String gitlabusername, String coursetoken) async {
    if (kDebugMode) {
      print(
          'createRepo: $firstname, $lastname, $githubusername, $gitlabusername, $coursetoken');
    }
    // Check course token for all repos
    if (coursetoken.isNotEmpty) {
      String token = await _tokenValidate(coursetoken);
      if (kDebugMode) {
        print('token: $token');
      }
    }
    // Handle GitHub repos
    if (githubusername.isNotEmpty) {
      String hub = await _githubValidate(githubusername);
      String repo = await _githubRepoValidate(githubusername);
      String team = await _githubTeamValidate(githubusername);
      String createTeam = await _createGithubTeam(
          firstname, lastname, githubusername, coursetoken);
      String createRepo = await _createGithubRepo(
          firstname, lastname, githubusername, coursetoken);
      if (kDebugMode) {
        print('github username confirmed: $hub');
        print('github repo confirmed: $repo');
        print('github team confirmed: $team');
        print('github team created: $createTeam');
        print('github repo created: $createRepo');
      }
      return createRepo;
    }
    // Handle GitLab repos
    if (gitlabusername.isNotEmpty) {
      String lab = await _gitlabValidate(gitlabusername);
      String repo = await _createGitlabRepo(
          firstname, lastname, gitlabusername, coursetoken);
      if (kDebugMode) {
        print('gitlab username confirmed: $lab');
        print('gitlab repo created: $repo');
      }
      return repo;
    }
    return "Repo not created";
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _formError = createRepo(
          _fnamecontroller.text,
          _lnamecontroller.text,
          _githubcontroller.text,
          _gitlabcontroller.text,
          _tokencontroller.text,
        ).then((value) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SuccessPage(course: widget.course)),
          );
          return value;
        });
      });
      _formKey.currentState?.save();
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
                    controller: _fnamecontroller,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.face),
                      labelText: 'First Name *',
                    ),
                    validator: _textValidator,
                  ),
                  TextFormField(
                    controller: _lnamecontroller,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person_rounded),
                      labelText: 'Last Name *',
                    ),
                    validator: _textValidator,
                  ),
                  widget.course['github']
                      ? TextFormField(
                          controller: _githubcontroller,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.code),
                            labelText: 'GitHub Username *',
                          ),
                          validator: _textValidator,
                        )
                      : const SizedBox.shrink(),
                  widget.course['gitlab']
                      ? TextFormField(
                          controller: _gitlabcontroller,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.code),
                            labelText: 'GitLab Username *',
                          ),
                          validator: _textValidator,
                        )
                      : const SizedBox.shrink(),
                  TextFormField(
                    controller: _tokencontroller,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.token_rounded),
                      labelText: 'Course Token (Given in Lecture) *',
                    ),
                    validator: _textValidator,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        shadowColor: const Color.fromRGBO(200, 200, 200, 0.8),
                      ),
                      child: const Text(
                        'Generate Repo',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<String>(
              future: _formError,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasData) {
                      return Text(snapshot.data!);
                    } else if (snapshot.hasError) {
                      return Text(
                        '${snapshot.error}',
                        style: const TextStyle(
                          color: Colors.redAccent,
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
