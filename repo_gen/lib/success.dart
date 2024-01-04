//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key, required this.course});

  final Map<String, dynamic> course;

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Success!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('You have successfully generated a repo for',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                )
              ),
              Text('${widget.course['coursename']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24.0,
                )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Return to Courses Page'),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}