import 'package:chat_with_firebase/domain/model/chat_room.dart';
import 'package:chat_with_firebase/domain/model/message.dart';

abstract class IFirestoreRepository {
  Stream<List<Message>> getMessagesFromGroup(String groupId);
  Stream<List<Message>> getMessagesFromUser(String? chatRoomId);
  Stream<List<ChatRoom>> getChatRooms(String userId);
  Future<ChatRoom?> getChatRoomFromReceiver(String receiverId);

  sendMessageToGroup(Message message, {String? groupId});
  Future<ChatRoom> sendMessage({String? chatRoomId, required Message message});
}