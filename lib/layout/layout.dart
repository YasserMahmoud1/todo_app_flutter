import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/app_cubit.dart';
import 'package:todo_app/shared/cubit/app_states.dart';

class AppLayout extends StatelessWidget {
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  String? category;
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Center(
                child: Text(
                  'Todo App',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.cuttentIndex,
              onTap: (index) {
                cubit.changeNavBar(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.house),
                  label: 'Home Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: 'Work Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school_outlined),
                  label: 'School Tasks',
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.0))),
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Add New Task',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'TiTle must not be empty';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Task Title',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.title),
                                        ),
                                        controller: titleController,
                                        keyboardType: TextInputType.text,
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        readOnly: true,
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.parse(
                                                      '2024-01-01'))
                                              .then((value) =>
                                                  dateController.text =
                                                      DateFormat.yMMMd()
                                                          .format(value!));
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Date must not be empty';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Task Date',
                                          border: OutlineInputBorder(),
                                          prefixIcon:
                                              Icon(Icons.calendar_month),
                                        ),
                                        controller: dateController,
                                        keyboardType: TextInputType.text,
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Time must not be empty';
                                          }
                                          return null;
                                        },
                                        readOnly: true,
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) =>
                                                  timeController.text = value!
                                                      .format(context)
                                                      .toString());
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Task Time',
                                          border: OutlineInputBorder(),
                                          prefixIcon:
                                              Icon(Icons.watch_later_outlined),
                                        ),
                                        controller: timeController,
                                        keyboardType: TextInputType.text,
                                      ),
                                      const SizedBox(height: 20),
                                      DropdownButtonFormField(
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Category must not be empty';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Task category',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.category),
                                        ),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'home',
                                            child: Text('Home Task'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'work',
                                            child: Text('Work Task'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'school',
                                            child: Text('School Task'),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          category = value.toString();
                                        },
                                        value: category,
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        height: 50,
                                        width: double.infinity,
                                        child: MaterialButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              cubit.insertToDatabase(
                                                  title: titleController.text,
                                                  date: dateController.text,
                                                  time: timeController.text,
                                                  category: category!);
                                              titleController.clear();
                                              timeController.clear();
                                              dateController.clear();
                                              category = null;
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text(
                                            'Add',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).whenComplete(() {
                    titleController.clear();
                    timeController.clear();
                    dateController.clear();
                    category = null;
                  });
                }),
            body: state is AppLoadingGetDataFromDatabase
                ? const Center(child: CircularProgressIndicator())
                : cubit.screens[cubit.cuttentIndex],
          );
        },
      ),
    );
  }
}
