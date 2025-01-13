import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  Timestamp? dateNow;
  String? title;
  String? date;
  String? time;
  String? value;

  NotificationModel(
      {this.dateNow,
        this.title,
        this.date,
        this.time,
        this.value});

  NotificationModel.fromJson(DocumentSnapshot<Map<String, dynamic>> json) {
    dateNow = json['dateNow'];
    title = json['title'];
    date = json['date'];
    time = json['time'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateNow'] = this.dateNow;
    data['title'] = this.title;
    data['date'] = this.date;
    data['time'] = this.time;
    data['value'] = this.value;
    return data;
  }
}