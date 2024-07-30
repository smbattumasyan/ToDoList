import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/Model/Task.dart';
import '../App/AppRoutes.dart';
import '../App/TaskManager.dart';
import '../Base/WSC.dart';
import '../utils/CustomFonts.dart';

class ToDoListScreenController extends StateController {
  void navigateToDetailsScreen(DateTime dateTime) => Navigator.push(context, AppRoutes.toDoItemDetailsScreen(dateTime));
  var taskName = "New Task";
  final taskManager = TaskManager();

  @override
  void init() {
    taskManager.groupTasks();
  }

  @override
  void unload() {
    // Clean up controller state if needed
  }

  void updateTaskName(String newName) {
    taskName = newName;
  }

  int generateRandomInt(int min, int max) {
    final _random = Random();
    return min + _random.nextInt(max - min + 1);
  }
}

class ToDoListScreen extends StatefulWidget {
  ToDoListScreen({Key? key}) : super(key: key);

  @override
  State<ToDoListScreen> createState() => ToDoListScreenState();
}

class ToDoListScreenState
    extends StateWithController<ToDoListScreen, ToDoListScreenController> {
  final TextEditingController _taskController = TextEditingController();

  DateTime selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _taskController.addListener(() {
      controller.updateTaskName(_taskController.text);
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 55),
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "To Do List",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: buildTaskCard(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: buildDatesCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTaskCard() {
    return Card(
      color: const Color(0xFFF2F2F7), // Background color for Card
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "New Task",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            buildTextField(),
            buildDatePicker(context),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    controller.taskManager.tasks.add(Task(
                      taskId: controller.generateRandomInt(0, 99999999),
                      taskName: controller.taskName.isEmpty ? "New Task" : controller.taskName,
                      date: selectedDateTime,
                      isCompleted: false,
                    ));
                    controller.taskManager.groupTasks();
                    setState(() {
                      _taskController.clear();
                    });
                  },
                  child: Container(
                    height: 40.0,
                    width: 105.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A85F7), // Background color
                      borderRadius: BorderRadius.circular(8.0), // Corner radius
                    ),
                    child: const Center(
                      child: Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontWeight: FontWeight.w700, // Font weight
                          fontSize: 16, // Font size
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDatesCard() {
    return Card(
      color: Color(0xFFF2F2F7), // Background color for Card
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Dates",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            Column(
              children: controller.taskManager.tasksGroupedByDate.entries
                  .map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: TaskCell(
                            tasks:
                                entry.value, // Pass the list of tasks directly
                            count: entry.value.length,
                            onTap: () {
                              controller.navigateToDetailsScreen(entry.key);
                            }),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField() {
    return SizedBox(
      height: 48.0,
      child: TextField(
        controller: _taskController,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Type here",
          hintStyle: TextStyle(
              color: Color(0xFF8E8E93),
              fontWeight: FontWeight.w400,
              fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildDatePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => selectDate(context),
        child: Container(
          height: 48.0,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
            DateFormat('yyyy-MM-dd').format(selectedDateTime),
              style: const TextStyle(color: Color(0xFF8E8E93), fontWeight: FontWeight.w400, fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF8E8E93)),
          ],
        ),
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDateTime = picked;
      });
    }
  }

  @override
  ToDoListScreenController createController() => ToDoListScreenController();
}


class TaskCell extends StatelessWidget {
  final List<Task> tasks;
  final int count;
  final VoidCallback onTap; // Add a callback for tap events

  const TaskCell({
    super.key,
    required this.tasks,
    required this.count,
    required this.onTap, // Require the callback in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Use the callback here
      child: Container(
        height: 47.0,
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(4.0), // Corner radius
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${DateFormat('yyyy-MM-dd').format(tasks.first.date)} (${count})",
                style: const TextStyle(
                  color: Color(0xFF3A85F7), // Text color
                  fontWeight: FontWeight.w400, // Font weight
                  fontSize: 16, // Font size
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF3A85F7), // Icon color
                size: 16, // Icon size
              ),
            ],
          ),
        ),
      ),
    );
  }
}