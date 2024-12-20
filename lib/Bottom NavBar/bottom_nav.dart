// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:face_detection_with_flutter/community_page.dart';
import 'package:face_detection_with_flutter/settings.dart';
import 'package:face_emotion_detector/face_emotion_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:face_detection_with_flutter/pages/artist_list.dart';
import 'package:face_detection_with_flutter/pages/browse_page.dart';
import 'package:face_detection_with_flutter/pages/home_page.dart';
import 'package:face_detection_with_flutter/pages/library_page.dart';
import 'package:face_detection_with_flutter/pages/music_list.dart';
import 'package:face_detection_with_flutter/pages/radio.dart';
import 'package:face_detection_with_flutter/pages/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/playlist.dart';

class FirstPage extends StatefulWidget {
  final String path;
  const FirstPage({Key? key, required this.path}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _selected_index = 1;
  bool loading = false;
  late File file;

  String? label = "Loading...";
  void _navgateBottomBar(int index) {
    setState(() {
      _selected_index = index;
    });
  }

  final List _pages = [
    const HomePage(),
    const BrowsePage(),
    Community(),
    const LibraryPage(),
    const SearchPage(),
  ];

  @override
  void initState() {
    file = File(widget.path);
    detect(file);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selected_index],
      bottomNavigationBar: Container(
        height: 80,

        // padding: EdgeInsets.only(bottom: 0),
        // color: Colors.amber,
        child: GlassFlexContainer(
          borderRadius: BorderRadius.zero,
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(15),
          // //   topRight: Radius.circular(15),
          // // ),
          borderGradient: const LinearGradient(
            colors: [
              Color.fromARGB(0, 11, 11, 11)
            ], // Add this line to remove border stroke
            stops: [0],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              // Apply transparent color to both splashColor and highlightColor
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selected_index,
              onTap: _navgateBottomBar,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_filled,
                    size: 35,
                  ),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.grid_view_rounded,
                      size: 35,
                    ),
                    label: 'Browse'),
                const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.people,
                      size: 35,
                    ),
                    label: 'Community'),
                const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.subscriptions_rounded,
                      size: 35,
                    ),
                    label: 'Library'),
                const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                      size: 35,
                    ),
                    label: 'Search'),
              ],
              elevation: 0,
              selectedLabelStyle: const TextStyle(color: Colors.white),
              selectedItemColor: const Color.fromARGB(255, 255, 17, 0),
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              backgroundColor: Colors.transparent,
              unselectedFontSize: 13.0,
              selectedFontSize: 13.0,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> detect(File path) async {
    final emotionDetector = EmotionDetector();
    label = await emotionDetector.detectEmotionFromImage(image: path);
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: label!,
        message: 'Hope you enjoy songs recommended by us!',

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mood', label!);
    print("love");
    print(prefs.getString('mood'));
  }
}
