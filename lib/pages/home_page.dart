import 'package:flutter/material.dart';
import '../models/task.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> tasks = [
    Task(
      id: 1,
      title: 'Membuat UI Flutter',
      course: 'Pemrograman Mobile Lanjut',
      deadline: DateTime(2026, 11, 15),
    ),
    Task(
      id: 2,
      title: 'Membuat Laporan Basis Data',
      course: 'Basis Data',
      deadline: DateTime(2026, 11, 18),
    ),
  ];

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _openAddTaskPage() async {
    final newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskPage(),
      ),
    );

    if (!mounted) return;

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
      });
    }
  }

  void _toggleTaskStatus(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  Future<void> _deleteTask(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Tugas'),
          content: Text(
            'Apakah Anda yakin ingin menghapus "${task.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (confirmed == true) {
      setState(() {
        tasks.removeWhere((item) => item.id == task.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tugas berhasil dihapus'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyTask App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTaskPage,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Tugas'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Daftar Tugas Kuliah',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text('Belum ada tugas'),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text(
                            task.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${task.course}\n'
                            'Deadline: ${formatDate(task.deadline)}',
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: task.isCompleted,
                                onChanged: (value) {
                                  _toggleTaskStatus(task);
                                },
                              ),
                              IconButton(
                                onPressed: () => _deleteTask(task),
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                tooltip: 'Hapus tugas',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
