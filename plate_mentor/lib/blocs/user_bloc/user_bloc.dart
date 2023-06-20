import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/user.dart';
import '../../repository/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<FetchUser>((event, emit) async {
      //FetchUser = Event
      emit(UserLoading()); //emit State
      try {
        final List<User> users =
            await userRepository.getUsers(); //use repository
        emit(UserLoaded(users: users)); //emit State
      } catch (e) {
        emit(UserError(message: 'Failed to fetch users.')); //emit State
      }
    });

    on<FetchUserByToken>((event, emit) async {
      emit(UserLoading());
      try {
        final User user = await userRepository.getUserByToken();
        emit(UserLoadedFromToken(user: user));
      } catch (e) {
        emit(UserError(message: 'Failed to fetch user by token.'));
      }
    });

    on<FetchPopularRecipes>((event, emit) async {
      emit(UserLoading());
      try {
        List<String> recipes = await userRepository.getPopularFoods();
        emit(UserPopularRecipes(recipes: recipes));
      } catch (e) {
        emit(UserError(message: 'Failed to fetch user by token.'));
      }
    });

    on<UpdateUserGroceries>((event, emit) async {
      emit(UserLoading());
      try {
        await userRepository.updateUserGroceries(event.user.groceries);
        final List<User> users = await userRepository.getUsers();
        emit(UserLoaded(users: users));
      } catch (e) {
        emit(UserError(message: 'Failed to update user.'));
      }
    });

    on<UpdateUserFavorites>((event, emit) async {
      emit(UserLoading());
      try {
        await userRepository.updateUserFavorites(event.user.favorites);
        final User user = await userRepository.getUserByToken();
        emit(UserLoadedFromToken(user: user));
      } catch (e) {
        emit(UserError(message: 'Failed to update user.'));
      }
    });
  }

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is FetchUser) {
      yield UserLoading();
      try {
        final List<User> users = await userRepository.getUsers();
        emit(UserLoaded(users: users));
      } catch (e) {
        yield UserError(message: 'Failed to fetch users.');
      }
    } else if (event is FetchUserByToken) {
      yield UserLoading();
      try {
        final User user = await userRepository.getUserByToken();
        emit(UserLoadedFromToken(user: user));
      } catch (e) {
        yield UserError(message: 'Failed to fetch user by token.');
      }
    } else if (event is UpdateUserGroceries) {
      yield UserLoading();
      try {
        await userRepository.updateUserGroceries(event.user.groceries);
        final List<User> users = await userRepository.getUsers();
        emit(UserLoaded(users: users));
      } catch (e) {
        yield UserError(message: 'Failed to update user.');
      }
    }
  }
}
