import 'package:equatable/equatable.dart';

import '../../models/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchUser extends UserEvent {}

class FetchUserByToken extends UserEvent {}

class UpdateUserGroceries extends UserEvent {
  final User user;

  const UpdateUserGroceries({required this.user});

  @override
  List<Object> get props => [user];
}
