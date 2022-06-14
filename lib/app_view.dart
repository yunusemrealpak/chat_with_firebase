import 'package:chat_with_firebase/chat_list_view.dart';
import 'package:chat_with_firebase/group_chat_view.dart';
import 'package:flutter/material.dart';

class AppView extends StatefulWidget {
  AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  int _currentIndex = 0;

  changeCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [const GroupChatView(), const ChatListView()].elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: changeCurrentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [ 
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "",
          ),
        ],
      ),
    );
  }
}