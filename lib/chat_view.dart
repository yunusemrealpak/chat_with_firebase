// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_with_firebase/domain/model/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chat_with_firebase/domain/i_firestore_repository.dart';
import 'package:chat_with_firebase/domain/model/message.dart';

import 'constants.dart';
import 'infrastructure/firestore_repository.dart';

class ChatView extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  const ChatView({
    Key? key,
    required this.receiverId,
    required this.receiverName,
  }) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final IFirestoreRepository _firestoreRepository;
  late final TextEditingController _textController;

  ChatRoom? chatRoom;
  bool _isLoading = false;
  bool _hasMessages = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _firestoreRepository = FirestoreRepository();

    _getMessages();
    //_firestoreRepository.getMessagesFromGroup(groupChatId);
  }

  _getMessages() async {
    _setLoading(true);
    chatRoom =
        await _firestoreRepository.getChatRoomFromReceiver(widget.receiverId);
    if (chatRoom != null) {
      setState(() {
        _hasMessages = true;
      });
    }
    _setLoading(false);
  }

  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _setHasMessages(bool value) {
    if (_hasMessages != value) {
      setState(() {
        _hasMessages = value;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  _sendMessage(String content) async {
    if (content.trim() != '') {
      _textController.clear();

      chatRoom = await _firestoreRepository.sendMessage(
        chatRoomId: chatRoom?.chatRoomId,
        message: Message(
          content,
          AppConstants.userId,
          AppConstants.userName,
          widget.receiverId,
          widget.receiverName,
          FieldValue.serverTimestamp(),
          AppConstants.userAvatarUrl,
        ),
      );
      _setHasMessages(true);
    } else {
      print('Nothing to send');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Column(
              children: [
                Expanded(
                  child: !_hasMessages
                      ? const Center(
                          child: Text("İlk mesajını gönder"),
                        )
                      : StreamBuilder<List<Message>>(
                          stream: _firestoreRepository
                              .getMessagesFromUser(chatRoom?.chatRoomId),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return const Center(
                                    child: CircularProgressIndicator());
                              default:
                                if (snapshot.hasError) {
                                  return const Text(
                                      'Something Went Wrong Try later');
                                } else {
                                  final messages = snapshot.data;

                                  if (messages == null || messages.isEmpty) {
                                    return const Text('No Users Found');
                                  } else {
                                    return ListView.builder(
                                      itemCount: messages.length,
                                      itemBuilder: (context, index) {
                                        final message = messages.reversed
                                            .toList()
                                            .elementAt(index);
                                        return Align(
                                          alignment: message.senderId ==
                                                  AppConstants.userId
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: SizedBox(
                                            width: 150,
                                            child: ListTile(
                                              title: Text(message.text ?? ""),
                                              subtitle: Text(
                                                  message.senderFullName ??
                                                      "-"),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                }
                            }
                          },
                        ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Type a message",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _sendMessage(_textController.text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
