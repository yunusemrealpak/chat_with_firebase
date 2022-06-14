import 'package:chat_with_firebase/constants.dart';
import 'package:chat_with_firebase/domain/model/chat_room.dart';
import 'package:flutter/material.dart';

import 'chat_view.dart';
import 'domain/i_firestore_repository.dart';
import 'infrastructure/firestore_repository.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({Key? key}) : super(key: key);

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  late final IFirestoreRepository _firestoreRepository;

  @override
  void initState() {
    super.initState();
    _firestoreRepository = FirestoreRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<ChatRoom>>(
      stream: _firestoreRepository.getChatRooms(AppConstants.userId),
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
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final rooms = snapshot.data ?? [];
                    final room = rooms[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                      ),
                      title: Text(room.receiverName ?? "-"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatView(
                              receiverId: room.receiverId!,
                              receiverName: room.receiverName!,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            }
        }
      },
    ));
  }
}
