import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/models/users.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firebaseFirestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // sign up user
  Future<String> signupUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String res = 'Some Error Occurred';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // register user
        UserCredential _cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage(childName: 'profilePics',file: file,isPost:  false);

        model.User user = model.User(
            email: email,
            uid: _auth.currentUser!.uid,
            photoUrl: photoUrl,
            username: username,
            bio: bio,
            followers: [],
            following: []);

        // add user to our database
        await _firebaseFirestore
            .collection('users')
            .doc(_cred.user!.uid)
            .set(user.toJson());

        res = 'Success';
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        res = 'The email is badly formatted';
      }
    } catch (error) {
      return error.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some Error occurred';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Success';
      } else {
        res = 'Please enter all fields';
      }
    } catch (error) {
      return res = error.toString();
    }
    return res;
  }
}
