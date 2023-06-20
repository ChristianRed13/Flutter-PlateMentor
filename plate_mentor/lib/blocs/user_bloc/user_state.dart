import 'package:equatable/equatable.dart';

import '../../models/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;

  UserLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class UserPopularRecipes extends UserState {
  final List<String> recipes;

  UserPopularRecipes({required this.recipes});

  @override
  List<Object> get props => [recipes];
}

class UserLoadedFromToken extends UserState {
  final User user;

  UserLoadedFromToken({required this.user});

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;

  UserError({required this.message});

  @override
  List<Object> get props => [message];
}
