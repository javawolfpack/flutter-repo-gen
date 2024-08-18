//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url211 = Uri.parse('https://github.com/CSUChico-CSCI211');
final Uri _url345 = Uri.parse('https://github.com/CSUChico-CSCI345');
final Uri _url440 = Uri.parse('https://github.com/CSUChico-CSCI440');
final Uri _url467 = Uri.parse('https://gitlab.com/CSUChico/CSUC-CINS467');
final Uri _url490 = Uri.parse('https://github.com/CSUChico-CSCI490');
final Uri _url640 = Uri.parse('https://github.com/CSUChico-CSCI640');
final Uri _url644 = Uri.parse('https://gitlab.com/CSUChico/CSUC-CSCI644');

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key, required this.course});

  final Map<String, dynamic> course;

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  
  Future<void> _launchUrl() async {
    late Uri url;
    switch(widget.course['number']){
      case 211:
        url = _url211;
        break;
      case 345:
        url = _url345;
        break;
      case 440:
        url = _url440;
        break;
      case 467:
        url = _url467;
        break;
      case 490:
        url = _url490;
        break;
      case 640:
        url = _url640;
        break;
      case 644:
        url = _url644;
        break;
    }
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

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
              widget.course['github'] ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Make sure to visit the ${widget.course['program']} ${widget.course['number']} organization on GitHub within a week (7 days) to accept your invitation',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18.0,
                  )
                ),
              ) : const SizedBox.shrink(),
              widget.course['github'] ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _launchUrl,
                  style: ElevatedButton.styleFrom(
                    shadowColor: const Color.fromRGBO(200, 200, 200, 0.8),
                  ),
                  child: Text('Go to the ${widget.course['program']} ${widget.course['number']} organization on GitHub',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ) : const SizedBox.shrink(),
              widget.course['gitlab'] ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _launchUrl,
                  style: ElevatedButton.styleFrom(
                    shadowColor: const Color.fromRGBO(200, 200, 200, 0.8),
                  ),
                  child: Text('Go to the ${widget.course['program']} ${widget.course['number']} Group on GitLab',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ) : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: const Color.fromRGBO(200, 200, 200, 0.8),
                  ),
                  child: const Text('Return to Courses Page',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}