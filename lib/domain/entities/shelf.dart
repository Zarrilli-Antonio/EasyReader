import 'package:flutter/material.dart';

import 'shelf_icon.dart';

/// Una libreria personale in cui l'utente raggruppa i propri libri
/// (es. "Fantascienza", "Da leggere"). Un libro appartiene al più a una
/// libreria per volta.
class Shelf {
  final String id;
  final String name;
  final Color color;
  final ShelfIcon icon;

  const Shelf({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  Shelf copyWith({String? name, Color? color, ShelfIcon? icon}) {
    return Shelf(
      id: id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }
}

/// Palette curata tra cui scegliere il colore di una libreria.
const shelfColorPalette = <Color>[
  Color(0xFF9C6A24),
  Color(0xFF2F6A78),
  Color(0xFFB0413E),
  Color(0xFF4C6B3B),
  Color(0xFF5B4B8A),
  Color(0xFFC98A3B),
  Color(0xFF3B5E8C),
  Color(0xFF7A5548),
];
