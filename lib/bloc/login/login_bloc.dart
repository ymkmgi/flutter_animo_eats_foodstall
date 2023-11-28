import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:animo_eats/services/firebase_auth.dart';
import 'package:animo_eats/services/firestore_db.dart';
import 'package:animo_eats/models/vendor.dart' as model;
import 'package:hive_flutter/hive_flutter.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {});
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());

      try {
        FirebaseAuth firebaseAuth = FirebaseAuth.instance;

        // sign in with email and password
        await FirebaseAuthService(firebaseAuth).signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        // Get user document
        var querySnapshot = await FirestoreDatabase().getDocumentsWithQuery(
          "vendors",
          "email",
          event.email,
        );

        if (querySnapshot.docs.isNotEmpty) {
          var userDocument = querySnapshot.docs[0];
          // save user data to Hive
          model.Vendor user = model.Vendor.fromMap(
            userDocument.data() as Map<String, dynamic>,
          );
          user.id = userDocument.id;

          user.saveToHive();
          var box = Hive.box("myBox");
          box.put("isRegistered", true);

          // emit success
          emit(LoginSuccess());
        } else {
          emit(LoginError(error: 'No vendor found with this email.'));
        }
      } on FirebaseAuthException catch (e) {
        // Log the error code
        debugPrint("FirebaseAuthException Code: ${e.code}");

        emit(
          LoginError(
            error: FirebaseAuthService(FirebaseAuth.instance).getErrorString(
              e.code,
            ),
          ),
        );
      }
    });
  }
}
