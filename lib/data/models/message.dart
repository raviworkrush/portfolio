class Message {
  final String? name;
  final String? email;
  final String? message;
  final String? dateTime;

  Message({this.name, this.email, this.message, this.dateTime});

  //toJson
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'message': message,
        'date_time': dateTime,
      };

  //fromJson
  factory Message.fromJson(Map<String, dynamic> json) => Message(
        name: json['name'] as String,
        email: json['email'] as String,
        message: json['message'] as String,
        dateTime: json['date_time'] as String,
      );
}
