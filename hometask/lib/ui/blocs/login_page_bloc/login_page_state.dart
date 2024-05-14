part of 'login_page_bloc.dart';

abstract class LoginPageState {}

class InitialState extends LoginPageState {}

class LoadingState extends LoginPageState {}

class SnackBarState extends LoginPageState {
  final String message;

  SnackBarState(this.message);
}

class AccountRedirectState extends LoginPageState {}