import 'dart:developer';

import 'package:chat_with_firebase/constants.dart';
import 'package:chat_with_firebase/domain/i_firestore_repository.dart';
import 'package:chat_with_firebase/domain/model/chat_room.dart';
import 'package:chat_with_firebase/domain/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class FirestoreRepository extends IFirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<Message>> getMessagesFromGroup(String groupId) {
    return _firestore
        .collection("groups")
        .doc(groupId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Message.fromMap(doc.data());
      }).toList();
    });
  }

  @override
  Stream<List<Message>> getMessagesFromUser(String? chatRoomId) {
    return _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Message.fromMap(doc.data());
      }).toList();
    });
  }

  @override
  sendMessageToGroup(Message message, {String? groupId}) {
    message.time = FieldValue.serverTimestamp();
    var documentReference = _firestore
        .collection('groups')
        .doc(groupId)
        .collection("chats")
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    _firestore.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        message.toMap(),
      );
    });
  }

  @override
  Future<ChatRoom> sendMessage(
      {String? chatRoomId, required Message message}) async {
    chatRoomId ??= const Uuid().v4();

    final userChatRoom = ChatRoom(
      chatRoomId: chatRoomId,
      receiverId: message.receiverId,
      receiverName: message.receiverName,
      receiverAvatarUrl: "",
      unreadMessages: '0',
    );

    final otherChatRoom = ChatRoom(
      chatRoomId: chatRoomId,
      receiverId: message.senderId,
      receiverName: message.senderFullName,
      receiverAvatarUrl: "",
      unreadMessages: '0',
    );

    final userChatRef = _firestore
        .collection('users')
        .doc(message.senderId)
        .collection('chatrooms');

    final otherChatRef = _firestore
        .collection('users')
        .doc(message.receiverId)
        .collection('chatrooms');

    final userChatDoc = await userChatRef.doc(message.receiverId).get();
    if (!userChatDoc.exists) {
      //Create
      userChatRef.doc(message.receiverId).set(userChatRoom.toMap());
      otherChatRef.doc(message.senderId).set(otherChatRoom.toMap());
    }

    final documentReference = _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection("chats")
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    _firestore.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        message.toMap(),
      );
    });

    return userChatRoom;
  }

  @override
  Stream<List<ChatRoom>> getChatRooms(String userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("chatrooms")
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ChatRoom.fromMap(doc.data());
      }).toList();
    });
  }

  @override
  Future<ChatRoom?> getChatRoomFromReceiver(String receiverId) async {
    final res = await _firestore
        .collection("users")
        .doc(AppConstants.userId)
        .collection("chatrooms")
        .doc(receiverId)
        .get();
    final data = res.data();
    return data != null ? ChatRoom.fromMap(data) : null;
  }
}
