part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthCheckSession extends AuthEvent {}

class AuthSignIn extends AuthEvent {
  final String email;

  AuthSignIn(this.email);
}