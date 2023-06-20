import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

import '../models/task.dart';

class FirestoreRepository {
//create task
  static Future<void> create({Task? task}) async {
    try {
      //print(GetStorage().read('email').toString());
      await FirebaseFirestore.instance
          .collection(GetStorage().read('email'))
          .doc(task!.id)
          .set(task.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<Task>> get() async {
    List<Task> taskList = [];
    try {
      final data = await FirebaseFirestore.instance
          .collection(GetStorage().read('email'))
          .get();

      for (var task in data.docs) {
        taskList.add(Task.fromMap(task.data()));
      }
      return taskList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
