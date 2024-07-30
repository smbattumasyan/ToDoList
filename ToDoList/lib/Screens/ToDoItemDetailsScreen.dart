import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/Model/Task.dart';
import '../App/AppRoutes.dart';
import '../App/TaskManager.dart';
import '../Base/WSC.dart';
import '../utils/CustomFonts.dart';

class ToDoItemDetailsScreenController extends StateController {
  final List<Task> tasks = [];
  final taskManager = TaskManager();
  final DateTime dateTime;
  bool isEditing = false;
  int? editingTaskId;

  ToDoItemDetailsScreenController(this.dateTime);

  @override
  void init() {
    taskManager.groupTasks();
  }

  List<Task> getSelectedTask() {
    return taskManager.tasksGroupedByDate[dateTime] ?? [];
  }
}

class ToDoItemDetailsScreen extends StatefulWidget {
  final DateTime dateTime;

  ToDoItemDetailsScreen({Key? key, required this.dateTime}) : super(key: key);

  @override
  State<ToDoItemDetailsScreen> createState() =>
      ToDoItemDetailsScreenState(dateTime);
}

class ToDoItemDetailsScreenState extends StateWithController<
    ToDoItemDetailsScreen, ToDoItemDetailsScreenController> {
  final TextEditingController _taskController = TextEditingController();
  final DateTime dateTime;

  ToDoItemDetailsScreenState(this.dateTime);

  DateTime selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Initialization code here
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
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Row(
                children: [
                  buildGoBackButton(context),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${DateFormat('yyyy-MM-dd').format(controller.getSelectedTask().first.date)} (${controller.getSelectedTask().length})",
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 24),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: buildTaskCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGoBackButton(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.taskManager.groupTasks();
        Navigator.of(context).pop(); // Navigate back on tap
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        // Adjust padding as needed
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFF2F2F7), width: 1),
          // 1px border with color #F2F2F7
          borderRadius: BorderRadius.circular(4), // Rounded corners
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min, // Use minimum space
          children: [
            Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 16, // Adjust icon size as needed
            ),
            SizedBox(width: 8),
            Text(
              "Go Back",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: controller.getSelectedTask().asMap().entries.map((entry) {
            int index = entry.key;
            var task = entry.value;
            bool isEditing = controller.editingTaskId ==
                task.taskId; // Assuming task has a unique taskId

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: isEditing
                  ? EditTaskCell(
                      initialTitle: task.taskName,
                      onCancel: () {
                        setState(() {
                          controller.editingTaskId = null; // Stop editing
                        });
                      },
                      onSave: (newTitle) {
                        setState(() {
                          task.taskName = newTitle; // Update the task name
                          controller.editingTaskId = null; // Stop editing
                          controller.taskManager.updateTask(
                              task); // Update the task in the task manager
                        });
                      },
                    )
                  : TaskDetailsCell(
                      title: task.taskName,
                      isSelected: task.isCompleted,
                      onEdit: () {
                        setState(() {
                          controller.editingTaskId =
                              task.taskId; // Start editing this task
                        });
                      },
                      onRemove: () {
                        setState(() {
                          controller.taskManager.removeTask(task.taskId);
                        });
                      },
                      onToggleSelect: () {
                        // Implement toggle select logic here
                        // task.isCompleted = !task.isCompleted;
                        setState(() {
                          task.isCompleted =
                              !task.isCompleted; // Start editing this task
                        });
                      },
                    ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildCheckmarkWithTitle(String title, bool isSelected) {
    return Container(
      height: 48.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Row(
        children: [
          Container(
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.white,
              // Green background for selected, white for unselected
              borderRadius: BorderRadius.circular(8.0),
              // 8px corner radius
              border: isSelected
                  ? null
                  : Border.all(
                      color: Color(0xFF8E8E93),
                      width: 1), // 1px border for unselected state
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null, // Checkmark for selected state
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStateTitle(String title) {
    bool isSelected = false;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return InkWell(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
          child: Container(
            height: 48.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              border: isSelected
                  ? Border.all(color: Colors.blue, width: 1.0)
                  : null,
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF2B2B2B),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
  ToDoItemDetailsScreenController createController() =>
      ToDoItemDetailsScreenController(dateTime);
}

class TaskDetailsCell extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onEdit;
  final VoidCallback onRemove;
  final VoidCallback onToggleSelect; // Added callback for toggling selection

  const TaskDetailsCell({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onEdit,
    required this.onRemove,
    required this.onToggleSelect, // Require the callback in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      // Prevents Material from introducing any new colors
      child: InkWell(
        onTap: onToggleSelect, // Use the callback when the cell is tapped
        child: Container(
          height: 48.0,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: isSelected
                          ? null
                          : Border.all(color: Color(0xFF8E8E93), width: 1),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      decoration: isSelected
                          ? TextDecoration.lineThrough
                          : TextDecoration
                              .none, // Apply strikethrough if isSelected is true
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: onEdit,
                    child: const Icon(Icons.edit, color: Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: onRemove,
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditTaskCell extends StatefulWidget {
  final String initialTitle;
  final VoidCallback onCancel;
  final Function(String) onSave; // Updated to accept a String

  const EditTaskCell({
    Key? key,
    required this.initialTitle,
    required this.onCancel,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditTaskCellState createState() => _EditTaskCellState();
}

class _EditTaskCellState extends State<EditTaskCell> {
  late TextEditingController textEditingController; // Use TextEditingController

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(
        text: widget.initialTitle); // Initialize in initState
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        editTitle(),
        bottomButtons(),
      ],
    );
  }

  Widget editTitle() {
    return Container(
      height: 48.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        border: Border.all(color: Colors.blue, width: 1.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textEditingController, // Use the controller
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                color: Color(0xFF2B2B2B),
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          children: [
            const Spacer(),
            InkWell(
              onTap: widget.onCancel,
              child: Container(
                height: 40.0,
                width: 105.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => widget.onSave(textEditingController.text),
              // Pass the current text to onSave
              child: Container(
                height: 40.0,
                width: 105.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A85F7),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
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
}
