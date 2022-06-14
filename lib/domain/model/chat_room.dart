import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatRoom {
  String? chatRoomId;
  String? receiverId;
  String? receiverName;
  String? receiverAvatarUrl;
  String? unreadMessages;
  ChatRoom({
    this.chatRoomId,
    this.receiverId,
    this.receiverName,
    this.receiverAvatarUrl,
    this.unreadMessages,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatRoomId': chatRoomId,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverAvatarUrl': receiverAvatarUrl,
      'unreadMessages': unreadMessages,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      chatRoomId: map['chatRoomId'] != null ? map['chatRoomId'] as String : null,
      receiverId: map['receiverId'] != null ? map['receiverId'] as String : null,
      receiverName: map['receiverName'] != null ? map['receiverName'] as String : null,
      receiverAvatarUrl: map['receiverAvatarUrl'] != null ? map['receiverAvatarUrl'] as String : null,
      unreadMessages: map['unreadMessages'] != null ? map['unreadMessages'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoom.fromJson(String source) => ChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);
}
