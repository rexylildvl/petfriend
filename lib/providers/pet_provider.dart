import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum GrowthStage { baby, child, teen, adult }

class PetProvider extends ChangeNotifier {
  // Identity
  String _petName = 'Bobo';
  String get petName => _petName;

  // Core Stats (0-100)
  double _hunger = 50;
  double _energy = 80;
  double _happiness = 60;
  double _hygiene = 70;
  double _bladder = 30; // 0 = empty, 100 = full

  // Progression
  int _level = 1;
  double _xp = 0;
  double _xpToNextLevel = 100;
  GrowthStage _growthStage = GrowthStage.baby;

  // Economy
  int _coins = 100;

  // Getters
  double get hunger => _hunger;
  double get energy => _energy;
  double get happiness => _happiness;
  double get hygiene => _hygiene;
  double get bladder => _bladder;
  int get level => _level;
  double get xp => _xp;
  double get xpToNextLevel => _xpToNextLevel;
  GrowthStage get growthStage => _growthStage;
  int get coins => _coins;

  Timer? _decayTimer;
  final SupabaseClient _supabase = Supabase.instance.client;
  String? _userId;

  void init(String userId, String name) {
    _userId = userId;
    _petName = name;
    _loadState();
    _startDecayTimer();
  }

  Future<void> updateName(String newName) async {
    _petName = newName;
    notifyListeners();
    if (_userId != null) {
      try {
        await _supabase.from('pets').update({'name': newName}).eq('user_id', _userId!);
      } catch (e) {
        debugPrint("Error updating pet name: $e");
      }
    }
  }

  @override
  void dispose() {
    _decayTimer?.cancel();
    super.dispose();
  }

  // --- Actions ---

  void feed(double amount) {
    _hunger = (_hunger + amount).clamp(0, 100);
    _bladder = (_bladder + (amount * 0.5)).clamp(0, 100); // Eating fills bladder
    _gainXp(10);
    _saveState();
    notifyListeners();
  }

  void play() {
    if (_energy < 20) return; // Too tired
    _happiness = (_happiness + 15).clamp(0, 100);
    _energy = (_energy - 15).clamp(0, 100);
    _hunger = (_hunger - 10).clamp(0, 100);
    _hygiene = (_hygiene - 10).clamp(0, 100); // Get dirty
    _gainXp(15);
    _saveState();
    notifyListeners();
  }

  void sleep() {
    _energy = 100;
    _hunger = (_hunger - 20).clamp(0, 100);
    _gainXp(5);
    _saveState();
    notifyListeners();
  }

  void clean() {
    _hygiene = 100;
    _happiness = (_happiness + 5).clamp(0, 100);
    _gainXp(10);
    _saveState();
    notifyListeners();
  }

  void useToilet() {
    _bladder = 0;
    _hygiene = (_hygiene + 5).clamp(0, 100);
    _happiness = (_happiness + 10).clamp(0, 100);
    _gainXp(10);
    _saveState();
    notifyListeners();
  }

  // --- Progression ---

  void _gainXp(double amount) {
    _xp += amount;
    if (_xp >= _xpToNextLevel) {
      _levelUp();
    }
  }

  void _levelUp() {
    _level++;
    _xp = 0;
    _xpToNextLevel = _xpToNextLevel * 1.5;
    _coins += 50; // Level up reward
    _updateGrowthStage();
    notifyListeners();
  }

  void _updateGrowthStage() {
    if (_level < 5) {
      _growthStage = GrowthStage.baby;
    } else if (_level < 15) {
      _growthStage = GrowthStage.child;
    } else if (_level < 30) {
      _growthStage = GrowthStage.teen;
    } else {
      _growthStage = GrowthStage.adult;
    }
  }

  // --- Game Loop ---

  void _startDecayTimer() {
    _decayTimer?.cancel();
    _decayTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _decayStats();
    });
  }

  void _decayStats() {
    _hunger = (_hunger - 2).clamp(0, 100);
    _energy = (_energy - 1).clamp(0, 100);
    _happiness = (_happiness - 1).clamp(0, 100);
    _hygiene = (_hygiene - 0.5).clamp(0, 100);
    _bladder = (_bladder + 1).clamp(0, 100);
    
    // Auto-save every tick? Maybe too frequent. 
    // For now, let's save on actions and periodically.
    if (DateTime.now().minute % 5 == 0) {
      _saveState();
    }
    
    notifyListeners();
  }

  // --- Mood Calculation ---

  String get currentMood {
    if (_hunger < 30 && _energy < 30) return "Hangry";
    if (_hunger < 20) return "Starving";
    if (_energy < 20) return "Exhausted";
    if (_bladder > 80) return "Desperate";
    if (_hygiene < 30) return "Stinky";
    if (_happiness < 30) return "Depressed";
    if (_happiness > 80 && _energy > 80) return "Hyper";
    if (_happiness > 70) return "Happy";
    return "Neutral";
  }

  String get growthStageLabel => _growthStage.toString().split('.').last;

  // --- Persistence ---

  Future<void> _loadState() async {
    if (_userId == null) return;
    try {
      final data = await _supabase
          .from('pets')
          .select()
          .eq('user_id', _userId!)
          .maybeSingle();

      if (data != null) {
        _hunger = (data['hunger'] as num?)?.toDouble() ?? 50.0;
        _energy = (data['energy'] as num?)?.toDouble() ?? 80.0;
        _happiness = (data['happiness'] as num?)?.toDouble() ?? 60.0;
        _hygiene = (data['hygiene'] as num?)?.toDouble() ?? 70.0;
        _bladder = (data['bladder'] as num?)?.toDouble() ?? 30.0;
        _level = (data['level'] as num?)?.toInt() ?? 1;
        _xp = (data['xp'] as num?)?.toDouble() ?? 0.0;
        _coins = (data['coins'] as num?)?.toInt() ?? 100;
        _petName = (data['name'] as String?) ?? 'Bobo';
        _updateGrowthStage();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading pet state: $e");
    }
  }

  Future<void> _saveState() async {
    if (_userId == null) return;
    try {
      await _supabase.from('pets').update({
        'hunger': _hunger,
        'energy': _energy,
        'happiness': _happiness,
        'hygiene': _hygiene,
        'bladder': _bladder,
        'level': _level,
        'xp': _xp,
        'coins': _coins,
      }).eq('user_id', _userId!);
    } catch (e) {
      debugPrint("Error saving pet state: $e");
    }
  }
}
