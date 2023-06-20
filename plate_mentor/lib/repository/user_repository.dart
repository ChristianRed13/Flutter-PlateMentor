import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user.dart';

class UserRepository {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  final GetStorage _getStorage;

  UserRepository({required GetStorage getStorage}) : _getStorage = getStorage;

  Future<List<User>> getUsers() async {
    try {
      final snapshot = await _userCollection.get();
      final users = snapshot.docs.map((doc) => User.fromSnapshot(doc)).toList();

      return users;
    } catch (e) {
      print('Error occurred while fetching Users: $e');
      throw Exception(e.toString());
    }
  }

  Future<User> getUserByToken() async {
    final String? token;
    try {
      token = _getStorage.read('token');
      if (token == null) {
        throw Exception('Token not found in GetStorage.');
      }

      final snapshot = await _userCollection.doc(token).get();

      if (snapshot.exists) {
        final user = User.fromSnapshot(snapshot);
        return user;
      } else {
        throw Exception('User not found.');
      }
    } catch (e) {
      print('Error occurred while fetching user by token: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> updateUserGroceries(Map<String, int> updateData) async {
    try {
      final String token = _getStorage.read('token');
      if (token == null) {
        throw Exception('Token not found in GetStorage.');
      }

      final snapshot = await _userCollection.doc(token).get();
      if (snapshot.exists) {
        final user = User.fromSnapshot(snapshot);
        final groceries = user.groceries ?? {};

        updateData.forEach((key, value) {
          groceries[key] = (groceries[key] ?? 0) + value;
        });

        await _userCollection.doc(token).update({
          'groceries': groceries,
        });
      } else {
        throw Exception('User not found.');
      }
    } catch (e) {
      print('Error occurred while updating user: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> updateUserFavorites(List<String> updateData) async {
    try {
      final String token = _getStorage.read('token');
      if (token == null) {
        throw Exception('Token not found in GetStorage.');
      }

      final snapshot = await _userCollection.doc(token).get();
      if (snapshot.exists) {
        await _userCollection.doc(token).update({
          'favorites': updateData,
        });
        print('User update in repository: ${updateData}');
      } else {
        throw Exception('User not found.');
      }
    } catch (e) {
      print('Error occurred while updating user: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<String>> getPopularFoods() async {
    try {
      final snapshot = await _userCollection.get();
      final users = snapshot.docs.map((doc) => User.fromSnapshot(doc)).toList();
      print('users: $users');
      final favoritesCount = <String, int>{};
      snapshot.docs.forEach((doc) {
        final favorites = (doc.get('favorites') ?? []) as List<dynamic>;
        favorites.forEach((fav) {
          final foodId = fav.toString();
          favoritesCount[foodId] = (favoritesCount[foodId] ?? 0) + 1;
        });
        print('favorites: $favorites');
      });

      final sortedFoods = favoritesCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      print('sorted foods: ${sortedFoods}');
      final popularFoods = sortedFoods
          .map((entry) => entry.key)
          .toList()
          .take(sortedFoods.length >= 8 ? 8 : sortedFoods.length)
          .toList();

      return popularFoods;
    } catch (e) {
      print('Error occurred while fetching popular foods: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> updateUserDiet(List<String> updateData) async {
    try {
      final String token = _getStorage.read('token');
      if (token == null) {
        throw Exception('Token not found in GetStorage.');
      }

      final snapshot = await _userCollection.doc(token).get();
      if (snapshot.exists) {
        await _userCollection.doc(token).update({
          'dietPlan': updateData,
        });
        print('User update in repository: ${updateData}');
      } else {
        throw Exception('User not found.');
      }
    } catch (e) {
      print('Error occurred while updating user: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> updateUser(User user) async {
    try {
      final String token = _getStorage.read('token');
      if (token == null) {
        throw Exception('Token not found in GetStorage.');
      }

      final snapshot = await _userCollection.doc(token).get();
      if (snapshot.exists) {
        await _userCollection.doc(token).update(user.toMap());
        print('User favorites updated in repository: ${user}');
      } else {
        throw Exception('User not found.');
      }
    } catch (e) {
      print('Error occurred while updating user: $e');
      throw Exception(e.toString());
    }
  }
}
