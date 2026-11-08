import 'package:flutter/material.dart';
import '../models/task.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const primary = Color(0xFF3558DE);
  static const dark = Color(0xFF18213B);
  static const muted = Color(0xFF78839A);
  static const borderColor = Color(0xFFE9EDF5);

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

  // Mengurutkan tugas berdasarkan status dan deadline.
  List<Task> get sortedTasks {
    final sorted = List<Task>.from(tasks);

    sorted.sort((a, b) {
      // Belum selesai selalu berada di atas.
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      // Deadline paling awal berada di atas.
      final deadlineResult = a.deadline.compareTo(b.deadline);

      if (deadlineResult != 0) {
        return deadlineResult;
      }

      // Menjaga urutan konsisten jika deadline sama.
      return a.id.compareTo(b.id);
    });

    return sorted;
  }

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  bool _isOverdue(Task task) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final deadline = DateTime(
      task.deadline.year,
      task.deadline.month,
      task.deadline.day,
    );

    return !task.isCompleted && deadline.isBefore(today);
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
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Tugas?'),
          content: Text(
            'Apakah Anda yakin ingin menghapus "${task.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      tasks.removeWhere((item) => item.id == task.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tugas berhasil dihapus'),
      ),
    );
  }

  // Kartu statistik dengan lebar responsif.
  Widget _statCard(
    String label,
    int number,
    IconData icon,
    Color color,
    double width,
  ) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 23,
            ),
            const SizedBox(height: 10),
            Text(
              '$number',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 2,
              softWrap: true,
              style: const TextStyle(
                color: muted,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Layout statistik menyesuaikan lebar layar.
  Widget _buildStatistics(int completed, int pending) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;

        final availableWidth = constraints.maxWidth;

        // Smartphone: 2 kolom.
        // Layar lebih lebar: 3 kolom.
        final columns = availableWidth >= 520 ? 3 : 2;

        final cardWidth = (availableWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            _statCard(
              'Total Tugas',
              tasks.length,
              Icons.folder_outlined,
              primary,
              cardWidth,
            ),
            _statCard(
              'Selesai',
              completed,
              Icons.check_circle_outline,
              const Color(0xFF13865B),
              cardWidth,
            ),
            _statCard(
              'Belum Selesai',
              pending,
              Icons.schedule_outlined,
              const Color(0xFFE59A28),
              columns == 2 ? availableWidth : cardWidth,
            ),
          ],
        );
      },
    );
  }

  // Kartu tugas responsif.
  Widget _taskCard(Task task) {
    final done = task.isCompleted;
    final overdue = _isOverdue(task);

    final statusText = done
        ? 'Selesai'
        : overdue
            ? 'Terlambat'
            : 'Belum Selesai';

    final statusBackground = done
        ? const Color(0xFFE0F6EA)
        : overdue
            ? const Color(0xFFFDE8E8)
            : const Color(0xFFFFF1DB);

    final statusColor = done
        ? const Color(0xFF13865B)
        : overdue
            ? const Color(0xFFC53B3B)
            : const Color(0xFFAA711B);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF1FF),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: primary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 10),

              // Expanded mencegah teks mendorong tombol hapus.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: dark,
                        decoration: done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      task.course,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () => _deleteTask(task),
                tooltip: 'Hapus tugas',
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFE05252),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Divider(
            color: Color(0xFFF0F2F7),
            height: 1,
          ),

          const SizedBox(height: 10),

          // Wrap mencegah bagian bawah kartu overflow.
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 16,
                    color: muted,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    formatDate(task.deadline),
                    style: const TextStyle(
                      fontSize: 12,
                      color: muted,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: done,
                    activeColor: primary,
                    visualDensity: VisualDensity.compact,
                    onChanged: (_) => _toggleTaskStatus(task),
                  ),
                  const Text(
                    'Selesai',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 45,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.task_alt_rounded,
            color: primary,
            size: 54,
          ),
          SizedBox(height: 12),
          Text(
            'Belum ada tugas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: dark,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Tambahkan tugas kuliah pertamamu.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: muted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where((task) => task.isCompleted).length;

    final pending = tasks.length - completed;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isSmallMobile = screenWidth < 360;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyTask App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.school_outlined,
              color: primary,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTaskPage,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Tugas'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              isSmallMobile ? 12 : 20,
              16,
              isSmallMobile ? 12 : 20,
              110,
            ),
            children: [
              // Greeting
              Text(
                'Halo, Fikri Andarlan! 👋',
                softWrap: true,
                style: TextStyle(
                  fontSize: isSmallMobile ? 21 : 25,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Yuk, kelola tugas kuliahmu hari ini.',
                style: TextStyle(
                  color: muted,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 24),

              // Banner produktivitas
              Container(
                padding: EdgeInsets.all(
                  isSmallMobile ? 16 : 20,
                ),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tetap Produktif!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            'Selesaikan tugas satu per satu '
                            'dan raih target belajarmu.',
                            style: TextStyle(
                              color: Color(0xFFE4E9FF),
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: isSmallMobile ? 30 : 42,
                      color: const Color(0xFFFFD972),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Statistik responsif
              _buildStatistics(completed, pending),

              const SizedBox(height: 28),

              const Text(
                'Daftar Tugas Kuliah',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Prioritas berdasarkan status dan deadline.',
                style: TextStyle(
                  fontSize: 12,
                  color: muted,
                ),
              ),

              const SizedBox(height: 14),

              // Daftar diurutkan otomatis.
              if (tasks.isEmpty)
                _buildEmptyState()
              else
                ...sortedTasks.map(_taskCard),
            ],
          ),
        ),
      ),
    );
  }
}
