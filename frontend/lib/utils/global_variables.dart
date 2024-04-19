import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';

import '../screens/feed_screen.dart';
import '../screens/reels_screen.dart';

const webScreenSize = 600;

final homeScreenItems = [
  const FeedScreen(),
  const Text('Search'),
  const AddPostScreen(),
  const ReelsScreen(),
  Center(
    child: TextButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
        },
        child: const Text('Log Out')),
  )
];
