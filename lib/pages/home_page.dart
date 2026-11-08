import 'package:flutter/material.dart';
import '../models/task.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyTask App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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
                          trailing: Text(
                            task.isCompleted ? 'Selesai' : 'Belum Selesai',
                            style: TextStyle(
                              color: task.isCompleted
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
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
