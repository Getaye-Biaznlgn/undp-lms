import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class OnboardingSlide extends Equatable {
  final String id;
  final String title;
  final String description;
  final IconData? icon;
  final Color color;
  final String? imageUrl;

  const OnboardingSlide({
    required this.id,
    required this.title,
    required this.description,
    this.icon,
    required this.color,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        icon,
        color,
        imageUrl,
      ];
}
