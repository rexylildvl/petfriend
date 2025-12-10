import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pet_provider.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import 'home_page.dart';

class PetSetupPage extends StatefulWidget {
  const PetSetupPage({super.key});

  @override
  State<PetSetupPage> createState() => _PetSetupPageState();
}

class _PetSetupPageState extends State<PetSetupPage> {
  final TextEditingController _petNameController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _petNameController.dispose();
    super.dispose();
  }

  Future<void> _createPet() async {
    final petName = _petNameController.text.trim();
    if (petName.isEmpty) {
      setState(() => _error = 'Please choose a name for your pet.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final pet = await SupabaseService.instance.createPet(petName);
      final setup = await SupabaseService.instance.ensureSetup();
      if (!mounted) return;
      context.read<PetProvider>().init(setup.userId, pet.name);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } catch (e) {
      setState(() => _error = 'Failed to create pet: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryLight,
                  ),
                  child: const Icon(Icons.pets, size: 48, color: AppTheme.primary),
                ),
                const SizedBox(height: 18),
                Text('Name Your Pet', style: AppTheme.heading1.copyWith(color: AppTheme.primaryDark)),
                const SizedBox(height: 6),
                Text(
                  'Give your new friend a special name!',
                  style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _petNameController,
                  decoration: InputDecoration(
                    labelText: 'Pet Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                if (_error != null)
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createPet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Create Pet',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
