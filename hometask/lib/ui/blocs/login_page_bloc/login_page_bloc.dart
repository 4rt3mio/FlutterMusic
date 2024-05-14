import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';

part 'login_page_event.dart';
part 'login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  LoginPageBloc() : super(InitialState()) {
    on<SignInEvent>(_onSignInEvent);
  }

  void _onSignInEvent(SignInEvent event, Emitter<LoginPageState> emit) async {
    final emailController = TextEditingController();

    try {
      emit(LoadingState());
      const snackBarMessage = 'Check your email for a login link!';
      emit(SnackBarState(snackBarMessage));
      await supabase.auth.signInWithOtp(
        email: emailController.text.trim(),
        emailRedirectTo: kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
      );
      emit(AccountRedirectState());
    } on AuthException catch (error) {
      emit(SnackBarState(error.message));
    } catch (error) {
      emit(SnackBarState('Unexpected error occurred'));
    } finally {
      emit(InitialState());
    }
  }
}