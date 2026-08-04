import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhanra_new/core/error/exceptions.dart';
import 'package:dhanra_new/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signInWithEmail(String email, String password);
  Future<UserModel> signUpWithEmail(
    String email,
    String password,
    String displayName,
  );
  Future<String> sendPhoneOtp(String phoneNumber);
  Future<UserModel> verifyPhoneOtp(
    String verificationId,
    String smsCode,
    String? displayName,
  );
  Future<void> resetPassword(String email);
  Future<void> signOut();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) return null;

      final doc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (doc.exists && doc.data() != null) {
        return _mapFirestoreDocToUserModel(
          currentUser.uid,
          doc.data()!,
          fallbackUser: currentUser,
        );
      }

      return UserModel(
        id: currentUser.uid,
        email: currentUser.email ?? '',
        phoneNumber: currentUser.phoneNumber ?? '',
        displayName: currentUser.displayName ?? 'User',
        photoUrl: currentUser.photoURL,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const ServerException('User sign in failed');

      final userModel =
          await _fetchOrCreateUserProfile(user, user.displayName ?? '');
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Authentication failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const ServerException('User creation failed');

      await user.updateDisplayName(displayName);
      final userModel = await _fetchOrCreateUserProfile(user, displayName);
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Registration failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> sendPhoneOtp(String phoneNumber) async {
    final completer = Completer<String>();

    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification handled in flow
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!completer.isCompleted) {
            completer.completeError(
              ServerException(e.message ?? 'Phone verification failed'),
            );
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!completer.isCompleted) {
            completer.complete(verificationId);
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (!completer.isCompleted) {
            completer.complete(verificationId);
          }
        },
        timeout: const Duration(seconds: 60),
      );

      return await completer.future;
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> verifyPhoneOtp(
    String verificationId,
    String smsCode,
    String? displayName,
  ) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) throw const ServerException('OTP Verification failed');

      final name = displayName ?? user.displayName ?? 'User';
      final userModel = await _fetchOrCreateUserProfile(user, name);
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Invalid OTP');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Password reset failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<UserModel> _fetchOrCreateUserProfile(User user, String name) async {
    final userRef = _firestore.collection('users').doc(user.uid);
    final doc = await userRef.get();

    final now = DateTime.now();
    if (doc.exists && doc.data() != null) {
      return _mapFirestoreDocToUserModel(
        user.uid,
        doc.data()!,
        fallbackUser: user,
        fallbackName: name,
      );
    }

    final newUser = UserModel(
      id: user.uid,
      email: user.email ?? '',
      phoneNumber: user.phoneNumber ?? '',
      displayName: name.isNotEmpty ? name : 'User',
      photoUrl: user.photoURL,
      createdAt: now,
    );

    await userRef.set({
      'email': newUser.email,
      'phoneNumber': newUser.phoneNumber,
      'displayName': newUser.displayName,
      'photoUrl': newUser.photoUrl,
      'createdAt': now.toIso8601String(),
    });

    return newUser;
  }

  UserModel _mapFirestoreDocToUserModel(
    String uid,
    Map<String, dynamic> data, {
    User? fallbackUser,
    String? fallbackName,
  }) {
    DateTime? parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    final emailVal = data['email'];
    final phoneVal = data['phoneNumber'];
    final nameVal = data['displayName'];

    return UserModel(
      id: uid,
      email: (emailVal is String && emailVal.isNotEmpty)
          ? emailVal
          : (fallbackUser?.email ?? ''),
      phoneNumber: (phoneVal is String && phoneVal.isNotEmpty)
          ? phoneVal
          : (fallbackUser?.phoneNumber ?? ''),
      displayName: (nameVal is String && nameVal.isNotEmpty)
          ? nameVal
          : (fallbackName ?? fallbackUser?.displayName ?? 'User'),
      photoUrl: data['photoUrl'] as String? ?? fallbackUser?.photoURL,
      createdAt: parseDate(data['createdAt']) ?? DateTime.now(),
    );
  }
}
