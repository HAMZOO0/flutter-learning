import 'dart:io'; // Keep only the required imports

void main() {
  List<String> task = [];
  int? choice;
  String? newTask;

  // var chooice ?;
  while (choice != 4) {
    print("\n1 : Add a task");
    print("2 : View tasks");
    print("3 : Remove a task");
    print("4 : Exit");

    print("Enter your choice:");
    choice = int.parse(stdin.readLineSync()!);

    if (choice == 1) {
      print("+ add new Task :");
      newTask = stdin.readLineSync()!;
      task.add(newTask);
    } else if (choice == 2) {
      for (var index in task) {
        print(index);
      }
    } else if (choice == 3) {
      print("Enter task number ");
      int taskDel = int.parse(stdin.readLineSync()!);
      print("✅ Removed Task: ${task[taskDel - 1]}");
      task.removeAt(taskDel - 1);
    }
  }
}
