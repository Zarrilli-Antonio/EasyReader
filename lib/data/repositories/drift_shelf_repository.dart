import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/shelf.dart';
import '../../domain/entities/shelf_icon.dart';
import '../../domain/repositories/shelf_repository.dart';
import '../local/database/app_database.dart';

class DriftShelfRepository implements ShelfRepository {
  final AppDatabase _db;
  DriftShelfRepository(this._db);

  @override
  Stream<List<Shelf>> watchAll() {
    final query = _db.select(_db.shelves)
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<void> add(Shelf shelf) {
    return _db
        .into(_db.shelves)
        .insert(
          ShelvesCompanion.insert(
            id: shelf.id,
            name: shelf.name,
            color: shelf.color.toARGB32(),
            icon: shelf.icon.storageName,
            createdAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<void> update(Shelf shelf) {
    return (_db.update(_db.shelves)..where((t) => t.id.equals(shelf.id))).write(
      ShelvesCompanion(
        name: Value(shelf.name),
        color: Value(shelf.color.toARGB32()),
        icon: Value(shelf.icon.storageName),
      ),
    );
  }

  @override
  Future<void> delete(String shelfId) {
    return (_db.delete(_db.shelves)..where((t) => t.id.equals(shelfId))).go();
  }

  Shelf _toEntity(ShelfRow row) => Shelf(
    id: row.id,
    name: row.name,
    color: Color(row.color),
    icon: ShelfIcon.fromStorageName(row.icon),
  );
}
