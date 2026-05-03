import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    if (auth is! AuthSignedIn) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final user = auth.user;
    final isWorker = user.roles.isWorker;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Center(
            child: CircleAvatar(
              radius: 36,
              child: Text(
                (user.name?.isNotEmpty ?? false) ? user.name![0] : user.phone[0],
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              user.name?.isNotEmpty == true ? user.name! : user.phone,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Center(child: Text(user.phone)),
          const SizedBox(height: 24),
          if (!isWorker)
            ListTile(
              leading: const Icon(Icons.handyman_outlined),
              title: const Text('Ustachi profilini ochish'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/role'),
            )
          else ...[
            const ListTile(
              leading: Icon(Icons.verified_user, color: Colors.green),
              title: Text('Ustachi profili faol'),
            ),
            ListTile(
              leading: const Icon(Icons.directions_walk),
              title: const Text('Ko\u2018chada rejim'),
              subtitle: const Text(
                  'Yaqin atrofdagi mijozlar sizni topa olsin'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/street-mode'),
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Chiqish'),
            onTap: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
