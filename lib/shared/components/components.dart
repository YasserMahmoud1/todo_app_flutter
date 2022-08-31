import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/app_cubit.dart';

Widget buildUncheckedItem(Map modle, context) {
  return Dismissible(
    key: Key(modle['id'].toString()),
    onDismissed: ((direction) {
      AppCubit.get(context).deleteData(id: modle['id']);
    }),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[300],
        ),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateDatebase(done: true, id: modle['id']);
                },
                icon: const Icon(Icons.check_box_outline_blank)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    modle['title'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                      ),
                      Text(
                        modle['date'],
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              modle['time'],
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildCheckedItem(Map modle, context) {
  return Dismissible(
    key: Key(modle['id'].toString()),
    onDismissed: ((direction) {
      AppCubit.get(context).deleteData(id: modle['id']);
    }),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[300],
        ),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateDatebase(done: false, id: modle['id']);
                },
                icon: const Icon(
                  Icons.check_box,
                  color: Color.fromARGB(255, 100, 100, 100),
                )),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    modle['title'],
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                        color: Color.fromARGB(255, 100, 100, 100)),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month,
                          color: Color.fromARGB(255, 100, 100, 100)),
                      Text(
                        modle['date'],
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 100, 100, 100),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              modle['time'],
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 100, 100, 100),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
