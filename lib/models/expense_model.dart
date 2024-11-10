import 'package:cloud_firestore/cloud_firestore.dart';

class Expenses {
  String? userId;
  String? filter;
  String? sort;
  num? amount;
  String? status;
  int? statusId;
  String? date;
  String? time;
  int? month;
  String? name;
  String? email;
  num? income;

  Expenses(
      {this.userId,
        this.filter,
        this.sort,
        this.amount,
        this.status,
        this.statusId,
        this.date,
        this.time,
        this.month,
        this.name,
        this.email,
        this.income});

  Expenses.fromJson(DocumentSnapshot<Map<String, dynamic>> json) {
    userId = json['userId'];
    filter = json['filter'];
    sort = json['sort'];
    amount = json['amount'];
    status = json['status'];
    statusId = json['statusId'];
    date = json['date'];
    time = json['time'];
    month = json['month'];
    name = json['name'];
    email = json['email'];
    income = json['income'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['filter'] = this.filter;
    data['sort'] = this.sort;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['statusId'] = this.statusId;
    data['date'] = this.date;
    data['time'] = this.time;
    data['month'] = this.month;
    data['name'] = this.name;
    data['email'] = this.email;
    data['income'] = this.income;
    return data;
  }
}