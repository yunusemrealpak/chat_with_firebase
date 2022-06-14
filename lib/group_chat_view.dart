import 'package:chat_with_firebase/chat_view.dart';
import 'package:chat_with_firebase/domain/i_firestore_repository.dart';
import 'package:chat_with_firebase/domain/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'infrastructure/firestore_repository.dart';

class GroupChatView extends StatefulWidget {
  const GroupChatView({Key? key}) : super(key: key);

  @override
  State<GroupChatView> createState() => _GroupChatViewState();
}

class _GroupChatViewState extends State<GroupChatView> {
  late final IFirestoreRepository _firestoreRepository;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _firestoreRepository = FirestoreRepository();

    //_firestoreRepository.getMessagesFromGroup(groupChatId);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  _sendMessage(String content) async {
    if (content.trim() != '') {
      _textController.clear();

      _firestoreRepository.sendMessageToGroup(
          Message(
            content,
            AppConstants.userId,
            AppConstants.userName,
            "",
            "",
            FieldValue.serverTimestamp(),
            AppConstants.userAvatarUrl,
          ),
          groupId: AppConstants.groupChatId);
    } else {
      //Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        actions: [
          Center(child: Text(AppConstants.userName)),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 75,
            child: Center(
              child: Icon(Icons.play_arrow, size: 40,),
            ),
          ),
          Divider(),
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _firestoreRepository
                  .getMessagesFromGroup(AppConstants.groupChatId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return const Text('Something Went Wrong Try later');
                    } else {
                      final messages = snapshot.data;

                      if (messages == null || messages.isEmpty) {
                        return const Text('No Users Found');
                      } else {
                        return ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return GestureDetector(
                              onTap: () {
                                if (AppConstants.userId != message.senderId) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ChatView(
                                        receiverId: message.senderId!,
                                        receiverName: message.senderFullName!,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1)),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(message.avatarUrl!),
                                  ),
                                  title: Text(message.text ?? ""),
                                  subtitle: Text(message.senderFullName ?? "-"),
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
