import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/Todo.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<Todo> todos = [];
TextEditingController _title = TextEditingController();
TextEditingController _editTitle = TextEditingController();
bool multipleSelect = false;
List<dynamic> deletedList = [];

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Checkbox(
          value: multipleSelect,
          onChanged: (value) {
            setState(() {
              multipleSelect = !multipleSelect;
            });
          },
        ),
        title: const Text("To-do-list", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          multipleSelect == true
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.black,
                  onPressed: () {
                    for (int i = 0; i < todos.length; i++) {
                      for (int x = 0; x < deletedList.length; x++) {
                        todos.removeWhere((item) => item.id == deletedList[x]);
                      }
                    }
                    setState(() {
                      multipleSelect = false;
                      deletedList = [];
                    });
                  },
                )
              : const SizedBox(),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: todos.isNotEmpty
          ? ListView.builder(
              itemCount: todos.length,
              itemBuilder: (BuildContext context, index) {
                return InkWell(
                  child: Card(
                    child: ListTile(
                      leading: multipleSelect == true
                          ? Checkbox(
                              value: deletedList.contains(todos[index].id),
                              onChanged: (value) {
                                var searchItem =
                                    deletedList.contains(todos[index].id);
                                setState(() {
                                  if (searchItem == false) {
                                    deletedList.add(todos[index].id);
                                  } else {
                                    deletedList.remove(todos[index].id);
                                  }
                                });
                              },
                            )
                          : const SizedBox(),
                      title: Text(todos[index].title),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  deleteTodo(index);
                                });
                              },
                            ),
                            IconButton(
                              icon: todos[index].isDone == true
                                  ? const Icon(Icons.beenhere)
                                  : const Icon(Icons.beenhere_outlined),
                              onPressed: () {
                                setState(() {
                                  todos[index].isDone = !todos[index].isDone;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    _editTitle.text = todos[index].title;
                    bool isChecked = todos[index].isDone;
                    editShowModalBottomSheet(context, index, isChecked);
                  },
                );
              },
            )
          : const Center(
              child: Text(
                "Not found todos.",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          addTodoShowModalBottomSheet(context);
        },
      ),
    );
  }

  void editShowModalBottomSheet(
      BuildContext context, int index, bool isChecked) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        print(todos[index].id);
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text("Task name:",
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    child: TextFormField(
                      controller: _editTitle,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        const Text(
                          "Is done?",
                          style: TextStyle(fontSize: 20),
                        ),
                        Transform.scale(
                          scale: 1.6,
                          child: Checkbox(
                            value: isChecked,
                            shape: const CircleBorder(),
                            onChanged: (value) {
                              setState(() {
                                isChecked = !isChecked;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 24,
                          ),
                          shape: const StadiumBorder(),
                        ),
                        child:
                            const Text("Save", style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          if (_editTitle.text.isEmpty == true) {
                            Get.defaultDialog(
                              title: "Error",
                              content: const Text("Please input task name."),
                              actions: [
                                TextButton(
                                  child: const Text("Okey"),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ],
                            );
                          } else {
                            setState(() {
                              editTodo(
                                  todos[index].id, _editTitle.text, isChecked);
                            });
                            Get.back();
                            Get.snackbar("Successful",
                                "The task has been successfully edited.");
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void addTodoShowModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text("Task name:",
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 20),
                      controller: _title,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 35,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 24,
                            ),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            "Add",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            if (_title.text.isEmpty == true) {
                              Get.defaultDialog(
                                title: "Error",
                                content: const Text("Please input task name."),
                                actions: [
                                  TextButton(
                                    child: const Text("Okey"),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                ],
                              );
                            } else {
                              setState(() {
                                addTodo(_title.text);
                              });
                              Get.back();
                              Get.snackbar(
                                "Successfully",
                                "The task has been successfully added.",
                              );
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).whenComplete(() {
      setState(() {
        _title.text = "";
      });
    });
  }

  void addTodo(String title) {
    int id = todos.isEmpty == true ? 0 : todos.last.id + 1;
    todos.add(Todo(id, title, false));
    print(id);
  }

  void editTodo(int id, String newTitle, bool isChecked) {
    var item = todos.where((x) => x.id == id);
    setState(() {
      item.first.title = newTitle;
      item.first.isDone = isChecked;
    });
  }

  void deleteTodo(int id) {
    todos.removeAt(id);
  }
}
