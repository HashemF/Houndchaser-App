import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late FirebaseAuth auth;
  AuthCubit() : super(const AuthSignedOut("")) {
    auth = FirebaseAuth.instance;
    _subscribe();
  }

  void createAccount(String email, String password, String name) async {

    if (auth.currentUser == null) {
      await auth.createUserWithEmailAndPassword(email: email, password: password).then(
              (value) => value.user?.updateDisplayName(name)
      ).catchError((err) {
        print(err.toString());
      });
    }

  }

  void signIn(String email, String password) async {
    if (auth.currentUser == null) {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    }
  }

  void signOut() {
    auth.signOut();
  }

  void _subscribe() {
    auth.userChanges().listen((User? user) {
      if (user != null) {
        emit(AuthSignedIn(user.uid));
      }
      else {
        emit(const AuthSignedOut(""));
      }
    });
  }
}