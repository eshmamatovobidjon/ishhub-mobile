import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JobsTab extends StatelessWidget {
  const JobsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mening ishlarim')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Hozircha ishlaringiz yo\u02bcq.\nYangi ish e\u02bclon qiling.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/jobs/new'),
        icon: const Icon(Icons.add),
        label: const Text('Yangi ish'),
      ),
    );
  }
}
