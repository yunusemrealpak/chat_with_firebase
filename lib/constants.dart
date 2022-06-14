import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AppConstants {
  static String userId = "";
  static String userName = "";

  static String otherUserId = const Uuid().v4();

  static setUser() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? const Uuid().v4();
    userName = prefs.getString('userName') ?? 'User ${Random().nextInt(1000)}';

    await prefs.setString("userId", userId);
    await prefs.setString("userName", userName);
  }

  // create static list with random network images  to be used in the app for testing
  static List<String> randomNetworkImages = [
    'https://picsum.photos/id/1/200/300',
    'https://picsum.photos/id/2/200/300',
    'https://picsum.photos/id/3/200/300',
    'https://picsum.photos/id/4/200/300',
    'https://picsum.photos/id/5/200/300',
    'https://picsum.photos/id/6/200/300',
    'https://picsum.photos/id/7/200/300',
    'https://picsum.photos/id/8/200/300',
    'https://picsum.photos/id/9/200/300',
    'https://picsum.photos/id/10/200/300',
    'https://picsum.photos/id/11/200/300',
    'https://picsum.photos/id/12/200/300',
    'https://picsum.photos/id/13/200/300',
    'https://picsum.photos/id/14/200/300',
    'https://picsum.photos/id/15/200/300',
    'https://picsum.photos/id/16/200/300',
    'https://picsum.photos/id/17/200/300',
    'https://picsum.photos/id/18/200/300',
    'https://picsum.photos/id/19/200/300',
    'https://picsum.photos/id/20/200/300',
    'https://picsum.photos/id/21/200/300',
    'https://picsum.photos/id/22/200/300',
    'https://picsum.photos/id/23/200/300',
    'https://picsum.photos/id/24/200/300',
    'https://picsum.photos/id/25/200/300',
  ];

  // create avatar url with random index for randomNetworkImages
  static String userAvatarUrl = randomNetworkImages[Random().nextInt(randomNetworkImages.length)];
  static String otherUserAvatarUrl = randomNetworkImages[Random().nextInt(randomNetworkImages.length)];

  static String groupChatId = "k02bxAElPV5IFB1nCeHU";
}
