import 'package:http/http.dart' as http;
import 'package:me/data/models/message.dart';
import 'package:me/data/models/project.dart';


class APIService {
  Future<List<Project>> fetchProjects() async {
    try {
      final response = await http.get(Uri.parse('https://script.google.com/macros/s/AKfycbybg2YLApS964dNOB8UJE7K3bKRA2obfIBxYGwDY7zkAV2ONr2-/exec'));
      if (response.statusCode == 200) {
        final projects = projectsFromJson(response.body);
        return projects;
      } else {
        return <Project>[];
      }
    } on Exception {
      return <Project>[];
    }
  }

  Future<bool> sendThanks(Message message) async {
    try {
      final response = await http.post(
          Uri.parse(
            'https://script.google.com/macros/s/AKfycbxd6N-Qx1PVEBmmiBV9m3ZlUUzF6aOSLHxiIxkZv8bT3WqXm8I/exec',
          ),
          body: message.toJson());
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      return false;
    }
  }
}
