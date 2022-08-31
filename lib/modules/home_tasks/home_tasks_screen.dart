import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/app_cubit.dart';
import '../../shared/cubit/app_states.dart';

class HomeTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        if (cubit.homeDoneTasks.isEmpty && cubit.homeTodoTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.table_rows_sharp,
                  size: 80,
                  color: Colors.grey,
                ),
                Text(
                  'No home tasks yet, Add some',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        } else if (cubit.homeDoneTasks.isEmpty) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        buildUncheckedItem(cubit.homeTodoTasks[index], context),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: cubit.homeTodoTasks.length),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      buildUncheckedItem(cubit.homeTodoTasks[index], context),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: cubit.homeTodoTasks.length),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Done tasks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      buildCheckedItem(cubit.homeDoneTasks[index], context),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: cubit.homeDoneTasks.length),
            ],
          ),
        );
      },
    );
  }
}
