import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/walk.dart';

class WalkViewModel extends ChangeNotifier {
  final List<Walk> _walks = [];
  // final DatabaseHelper _dbHelper = DatabaseHelper._();

  List<Walk> get walks => _walks;

  Future<void> loadWalks() async {
    // _walks.clear();
    // _walks.addAll(await _dbHelper.getAllWalks());
    // notifyListeners();
  }

  Future<void> addWalk(Walk walk) async {
    // await _dbHelper.insertWalk(walk);
    // await loadWalks();
  }
}
