import 'dart:io';

void main() {
  print("Enter Your age");
  try {
    int age = int.parse(stdin.readLineSync()!);
    if (age < 0 || age > 100) {
      print("Enter valid age 0 - 100");
    } else {
      print("You have ${100 - age} years left you turn  100 ");
    }
  } catch (message) {
    print("Error - > $message\n");
  }
}
