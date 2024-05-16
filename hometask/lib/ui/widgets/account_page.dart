import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/avatar.dart';
import '../../main.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();

  String? _avatarUrl;
  var _loading = true;

  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = supabase.auth.currentSession!.user.id;
      final data =
      await supabase.from('profiles').select().eq('id', userId).single();
      _usernameController.text = (data['username'] ?? '') as String;
      _websiteController.text = (data['website'] ?? '') as String;
      _avatarUrl = (data['avatar_url'] ?? '') as String;
    } on PostgrestException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Произошла непредвиденная ошибка'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  /// Called when user taps `Update` button
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final userName = _usernameController.text.trim();
    final website = _websiteController.text.trim();
    final user = supabase.auth.currentUser;
    final updates = {
      'id': user!.id,
      'username': userName,
      'website': website,
      'updated_at': DateTime.now().toIso8601String(),
    };
    try {
      await supabase.from('profiles').upsert(updates);
      if (mounted) {
        const SnackBar(
          content: Text('Профиль успешно обновлен!'),
        );
      }
    } on PostgrestException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Произошла непредвиденная ошибка'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Произошла непредвиденная ошибка'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  /// Called when image has been uploaded to Supabase storage from within Avatar widget
  Future<void> _onUpload(String imageUrl) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase.from('profiles').upsert({
        'id': userId,
        'avatar_url': imageUrl,
      });
      if (mounted) {
        const SnackBar(
          content: Text('Изображение вашего профиля обновлено!'),
        );
      }
    } on PostgrestException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Произошла непредвиденная ошибка'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _avatarUrl = imageUrl;
    });
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _goToHome(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade800.withOpacity(0.8),
              Colors.green.shade200.withOpacity(0.8),
            ],
          ),
        ),
        child: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
              Avatar(
                imageUrl: _avatarUrl,
                onUpload: _onUpload,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Ваше имя'),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(labelText: 'Статус'),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _loading ? null : _updateProfile,
                child: Text(_loading ? 'Сохранение...' : 'Обновить'),
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: _signOut,
                child: const Text(
                  'Выход',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              /*const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () => _goToHome(context),
                child: const Text('Скачать треки'),
              ),*/
          ],
        ),
      )
    );
  }
}