import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // sign up user
  Future<String> signupUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String res = 'Some Error Occured';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // register user
        UserCredential _cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        // add user to our database
        await _firebaseFirestore.collection('users').doc(_cred.user!.uid).set({
          'username': username,
          'uid': _cred.user!.uid,
          'email': email,
          'bio': bio,
          'following': [],
          'followers': [],
          'photoUrl': photoUrl
        });
        res = 'success';
      }
    } 
    on FirebaseAuthException catch(error){
        if(error.code=='invalid-email'){
          res = 'The emial is badly formatted';
        }
    }
    catch (error) {
      return error.toString();
    }
    return res;
  }
}
