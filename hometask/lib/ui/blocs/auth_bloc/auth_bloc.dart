import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../main.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthCheckSession) {
      final session = supabase.auth.currentSession;
      if (session != null) {
        yield AuthUserLogged();
      } else {
        yield AuthInitial();
      }
    } else if (event is AuthSignIn) {
      yield AuthLoading();

      try {
        await supabase.auth.signInWithOtp(
          email: event.email,
          emailRedirectTo:
          kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
        );

        yield AuthInitial();
      } catch (error) {
        yield AuthError('Failed to sign in. Please try again.');
      }
    }
  }
}