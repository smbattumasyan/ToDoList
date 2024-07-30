import '../Model/Task.dart';

class TaskManager {
  static final TaskManager _instance = TaskManager._internal();
  Map<DateTime, List<Task>> tasksGroupedByDate = {};

  factory TaskManager() {
    return _instance;
  }

  TaskManager._internal();

  final List<Task> tasks = [
    Task(taskName: "taskName", date: DateTime.now(), isCompleted: false, taskId: 1),
    Task(taskName: "taskNamee", date: DateTime.now(), isCompleted: false, taskId: 2),
  ];

  void groupTasks() {
    tasksGroupedByDate = {};
    for (var task in tasks) {
      DateTime dateOnly = DateTime(task.date.year, task.date.month, task.date.day); // Remove time part
      if (!tasksGroupedByDate.containsKey(dateOnly)) {
        tasksGroupedByDate[dateOnly] = [];
      }
      tasksGroupedByDate[dateOnly]!.add(task);
    }
  }

  void addTask(Task newTask) {
    tasks.add(newTask);
    groupTasks();
  }

  void removeTask(int taskId) {
    tasks.removeWhere((task) => task.taskId == taskId);
    groupTasks();
  }

  void updateTask(Task updatedTask) {
    int index = tasks.indexWhere((task) => task.taskId == updatedTask.taskId);
    if (index != -1) {
      tasks[index] = updatedTask;
      groupTasks();
    }
  }
}