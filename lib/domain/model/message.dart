// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? text;
  String? senderId;
  String? senderFullName;
  String? receiverId;
  String? receiverName;
  FieldValue? time;
  String? avatarUrl;

  Message(
    this.text,
    this.senderId,
    this.senderFullName,
    this.receiverId,
    this.receiverName,
    this.time,
    this.avatarUrl,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'senderId': senderId,
      'senderFullName': senderFullName,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'time': time,
      'avatarUrl': avatarUrl,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      map['text'] != null ? map['text'] as String : null,
      map['senderId'] != null ? map['senderId'] as String : null,
      map['senderFullName'] != null ? map['senderFullName'] as String : null,
      map['receiverId'] != null ? map['receiverId'] as String : null,
      map['receiverName'] != null ? map['receiverName'] as String : null,
      null,
      map['avatarUrl'] != null ? map['avatarUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);
}
