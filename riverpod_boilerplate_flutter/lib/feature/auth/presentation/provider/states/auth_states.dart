
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


///****** Login States *******************
@immutable
sealed class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginApiLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginFailed extends LoginState {
  final String error;

  const LoginFailed({required this.error});

  @override
  List<Object> get props => [error];
}





