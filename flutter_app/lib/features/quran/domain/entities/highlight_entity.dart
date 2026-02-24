import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HighlightEntity extends Equatable {
  final String id;
  final int surahNumber;
  final int ayahNumber;
  final Color color;
  final DateTime createdAt;

  const HighlightEntity({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.color,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}