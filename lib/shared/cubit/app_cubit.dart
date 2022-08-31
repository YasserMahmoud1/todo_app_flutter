import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/home_tasks/home_tasks_screen.dart';
import 'package:todo_app/modules/school_tasks/school_tasks_screen.dart';
import 'package:todo_app/modules/work_tasks/work_tasks_screen.dart';
import 'package:todo_app/shared/cubit/app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int cuttentIndex = 0;

  List<Widget> screens = [
    HomeTasksScreen(),
    WorkTasksScreen(),
    SchoolTasksScreen(),
  ];
  void changeNavBar(int index) {
    cuttentIndex = index;
    emit(AppChangeNavBarState());
  }

  late Database database;
  List<Map> homeDoneTasks = [];
  List<Map> homeTodoTasks = [];
  List<Map> workDoneTasks = [];
  List<Map> workTodoTasks = [];
  List<Map> schoolDoneTasks = [];
  List<Map> schoolTodoTasks = [];
  List<Map> list = [];

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) async {
      await database.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, category TEXT, done BOOL )');
      print('Database created');
    }, onOpen: (database) {
      print('Databese opend');
      getDataFromDatabase(database);
    }).then((value) {
      database = value;
      emit(AppCreateDatabase());
    });
  }

  void insertToDatabase({
    required String title,
    required String date,
    required String time,
    required String category,
  }) async {
    await database.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO tasks(title, date, time, done, category) VALUES ("$title", "$date", "$time", False, "$category")')
            .then((value) {
          emit(AppInsertToDatabase());
          getDataFromDatabase(database);
          print('$value inserted');
        }));
  }

  void getDataFromDatabase(database) {
    emit(AppLoadingGetDataFromDatabase());
    homeDoneTasks = [];
    homeTodoTasks = [];
    workDoneTasks = [];
    workTodoTasks = [];
    schoolDoneTasks = [];
    schoolTodoTasks = [];
    database
        .rawQuery('SELECT * From tasks WHERE category = "home" AND done = 0')
        .then((value) {
      homeTodoTasks = value;
      emit(AppHomeTasks());
    });
    database
        .rawQuery('SELECT * From tasks WHERE category = "home" AND done = 1')
        .then((value) {
      homeDoneTasks = value;
      emit(AppHomeTasks());
    });
    database
        .rawQuery('SELECT * From tasks WHERE category = "work" AND done = 0')
        .then((value) {
      workTodoTasks = value;
      emit(AppWorkTasks());
    });
    database
        .rawQuery('SELECT * From tasks WHERE category = "work" AND done = 1')
        .then((value) {
      workDoneTasks = value;
      emit(AppWorkTasks());
    });
    database
        .rawQuery('SELECT * From tasks WHERE category = "school" AND done = 0')
        .then((value) {
      schoolTodoTasks = value;
      emit(AppSchoolTasks());
    });
    database
        .rawQuery('SELECT * From tasks WHERE category = "school" AND done = 1')
        .then((value) {
      schoolDoneTasks = value;
      emit(AppSchoolTasks());
    });
    // database.rawQuery('SELECT * From tasks').then((value) {
    //   list = value;
    //   emit(AppHomeTasks());
    // });
    // list.forEach((element) {
    //   if (element['category'] == 'home' && element['done'] == 0) {
    //     homeTodoTasks.add(element);
    //   } else if (element['category'] == 'home' && element['done'] == 1) {
    //     homeDoneTasks.add(element);
    //   } else if (element['category'] == 'work' && element['done'] == 0) {
    //     workTodoTasks.add(element);
    //   } else if (element['category'] == 'work' && element['done'] == 1) {
    //     workDoneTasks.add(element);
    //   } else if (element['category'] == 'school' && element['done'] == 0) {
    //     schoolTodoTasks.add(element);
    //   } else if (element['category'] == 'school' && element['done'] == 1) {
    //     schoolDoneTasks.add(element);
    //   }
    // });
    emit(AppGetDataFromDatabase());
  }

  void updateDatebase({
    required bool done,
    required int id,
  }) {
    database.rawUpdate(
        'UPDATE tasks SET done = ? Where id = ? ', [done, id]).then((value) {
      emit(AppUpdateDataFromDatabase());
      getDataFromDatabase(database);
    });
  }

  void deleteData({
    required int id,
  }) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDataFromDatabase());
    });
  }
}
