import 'package:flutter/material.dart';

void main() {
  runApp(const TaskDashboardApp());
}

class TaskDashboardApp extends StatelessWidget {
  const TaskDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Dashboard',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F1A),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<TaskModel> tasks = [
    TaskModel(
      title: 'تصميم التطبيق',
      description: 'إنشاء واجهة حديثة واحترافية',
      completed: false,
    ),
    TaskModel(
      title: 'برمجة النظام',
      description: 'إضافة قاعدة البيانات',
      completed: true,
    ),
  ];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void addTask() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) return;

    setState(() {
      tasks.add(
        TaskModel(
          title: title,
          description: description,
          completed: false,
        ),
      );
    });

    titleController.clear();
    descriptionController.clear();

    Navigator.of(context).pop(); // إغلاق الـ BottomSheet بشكل آمن
  }

  void showAddTaskDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF151A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 25,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'إضافة مهمة جديدة',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'اسم المهمة',
                  filled: true,
                  fillColor: const Color(0xFF1F263D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'وصف المهمة',
                  filled: true,
                  fillColor: const Color(0xFF1F263D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B61FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: addTask,
                  child: const Text(
                    'إضافة المهمة',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedTasks = tasks.where((e) => e.completed).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'لوحة المهام',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'مرحبًا بدر 👋',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'نظم مهامك بطريقة احترافية وحديثة',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: dashboardCard(
                      title: 'كل المهام',
                      value: '${tasks.length}',
                      icon: Icons.task_alt,
                      color: const Color(0xFF7B61FF),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: dashboardCard(
                      title: 'المكتملة',
                      value: '$completedTasks',
                      icon: Icons.done_all,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'المهام',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: tasks.isEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد مهام حالياً',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(bottom: 18),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFF151A2E),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      task.completed = !task.completed;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    height: 28,
                                    width: 28,
                                    decoration: BoxDecoration(
                                      color: task.completed
                                          ? Colors.green
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: task.completed
                                            ? Colors.green
                                            : Colors.white30,
                                        width: 2,
                                      ),
                                    ),
                                    child: task.completed
                                        ? const Icon(Icons.check, size: 18)
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          decoration: task.completed
                                              ? TextDecoration.lineThrough
                                              : null,
                                          color: task.completed
                                              ? Colors.white54
                                              : Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        task.description,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      tasks.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF7B61FF),
        onPressed: showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('إضافة'),
      ),
    );
  }

  Widget dashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.9),
            color.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 34),
          const SizedBox(height: 18),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class TaskModel {
  String title;
  String description;
  bool completed;

  TaskModel({
    required this.title,
    required this.description,
    required this.completed,
  });
}