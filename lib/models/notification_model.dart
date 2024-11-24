import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  Timestamp? dateNow;
  String? title;
  String? latitude;
  String? longitude;
  String? address;
  String? date;
  String? time;
  String? value;

  NotificationModel(
      {this.dateNow,
        this.title,
        this.latitude,
        this.longitude,
        this.address,
        this.date,
        this.time,
        this.value});

  NotificationModel.fromJson(DocumentSnapshot<Map<String, dynamic>> json) {
    dateNow = json['dateNow'];
    title = json['title'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['currentAddress'];
    date = json['date'];
    time = json['time'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateNow'] = this.dateNow;
    data['title'] = this.title;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['currentAddress'] = this.address;
    data['date'] = this.date;
    data['time'] = this.time;
    data['value'] = this.value;
    return data;
  }
}