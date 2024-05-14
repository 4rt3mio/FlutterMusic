part of 'login_page_bloc.dart';

abstract class LoginPageEvent {}

class SignInEvent extends LoginPageEvent {
  final String email;

  SignInEvent(this.email);
}