import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mytask_app/main.dart';

void main() {
  testWidgets('MyTask App menampilkan daftar tugas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyTaskApp());

    expect(find.text('MyTask App'), findsOneWidget);

    expect(
      find.text('Daftar Tugas Kuliah'),
      findsOneWidget,
    );

    expect(
      find.text('Membuat UI Flutter'),
      findsOneWidget,
    );

    expect(
      find.byType(ListView),
      findsOneWidget,
    );
  });
}
