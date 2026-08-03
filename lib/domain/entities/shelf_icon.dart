import 'package:flutter/material.dart';

/// Set curato di icone tra cui scegliere per una libreria personale: evita
/// di salvare codePoint di IconData (fragili tra versioni del font Material)
/// e mantiene la UI di scelta semplice.
enum ShelfIcon {
  book(Icons.menu_book_outlined),
  favorite(Icons.favorite_outline),
  star(Icons.star_outline),
  school(Icons.school_outlined),
  work(Icons.work_outline),
  nature(Icons.park_outlined),
  scienceFiction(Icons.rocket_launch_outlined),
  history(Icons.account_balance_outlined),
  language(Icons.translate_outlined),
  theater(Icons.theater_comedy_outlined);

  const ShelfIcon(this.data);
  final IconData data;

  String get storageName => name;

  static ShelfIcon fromStorageName(String value) => ShelfIcon.values.firstWhere(
    (i) => i.storageName == value,
    orElse: () => ShelfIcon.book,
  );
}
