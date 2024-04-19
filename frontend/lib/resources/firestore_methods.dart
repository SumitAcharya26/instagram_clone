import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post

  Future<String> uploadPost({
    required String description,
    required Uint8List file,
    required String uid,
    required String username,
    required String profImage,
  }) async {
    String res = 'Some error occurred';
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage(childName: 'posts', file: file, isPost: true);
      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage,
          likes: []);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(
      {required String postId,
      required String uid,
      required List likes}) async {
    String res = 'Some error occurred';
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
      res = 'success';
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> sendComment(
      {required String username,
      required String postId,
      required String userPhotoUrl,
      required String uid,
      required String text}) async {
    String res = 'Some error occurred';
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v4();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'username': username,
          'uid': uid,
          'userPhotoUrl': userPhotoUrl,
          'text': text,
          'commentId': commentId,
          'likes': [],
          'datePublished': DateTime.now()
        });
        res = 'success';
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> commentLikes(
      {required String commentId,
      required String postId,
      required String uid,
      required List likes}) async {
    try {
      if (likes.contains(uid)) {
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteComment(
      {required String postId, required String commentId}) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> uploadReels(
    String uid,
    String username,
    Uint8List file,
  ) async {
    try {
      String videoUrl =
          await StorageMethods().uploadVideoToStorage('reels', file);
      String reelId = const Uuid().v1();
      await _firestore.collection('reels').doc(reelId).set({
        'videoUrl': videoUrl,
        'uid': uid,
        'reelId': reelId,
        'datePublished': DateTime.now(),
        'username': username,
        'likes': [],
      });

    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> likeReel(
      {required String reelId,
        required String uid,
        required List likes}) async {
    String res = 'Some error occurred';
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('reels').doc(reelId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('reels').doc(reelId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
      res = 'success';
    } catch (error) {
      print(error.toString());
    }
  }
}
