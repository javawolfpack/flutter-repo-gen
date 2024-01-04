class Repo {
  final int id;
  final String firstname;
  final String lastname;
  final String githubusername;
  final String gitlabusername;
  final String coursetoken;

  const Repo({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.githubusername,
    required this.gitlabusername,
    required this.coursetoken,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'firstname': String firstname,
        'lastname' : String lastname,
        'githubusername' : String githubusername,
        'gitlabusername' : String gitlabusername,
        'coursetoken' : String coursetoken,
      } =>
        Repo(
          id: id,
          firstname: firstname,
          lastname: lastname,
          githubusername: githubusername,
          gitlabusername: gitlabusername,
          coursetoken: coursetoken,
        ),
      _ => throw const FormatException('Failed to load repo.'),
    };
  }
}