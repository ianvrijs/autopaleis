import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/review_model.dart';

class ReviewsService with ChangeNotifier {
  static const _storageKey = 'car_reviews';

  Map<String, List<ReviewModel>> _reviews = {};

  List<ReviewModel> getReviews(String carId) {
    return _reviews[carId] ?? [];
  }

  Future<void> loadReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null) return;

    final Map<String, dynamic> decoded = json.decode(jsonString);

    _reviews = decoded.map((key, value) {
      final list = (value as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList();
      return MapEntry(key, list);
    });

    notifyListeners();
  }

  Future<void> addReview(String carId, ReviewModel review) async {
    _reviews.putIfAbsent(carId, () => []);
    _reviews[carId]!.insert(0, review);

    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonMap = _reviews.map((key, value) {
      return MapEntry(
        key,
        value.map((e) => e.toJson()).toList(),
      );
    });

    await prefs.setString(_storageKey, json.encode(jsonMap));
  }
}
