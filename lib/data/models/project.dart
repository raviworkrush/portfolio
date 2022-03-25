import 'dart:convert';

List<Project> projectsFromJson(String str) =>
    List<Project>.from(json.decode(str).map((x) => Project.fromJson(x)));

String projectsToJson(List<Project> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Project {
  Project({
    this.name,
    this.description,
    this.webUrl,
    this.appUrl,
    this.demoUrl,
  });

  String? name;
  String? description;
  String? webUrl;
  String? appUrl;
  String? demoUrl;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        name: json["name"],
        description: json["description"],
        webUrl: json["web_url"],
        appUrl: json["app_url"],
        demoUrl: json["demo_url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "web_url": webUrl,
        "app_url": appUrl,
        "demo_url": demoUrl,
      };
}
