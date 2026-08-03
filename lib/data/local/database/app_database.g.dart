// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ShelvesTable extends Shelves with TableInfo<$ShelvesTable, ShelfRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShelvesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color, icon, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shelves';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShelfRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShelfRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShelfRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ShelvesTable createAlias(String alias) {
    return $ShelvesTable(attachedDatabase, alias);
  }
}

class ShelfRow extends DataClass implements Insertable<ShelfRow> {
  final String id;
  final String name;
  final int color;
  final String icon;
  final DateTime createdAt;
  const ShelfRow({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    map['icon'] = Variable<String>(icon);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ShelvesCompanion toCompanion(bool nullToAbsent) {
    return ShelvesCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      icon: Value(icon),
      createdAt: Value(createdAt),
    );
  }

  factory ShelfRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShelfRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      icon: serializer.fromJson<String>(json['icon']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'icon': serializer.toJson<String>(icon),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ShelfRow copyWith({
    String? id,
    String? name,
    int? color,
    String? icon,
    DateTime? createdAt,
  }) => ShelfRow(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color ?? this.color,
    icon: icon ?? this.icon,
    createdAt: createdAt ?? this.createdAt,
  );
  ShelfRow copyWithCompanion(ShelvesCompanion data) {
    return ShelfRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShelfRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, icon, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShelfRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.createdAt == this.createdAt);
}

class ShelvesCompanion extends UpdateCompanion<ShelfRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> color;
  final Value<String> icon;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ShelvesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShelvesCompanion.insert({
    required String id,
    required String name,
    required int color,
    required String icon,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       color = Value(color),
       icon = Value(icon),
       createdAt = Value(createdAt);
  static Insertable<ShelfRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? color,
    Expression<String>? icon,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShelvesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? color,
    Value<String>? icon,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ShelvesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShelvesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BooksTable extends Books with TableInfo<$BooksTable, BookRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverPathMeta = const VerificationMeta(
    'coverPath',
  );
  @override
  late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
    'cover_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shelfIdMeta = const VerificationMeta(
    'shelfId',
  );
  @override
  late final GeneratedColumn<String> shelfId = GeneratedColumn<String>(
    'shelf_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shelves (id)',
    ),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastOpenedAtMeta = const VerificationMeta(
    'lastOpenedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastOpenedAt = GeneratedColumn<DateTime>(
    'last_opened_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    format,
    filePath,
    coverPath,
    shelfId,
    addedAt,
    lastOpenedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    } else if (isInserting) {
      context.missing(_formatMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('cover_path')) {
      context.handle(
        _coverPathMeta,
        coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
      );
    }
    if (data.containsKey('shelf_id')) {
      context.handle(
        _shelfIdMeta,
        shelfId.isAcceptableOrUnknown(data['shelf_id']!, _shelfIdMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    if (data.containsKey('last_opened_at')) {
      context.handle(
        _lastOpenedAtMeta,
        lastOpenedAt.isAcceptableOrUnknown(
          data['last_opened_at']!,
          _lastOpenedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      coverPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_path'],
      ),
      shelfId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shelf_id'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      lastOpenedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_opened_at'],
      ),
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }
}

class BookRow extends DataClass implements Insertable<BookRow> {
  final String id;
  final String title;
  final String format;
  final String filePath;
  final String? coverPath;
  final String? shelfId;
  final DateTime addedAt;
  final DateTime? lastOpenedAt;
  const BookRow({
    required this.id,
    required this.title,
    required this.format,
    required this.filePath,
    this.coverPath,
    this.shelfId,
    required this.addedAt,
    this.lastOpenedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['format'] = Variable<String>(format);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || coverPath != null) {
      map['cover_path'] = Variable<String>(coverPath);
    }
    if (!nullToAbsent || shelfId != null) {
      map['shelf_id'] = Variable<String>(shelfId);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    if (!nullToAbsent || lastOpenedAt != null) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt);
    }
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      title: Value(title),
      format: Value(format),
      filePath: Value(filePath),
      coverPath: coverPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPath),
      shelfId: shelfId == null && nullToAbsent
          ? const Value.absent()
          : Value(shelfId),
      addedAt: Value(addedAt),
      lastOpenedAt: lastOpenedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpenedAt),
    );
  }

  factory BookRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      format: serializer.fromJson<String>(json['format']),
      filePath: serializer.fromJson<String>(json['filePath']),
      coverPath: serializer.fromJson<String?>(json['coverPath']),
      shelfId: serializer.fromJson<String?>(json['shelfId']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      lastOpenedAt: serializer.fromJson<DateTime?>(json['lastOpenedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'format': serializer.toJson<String>(format),
      'filePath': serializer.toJson<String>(filePath),
      'coverPath': serializer.toJson<String?>(coverPath),
      'shelfId': serializer.toJson<String?>(shelfId),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'lastOpenedAt': serializer.toJson<DateTime?>(lastOpenedAt),
    };
  }

  BookRow copyWith({
    String? id,
    String? title,
    String? format,
    String? filePath,
    Value<String?> coverPath = const Value.absent(),
    Value<String?> shelfId = const Value.absent(),
    DateTime? addedAt,
    Value<DateTime?> lastOpenedAt = const Value.absent(),
  }) => BookRow(
    id: id ?? this.id,
    title: title ?? this.title,
    format: format ?? this.format,
    filePath: filePath ?? this.filePath,
    coverPath: coverPath.present ? coverPath.value : this.coverPath,
    shelfId: shelfId.present ? shelfId.value : this.shelfId,
    addedAt: addedAt ?? this.addedAt,
    lastOpenedAt: lastOpenedAt.present ? lastOpenedAt.value : this.lastOpenedAt,
  );
  BookRow copyWithCompanion(BooksCompanion data) {
    return BookRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      format: data.format.present ? data.format.value : this.format,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
      shelfId: data.shelfId.present ? data.shelfId.value : this.shelfId,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      lastOpenedAt: data.lastOpenedAt.present
          ? data.lastOpenedAt.value
          : this.lastOpenedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('format: $format, ')
          ..write('filePath: $filePath, ')
          ..write('coverPath: $coverPath, ')
          ..write('shelfId: $shelfId, ')
          ..write('addedAt: $addedAt, ')
          ..write('lastOpenedAt: $lastOpenedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    format,
    filePath,
    coverPath,
    shelfId,
    addedAt,
    lastOpenedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.format == this.format &&
          other.filePath == this.filePath &&
          other.coverPath == this.coverPath &&
          other.shelfId == this.shelfId &&
          other.addedAt == this.addedAt &&
          other.lastOpenedAt == this.lastOpenedAt);
}

class BooksCompanion extends UpdateCompanion<BookRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> format;
  final Value<String> filePath;
  final Value<String?> coverPath;
  final Value<String?> shelfId;
  final Value<DateTime> addedAt;
  final Value<DateTime?> lastOpenedAt;
  final Value<int> rowid;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.format = const Value.absent(),
    this.filePath = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.shelfId = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BooksCompanion.insert({
    required String id,
    required String title,
    required String format,
    required String filePath,
    this.coverPath = const Value.absent(),
    this.shelfId = const Value.absent(),
    required DateTime addedAt,
    this.lastOpenedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       format = Value(format),
       filePath = Value(filePath),
       addedAt = Value(addedAt);
  static Insertable<BookRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? format,
    Expression<String>? filePath,
    Expression<String>? coverPath,
    Expression<String>? shelfId,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? lastOpenedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (format != null) 'format': format,
      if (filePath != null) 'file_path': filePath,
      if (coverPath != null) 'cover_path': coverPath,
      if (shelfId != null) 'shelf_id': shelfId,
      if (addedAt != null) 'added_at': addedAt,
      if (lastOpenedAt != null) 'last_opened_at': lastOpenedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BooksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? format,
    Value<String>? filePath,
    Value<String?>? coverPath,
    Value<String?>? shelfId,
    Value<DateTime>? addedAt,
    Value<DateTime?>? lastOpenedAt,
    Value<int>? rowid,
  }) {
    return BooksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      format: format ?? this.format,
      filePath: filePath ?? this.filePath,
      coverPath: coverPath ?? this.coverPath,
      shelfId: shelfId ?? this.shelfId,
      addedAt: addedAt ?? this.addedAt,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (coverPath.present) {
      map['cover_path'] = Variable<String>(coverPath.value);
    }
    if (shelfId.present) {
      map['shelf_id'] = Variable<String>(shelfId.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (lastOpenedAt.present) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('format: $format, ')
          ..write('filePath: $filePath, ')
          ..write('coverPath: $coverPath, ')
          ..write('shelfId: $shelfId, ')
          ..write('addedAt: $addedAt, ')
          ..write('lastOpenedAt: $lastOpenedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FilterProfilesTable extends FilterProfiles
    with TableInfo<$FilterProfilesTable, FilterProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FilterProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _backgroundColorMeta = const VerificationMeta(
    'backgroundColor',
  );
  @override
  late final GeneratedColumn<int> backgroundColor = GeneratedColumn<int>(
    'background_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _overlayColorMeta = const VerificationMeta(
    'overlayColor',
  );
  @override
  late final GeneratedColumn<int> overlayColor = GeneratedColumn<int>(
    'overlay_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _overlayOpacityMeta = const VerificationMeta(
    'overlayOpacity',
  );
  @override
  late final GeneratedColumn<double> overlayOpacity = GeneratedColumn<double>(
    'overlay_opacity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _brightnessMeta = const VerificationMeta(
    'brightness',
  );
  @override
  late final GeneratedColumn<double> brightness = GeneratedColumn<double>(
    'brightness',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fontSizeMeta = const VerificationMeta(
    'fontSize',
  );
  @override
  late final GeneratedColumn<double> fontSize = GeneratedColumn<double>(
    'font_size',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(16),
  );
  static const VerificationMeta _paperFilterEnabledMeta =
      const VerificationMeta('paperFilterEnabled');
  @override
  late final GeneratedColumn<bool> paperFilterEnabled = GeneratedColumn<bool>(
    'paper_filter_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paper_filter_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    backgroundColor,
    overlayColor,
    overlayOpacity,
    brightness,
    fontSize,
    paperFilterEnabled,
    isDefault,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'filter_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<FilterProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('background_color')) {
      context.handle(
        _backgroundColorMeta,
        backgroundColor.isAcceptableOrUnknown(
          data['background_color']!,
          _backgroundColorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_backgroundColorMeta);
    }
    if (data.containsKey('overlay_color')) {
      context.handle(
        _overlayColorMeta,
        overlayColor.isAcceptableOrUnknown(
          data['overlay_color']!,
          _overlayColorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_overlayColorMeta);
    }
    if (data.containsKey('overlay_opacity')) {
      context.handle(
        _overlayOpacityMeta,
        overlayOpacity.isAcceptableOrUnknown(
          data['overlay_opacity']!,
          _overlayOpacityMeta,
        ),
      );
    }
    if (data.containsKey('brightness')) {
      context.handle(
        _brightnessMeta,
        brightness.isAcceptableOrUnknown(data['brightness']!, _brightnessMeta),
      );
    }
    if (data.containsKey('font_size')) {
      context.handle(
        _fontSizeMeta,
        fontSize.isAcceptableOrUnknown(data['font_size']!, _fontSizeMeta),
      );
    }
    if (data.containsKey('paper_filter_enabled')) {
      context.handle(
        _paperFilterEnabledMeta,
        paperFilterEnabled.isAcceptableOrUnknown(
          data['paper_filter_enabled']!,
          _paperFilterEnabledMeta,
        ),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FilterProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FilterProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      backgroundColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}background_color'],
      )!,
      overlayColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}overlay_color'],
      )!,
      overlayOpacity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}overlay_opacity'],
      )!,
      brightness: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}brightness'],
      )!,
      fontSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}font_size'],
      )!,
      paperFilterEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paper_filter_enabled'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
    );
  }

  @override
  $FilterProfilesTable createAlias(String alias) {
    return $FilterProfilesTable(attachedDatabase, alias);
  }
}

class FilterProfileRow extends DataClass
    implements Insertable<FilterProfileRow> {
  final String id;
  final String name;
  final int backgroundColor;
  final int overlayColor;
  final double overlayOpacity;
  final double brightness;
  final double fontSize;
  final bool paperFilterEnabled;
  final bool isDefault;
  const FilterProfileRow({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.overlayColor,
    required this.overlayOpacity,
    required this.brightness,
    required this.fontSize,
    required this.paperFilterEnabled,
    required this.isDefault,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['background_color'] = Variable<int>(backgroundColor);
    map['overlay_color'] = Variable<int>(overlayColor);
    map['overlay_opacity'] = Variable<double>(overlayOpacity);
    map['brightness'] = Variable<double>(brightness);
    map['font_size'] = Variable<double>(fontSize);
    map['paper_filter_enabled'] = Variable<bool>(paperFilterEnabled);
    map['is_default'] = Variable<bool>(isDefault);
    return map;
  }

  FilterProfilesCompanion toCompanion(bool nullToAbsent) {
    return FilterProfilesCompanion(
      id: Value(id),
      name: Value(name),
      backgroundColor: Value(backgroundColor),
      overlayColor: Value(overlayColor),
      overlayOpacity: Value(overlayOpacity),
      brightness: Value(brightness),
      fontSize: Value(fontSize),
      paperFilterEnabled: Value(paperFilterEnabled),
      isDefault: Value(isDefault),
    );
  }

  factory FilterProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FilterProfileRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      backgroundColor: serializer.fromJson<int>(json['backgroundColor']),
      overlayColor: serializer.fromJson<int>(json['overlayColor']),
      overlayOpacity: serializer.fromJson<double>(json['overlayOpacity']),
      brightness: serializer.fromJson<double>(json['brightness']),
      fontSize: serializer.fromJson<double>(json['fontSize']),
      paperFilterEnabled: serializer.fromJson<bool>(json['paperFilterEnabled']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'backgroundColor': serializer.toJson<int>(backgroundColor),
      'overlayColor': serializer.toJson<int>(overlayColor),
      'overlayOpacity': serializer.toJson<double>(overlayOpacity),
      'brightness': serializer.toJson<double>(brightness),
      'fontSize': serializer.toJson<double>(fontSize),
      'paperFilterEnabled': serializer.toJson<bool>(paperFilterEnabled),
      'isDefault': serializer.toJson<bool>(isDefault),
    };
  }

  FilterProfileRow copyWith({
    String? id,
    String? name,
    int? backgroundColor,
    int? overlayColor,
    double? overlayOpacity,
    double? brightness,
    double? fontSize,
    bool? paperFilterEnabled,
    bool? isDefault,
  }) => FilterProfileRow(
    id: id ?? this.id,
    name: name ?? this.name,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    overlayColor: overlayColor ?? this.overlayColor,
    overlayOpacity: overlayOpacity ?? this.overlayOpacity,
    brightness: brightness ?? this.brightness,
    fontSize: fontSize ?? this.fontSize,
    paperFilterEnabled: paperFilterEnabled ?? this.paperFilterEnabled,
    isDefault: isDefault ?? this.isDefault,
  );
  FilterProfileRow copyWithCompanion(FilterProfilesCompanion data) {
    return FilterProfileRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      backgroundColor: data.backgroundColor.present
          ? data.backgroundColor.value
          : this.backgroundColor,
      overlayColor: data.overlayColor.present
          ? data.overlayColor.value
          : this.overlayColor,
      overlayOpacity: data.overlayOpacity.present
          ? data.overlayOpacity.value
          : this.overlayOpacity,
      brightness: data.brightness.present
          ? data.brightness.value
          : this.brightness,
      fontSize: data.fontSize.present ? data.fontSize.value : this.fontSize,
      paperFilterEnabled: data.paperFilterEnabled.present
          ? data.paperFilterEnabled.value
          : this.paperFilterEnabled,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FilterProfileRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('overlayColor: $overlayColor, ')
          ..write('overlayOpacity: $overlayOpacity, ')
          ..write('brightness: $brightness, ')
          ..write('fontSize: $fontSize, ')
          ..write('paperFilterEnabled: $paperFilterEnabled, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    backgroundColor,
    overlayColor,
    overlayOpacity,
    brightness,
    fontSize,
    paperFilterEnabled,
    isDefault,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FilterProfileRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.backgroundColor == this.backgroundColor &&
          other.overlayColor == this.overlayColor &&
          other.overlayOpacity == this.overlayOpacity &&
          other.brightness == this.brightness &&
          other.fontSize == this.fontSize &&
          other.paperFilterEnabled == this.paperFilterEnabled &&
          other.isDefault == this.isDefault);
}

class FilterProfilesCompanion extends UpdateCompanion<FilterProfileRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> backgroundColor;
  final Value<int> overlayColor;
  final Value<double> overlayOpacity;
  final Value<double> brightness;
  final Value<double> fontSize;
  final Value<bool> paperFilterEnabled;
  final Value<bool> isDefault;
  final Value<int> rowid;
  const FilterProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.backgroundColor = const Value.absent(),
    this.overlayColor = const Value.absent(),
    this.overlayOpacity = const Value.absent(),
    this.brightness = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.paperFilterEnabled = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FilterProfilesCompanion.insert({
    required String id,
    required String name,
    required int backgroundColor,
    required int overlayColor,
    this.overlayOpacity = const Value.absent(),
    this.brightness = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.paperFilterEnabled = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       backgroundColor = Value(backgroundColor),
       overlayColor = Value(overlayColor);
  static Insertable<FilterProfileRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? backgroundColor,
    Expression<int>? overlayColor,
    Expression<double>? overlayOpacity,
    Expression<double>? brightness,
    Expression<double>? fontSize,
    Expression<bool>? paperFilterEnabled,
    Expression<bool>? isDefault,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (backgroundColor != null) 'background_color': backgroundColor,
      if (overlayColor != null) 'overlay_color': overlayColor,
      if (overlayOpacity != null) 'overlay_opacity': overlayOpacity,
      if (brightness != null) 'brightness': brightness,
      if (fontSize != null) 'font_size': fontSize,
      if (paperFilterEnabled != null)
        'paper_filter_enabled': paperFilterEnabled,
      if (isDefault != null) 'is_default': isDefault,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FilterProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? backgroundColor,
    Value<int>? overlayColor,
    Value<double>? overlayOpacity,
    Value<double>? brightness,
    Value<double>? fontSize,
    Value<bool>? paperFilterEnabled,
    Value<bool>? isDefault,
    Value<int>? rowid,
  }) {
    return FilterProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      overlayColor: overlayColor ?? this.overlayColor,
      overlayOpacity: overlayOpacity ?? this.overlayOpacity,
      brightness: brightness ?? this.brightness,
      fontSize: fontSize ?? this.fontSize,
      paperFilterEnabled: paperFilterEnabled ?? this.paperFilterEnabled,
      isDefault: isDefault ?? this.isDefault,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (backgroundColor.present) {
      map['background_color'] = Variable<int>(backgroundColor.value);
    }
    if (overlayColor.present) {
      map['overlay_color'] = Variable<int>(overlayColor.value);
    }
    if (overlayOpacity.present) {
      map['overlay_opacity'] = Variable<double>(overlayOpacity.value);
    }
    if (brightness.present) {
      map['brightness'] = Variable<double>(brightness.value);
    }
    if (fontSize.present) {
      map['font_size'] = Variable<double>(fontSize.value);
    }
    if (paperFilterEnabled.present) {
      map['paper_filter_enabled'] = Variable<bool>(paperFilterEnabled.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FilterProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('overlayColor: $overlayColor, ')
          ..write('overlayOpacity: $overlayOpacity, ')
          ..write('brightness: $brightness, ')
          ..write('fontSize: $fontSize, ')
          ..write('paperFilterEnabled: $paperFilterEnabled, ')
          ..write('isDefault: $isDefault, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingProgressEntriesTable extends ReadingProgressEntries
    with TableInfo<$ReadingProgressEntriesTable, ReadingProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingProgressEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _percentageMeta = const VerificationMeta(
    'percentage',
  );
  @override
  late final GeneratedColumn<double> percentage = GeneratedColumn<double>(
    'percentage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalUnitsMeta = const VerificationMeta(
    'totalUnits',
  );
  @override
  late final GeneratedColumn<int> totalUnits = GeneratedColumn<int>(
    'total_units',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    bookId,
    position,
    percentage,
    totalUnits,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_progress_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('percentage')) {
      context.handle(
        _percentageMeta,
        percentage.isAcceptableOrUnknown(data['percentage']!, _percentageMeta),
      );
    }
    if (data.containsKey('total_units')) {
      context.handle(
        _totalUnitsMeta,
        totalUnits.isAcceptableOrUnknown(data['total_units']!, _totalUnitsMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bookId};
  @override
  ReadingProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingProgressRow(
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position'],
      )!,
      percentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}percentage'],
      )!,
      totalUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_units'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReadingProgressEntriesTable createAlias(String alias) {
    return $ReadingProgressEntriesTable(attachedDatabase, alias);
  }
}

class ReadingProgressRow extends DataClass
    implements Insertable<ReadingProgressRow> {
  final String bookId;
  final String position;
  final double percentage;
  final int? totalUnits;
  final DateTime updatedAt;
  const ReadingProgressRow({
    required this.bookId,
    required this.position,
    required this.percentage,
    this.totalUnits,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book_id'] = Variable<String>(bookId);
    map['position'] = Variable<String>(position);
    map['percentage'] = Variable<double>(percentage);
    if (!nullToAbsent || totalUnits != null) {
      map['total_units'] = Variable<int>(totalUnits);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReadingProgressEntriesCompanion toCompanion(bool nullToAbsent) {
    return ReadingProgressEntriesCompanion(
      bookId: Value(bookId),
      position: Value(position),
      percentage: Value(percentage),
      totalUnits: totalUnits == null && nullToAbsent
          ? const Value.absent()
          : Value(totalUnits),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReadingProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingProgressRow(
      bookId: serializer.fromJson<String>(json['bookId']),
      position: serializer.fromJson<String>(json['position']),
      percentage: serializer.fromJson<double>(json['percentage']),
      totalUnits: serializer.fromJson<int?>(json['totalUnits']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bookId': serializer.toJson<String>(bookId),
      'position': serializer.toJson<String>(position),
      'percentage': serializer.toJson<double>(percentage),
      'totalUnits': serializer.toJson<int?>(totalUnits),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReadingProgressRow copyWith({
    String? bookId,
    String? position,
    double? percentage,
    Value<int?> totalUnits = const Value.absent(),
    DateTime? updatedAt,
  }) => ReadingProgressRow(
    bookId: bookId ?? this.bookId,
    position: position ?? this.position,
    percentage: percentage ?? this.percentage,
    totalUnits: totalUnits.present ? totalUnits.value : this.totalUnits,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReadingProgressRow copyWithCompanion(ReadingProgressEntriesCompanion data) {
    return ReadingProgressRow(
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      position: data.position.present ? data.position.value : this.position,
      percentage: data.percentage.present
          ? data.percentage.value
          : this.percentage,
      totalUnits: data.totalUnits.present
          ? data.totalUnits.value
          : this.totalUnits,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressRow(')
          ..write('bookId: $bookId, ')
          ..write('position: $position, ')
          ..write('percentage: $percentage, ')
          ..write('totalUnits: $totalUnits, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(bookId, position, percentage, totalUnits, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingProgressRow &&
          other.bookId == this.bookId &&
          other.position == this.position &&
          other.percentage == this.percentage &&
          other.totalUnits == this.totalUnits &&
          other.updatedAt == this.updatedAt);
}

class ReadingProgressEntriesCompanion
    extends UpdateCompanion<ReadingProgressRow> {
  final Value<String> bookId;
  final Value<String> position;
  final Value<double> percentage;
  final Value<int?> totalUnits;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReadingProgressEntriesCompanion({
    this.bookId = const Value.absent(),
    this.position = const Value.absent(),
    this.percentage = const Value.absent(),
    this.totalUnits = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingProgressEntriesCompanion.insert({
    required String bookId,
    required String position,
    this.percentage = const Value.absent(),
    this.totalUnits = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : bookId = Value(bookId),
       position = Value(position),
       updatedAt = Value(updatedAt);
  static Insertable<ReadingProgressRow> custom({
    Expression<String>? bookId,
    Expression<String>? position,
    Expression<double>? percentage,
    Expression<int>? totalUnits,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bookId != null) 'book_id': bookId,
      if (position != null) 'position': position,
      if (percentage != null) 'percentage': percentage,
      if (totalUnits != null) 'total_units': totalUnits,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingProgressEntriesCompanion copyWith({
    Value<String>? bookId,
    Value<String>? position,
    Value<double>? percentage,
    Value<int?>? totalUnits,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReadingProgressEntriesCompanion(
      bookId: bookId ?? this.bookId,
      position: position ?? this.position,
      percentage: percentage ?? this.percentage,
      totalUnits: totalUnits ?? this.totalUnits,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    if (percentage.present) {
      map['percentage'] = Variable<double>(percentage.value);
    }
    if (totalUnits.present) {
      map['total_units'] = Variable<int>(totalUnits.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressEntriesCompanion(')
          ..write('bookId: $bookId, ')
          ..write('position: $position, ')
          ..write('percentage: $percentage, ')
          ..write('totalUnits: $totalUnits, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingSessionsTable extends ReadingSessions
    with TableInfo<$ReadingSessionsTable, ReadingSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id)',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, bookId, startedAt, endedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
    );
  }

  @override
  $ReadingSessionsTable createAlias(String alias) {
    return $ReadingSessionsTable(attachedDatabase, alias);
  }
}

class ReadingSessionRow extends DataClass
    implements Insertable<ReadingSessionRow> {
  final String id;
  final String bookId;
  final DateTime startedAt;
  final DateTime endedAt;
  const ReadingSessionRow({
    required this.id,
    required this.bookId,
    required this.startedAt,
    required this.endedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    return map;
  }

  ReadingSessionsCompanion toCompanion(bool nullToAbsent) {
    return ReadingSessionsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
    );
  }

  factory ReadingSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingSessionRow(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
    };
  }

  ReadingSessionRow copyWith({
    String? id,
    String? bookId,
    DateTime? startedAt,
    DateTime? endedAt,
  }) => ReadingSessionRow(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
  );
  ReadingSessionRow copyWithCompanion(ReadingSessionsCompanion data) {
    return ReadingSessionRow(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSessionRow(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookId, startedAt, endedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingSessionRow &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt);
}

class ReadingSessionsCompanion extends UpdateCompanion<ReadingSessionRow> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> rowid;
  const ReadingSessionsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingSessionsCompanion.insert({
    required String id,
    required String bookId,
    required DateTime startedAt,
    required DateTime endedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt);
  static Insertable<ReadingSessionRow> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? rowid,
  }) {
    return ReadingSessionsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ShelvesTable shelves = $ShelvesTable(this);
  late final $BooksTable books = $BooksTable(this);
  late final $FilterProfilesTable filterProfiles = $FilterProfilesTable(this);
  late final $ReadingProgressEntriesTable readingProgressEntries =
      $ReadingProgressEntriesTable(this);
  late final $ReadingSessionsTable readingSessions = $ReadingSessionsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    shelves,
    books,
    filterProfiles,
    readingProgressEntries,
    readingSessions,
  ];
}

typedef $$ShelvesTableCreateCompanionBuilder =
    ShelvesCompanion Function({
      required String id,
      required String name,
      required int color,
      required String icon,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ShelvesTableUpdateCompanionBuilder =
    ShelvesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> color,
      Value<String> icon,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ShelvesTableReferences
    extends BaseReferences<_$AppDatabase, $ShelvesTable, ShelfRow> {
  $$ShelvesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BooksTable, List<BookRow>> _booksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.books,
    aliasName: 'shelves__id__books__shelf_id',
  );

  $$BooksTableProcessedTableManager get booksRefs {
    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.shelfId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_booksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShelvesTableFilterComposer
    extends Composer<_$AppDatabase, $ShelvesTable> {
  $$ShelvesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> booksRefs(
    Expression<bool> Function($$BooksTableFilterComposer f) f,
  ) {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.shelfId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShelvesTableOrderingComposer
    extends Composer<_$AppDatabase, $ShelvesTable> {
  $$ShelvesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShelvesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShelvesTable> {
  $$ShelvesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> booksRefs<T extends Object>(
    Expression<T> Function($$BooksTableAnnotationComposer a) f,
  ) {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.shelfId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShelvesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShelvesTable,
          ShelfRow,
          $$ShelvesTableFilterComposer,
          $$ShelvesTableOrderingComposer,
          $$ShelvesTableAnnotationComposer,
          $$ShelvesTableCreateCompanionBuilder,
          $$ShelvesTableUpdateCompanionBuilder,
          (ShelfRow, $$ShelvesTableReferences),
          ShelfRow,
          PrefetchHooks Function({bool booksRefs})
        > {
  $$ShelvesTableTableManager(_$AppDatabase db, $ShelvesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShelvesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShelvesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShelvesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShelvesCompanion(
                id: id,
                name: name,
                color: color,
                icon: icon,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int color,
                required String icon,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ShelvesCompanion.insert(
                id: id,
                name: name,
                color: color,
                icon: icon,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShelvesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({booksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (booksRefs) db.books],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (booksRefs)
                    await $_getPrefetchedData<ShelfRow, $ShelvesTable, BookRow>(
                      currentTable: table,
                      referencedTable: $$ShelvesTableReferences._booksRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$ShelvesTableReferences(db, table, p0).booksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.shelfId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ShelvesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShelvesTable,
      ShelfRow,
      $$ShelvesTableFilterComposer,
      $$ShelvesTableOrderingComposer,
      $$ShelvesTableAnnotationComposer,
      $$ShelvesTableCreateCompanionBuilder,
      $$ShelvesTableUpdateCompanionBuilder,
      (ShelfRow, $$ShelvesTableReferences),
      ShelfRow,
      PrefetchHooks Function({bool booksRefs})
    >;
typedef $$BooksTableCreateCompanionBuilder =
    BooksCompanion Function({
      required String id,
      required String title,
      required String format,
      required String filePath,
      Value<String?> coverPath,
      Value<String?> shelfId,
      required DateTime addedAt,
      Value<DateTime?> lastOpenedAt,
      Value<int> rowid,
    });
typedef $$BooksTableUpdateCompanionBuilder =
    BooksCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> format,
      Value<String> filePath,
      Value<String?> coverPath,
      Value<String?> shelfId,
      Value<DateTime> addedAt,
      Value<DateTime?> lastOpenedAt,
      Value<int> rowid,
    });

final class $$BooksTableReferences
    extends BaseReferences<_$AppDatabase, $BooksTable, BookRow> {
  $$BooksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShelvesTable _shelfIdTable(_$AppDatabase db) =>
      db.shelves.createAlias('books__shelf_id__shelves__id');

  $$ShelvesTableProcessedTableManager? get shelfId {
    final $_column = $_itemColumn<String>('shelf_id');
    if ($_column == null) return null;
    final manager = $$ShelvesTableTableManager(
      $_db,
      $_db.shelves,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shelfIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ReadingProgressEntriesTable,
    List<ReadingProgressRow>
  >
  _readingProgressEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.readingProgressEntries,
        aliasName: 'books__id__reading_progress_entries__book_id',
      );

  $$ReadingProgressEntriesTableProcessedTableManager
  get readingProgressEntriesRefs {
    final manager = $$ReadingProgressEntriesTableTableManager(
      $_db,
      $_db.readingProgressEntries,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readingProgressEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReadingSessionsTable, List<ReadingSessionRow>>
  _readingSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readingSessions,
    aliasName: 'books__id__reading_sessions__book_id',
  );

  $$ReadingSessionsTableProcessedTableManager get readingSessionsRefs {
    final manager = $$ReadingSessionsTableTableManager(
      $_db,
      $_db.readingSessions,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readingSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BooksTableFilterComposer extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ShelvesTableFilterComposer get shelfId {
    final $$ShelvesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shelfId,
      referencedTable: $db.shelves,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShelvesTableFilterComposer(
            $db: $db,
            $table: $db.shelves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> readingProgressEntriesRefs(
    Expression<bool> Function($$ReadingProgressEntriesTableFilterComposer f) f,
  ) {
    final $$ReadingProgressEntriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.readingProgressEntries,
          getReferencedColumn: (t) => t.bookId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReadingProgressEntriesTableFilterComposer(
                $db: $db,
                $table: $db.readingProgressEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> readingSessionsRefs(
    Expression<bool> Function($$ReadingSessionsTableFilterComposer f) f,
  ) {
    final $$ReadingSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingSessions,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingSessionsTableFilterComposer(
            $db: $db,
            $table: $db.readingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BooksTableOrderingComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShelvesTableOrderingComposer get shelfId {
    final $$ShelvesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shelfId,
      referencedTable: $db.shelves,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShelvesTableOrderingComposer(
            $db: $db,
            $table: $db.shelves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get coverPath =>
      $composableBuilder(column: $table.coverPath, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => column,
  );

  $$ShelvesTableAnnotationComposer get shelfId {
    final $$ShelvesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shelfId,
      referencedTable: $db.shelves,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShelvesTableAnnotationComposer(
            $db: $db,
            $table: $db.shelves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> readingProgressEntriesRefs<T extends Object>(
    Expression<T> Function($$ReadingProgressEntriesTableAnnotationComposer a) f,
  ) {
    final $$ReadingProgressEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.readingProgressEntries,
          getReferencedColumn: (t) => t.bookId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReadingProgressEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.readingProgressEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> readingSessionsRefs<T extends Object>(
    Expression<T> Function($$ReadingSessionsTableAnnotationComposer a) f,
  ) {
    final $$ReadingSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingSessions,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.readingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BooksTable,
          BookRow,
          $$BooksTableFilterComposer,
          $$BooksTableOrderingComposer,
          $$BooksTableAnnotationComposer,
          $$BooksTableCreateCompanionBuilder,
          $$BooksTableUpdateCompanionBuilder,
          (BookRow, $$BooksTableReferences),
          BookRow,
          PrefetchHooks Function({
            bool shelfId,
            bool readingProgressEntriesRefs,
            bool readingSessionsRefs,
          })
        > {
  $$BooksTableTableManager(_$AppDatabase db, $BooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<String?> shelfId = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime?> lastOpenedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BooksCompanion(
                id: id,
                title: title,
                format: format,
                filePath: filePath,
                coverPath: coverPath,
                shelfId: shelfId,
                addedAt: addedAt,
                lastOpenedAt: lastOpenedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String format,
                required String filePath,
                Value<String?> coverPath = const Value.absent(),
                Value<String?> shelfId = const Value.absent(),
                required DateTime addedAt,
                Value<DateTime?> lastOpenedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BooksCompanion.insert(
                id: id,
                title: title,
                format: format,
                filePath: filePath,
                coverPath: coverPath,
                shelfId: shelfId,
                addedAt: addedAt,
                lastOpenedAt: lastOpenedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$BooksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                shelfId = false,
                readingProgressEntriesRefs = false,
                readingSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (readingProgressEntriesRefs) db.readingProgressEntries,
                    if (readingSessionsRefs) db.readingSessions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (shelfId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.shelfId,
                                    referencedTable: $$BooksTableReferences
                                        ._shelfIdTable(db),
                                    referencedColumn: $$BooksTableReferences
                                        ._shelfIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (readingProgressEntriesRefs)
                        await $_getPrefetchedData<
                          BookRow,
                          $BooksTable,
                          ReadingProgressRow
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._readingProgressEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).readingProgressEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readingSessionsRefs)
                        await $_getPrefetchedData<
                          BookRow,
                          $BooksTable,
                          ReadingSessionRow
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._readingSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).readingSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BooksTable,
      BookRow,
      $$BooksTableFilterComposer,
      $$BooksTableOrderingComposer,
      $$BooksTableAnnotationComposer,
      $$BooksTableCreateCompanionBuilder,
      $$BooksTableUpdateCompanionBuilder,
      (BookRow, $$BooksTableReferences),
      BookRow,
      PrefetchHooks Function({
        bool shelfId,
        bool readingProgressEntriesRefs,
        bool readingSessionsRefs,
      })
    >;
typedef $$FilterProfilesTableCreateCompanionBuilder =
    FilterProfilesCompanion Function({
      required String id,
      required String name,
      required int backgroundColor,
      required int overlayColor,
      Value<double> overlayOpacity,
      Value<double> brightness,
      Value<double> fontSize,
      Value<bool> paperFilterEnabled,
      Value<bool> isDefault,
      Value<int> rowid,
    });
typedef $$FilterProfilesTableUpdateCompanionBuilder =
    FilterProfilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> backgroundColor,
      Value<int> overlayColor,
      Value<double> overlayOpacity,
      Value<double> brightness,
      Value<double> fontSize,
      Value<bool> paperFilterEnabled,
      Value<bool> isDefault,
      Value<int> rowid,
    });

class $$FilterProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $FilterProfilesTable> {
  $$FilterProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get overlayColor => $composableBuilder(
    column: $table.overlayColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get overlayOpacity => $composableBuilder(
    column: $table.overlayOpacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get brightness => $composableBuilder(
    column: $table.brightness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paperFilterEnabled => $composableBuilder(
    column: $table.paperFilterEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FilterProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $FilterProfilesTable> {
  $$FilterProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get overlayColor => $composableBuilder(
    column: $table.overlayColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get overlayOpacity => $composableBuilder(
    column: $table.overlayOpacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get brightness => $composableBuilder(
    column: $table.brightness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paperFilterEnabled => $composableBuilder(
    column: $table.paperFilterEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FilterProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FilterProfilesTable> {
  $$FilterProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get overlayColor => $composableBuilder(
    column: $table.overlayColor,
    builder: (column) => column,
  );

  GeneratedColumn<double> get overlayOpacity => $composableBuilder(
    column: $table.overlayOpacity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get brightness => $composableBuilder(
    column: $table.brightness,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fontSize =>
      $composableBuilder(column: $table.fontSize, builder: (column) => column);

  GeneratedColumn<bool> get paperFilterEnabled => $composableBuilder(
    column: $table.paperFilterEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);
}

class $$FilterProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FilterProfilesTable,
          FilterProfileRow,
          $$FilterProfilesTableFilterComposer,
          $$FilterProfilesTableOrderingComposer,
          $$FilterProfilesTableAnnotationComposer,
          $$FilterProfilesTableCreateCompanionBuilder,
          $$FilterProfilesTableUpdateCompanionBuilder,
          (
            FilterProfileRow,
            BaseReferences<
              _$AppDatabase,
              $FilterProfilesTable,
              FilterProfileRow
            >,
          ),
          FilterProfileRow,
          PrefetchHooks Function()
        > {
  $$FilterProfilesTableTableManager(
    _$AppDatabase db,
    $FilterProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FilterProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FilterProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FilterProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> backgroundColor = const Value.absent(),
                Value<int> overlayColor = const Value.absent(),
                Value<double> overlayOpacity = const Value.absent(),
                Value<double> brightness = const Value.absent(),
                Value<double> fontSize = const Value.absent(),
                Value<bool> paperFilterEnabled = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FilterProfilesCompanion(
                id: id,
                name: name,
                backgroundColor: backgroundColor,
                overlayColor: overlayColor,
                overlayOpacity: overlayOpacity,
                brightness: brightness,
                fontSize: fontSize,
                paperFilterEnabled: paperFilterEnabled,
                isDefault: isDefault,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int backgroundColor,
                required int overlayColor,
                Value<double> overlayOpacity = const Value.absent(),
                Value<double> brightness = const Value.absent(),
                Value<double> fontSize = const Value.absent(),
                Value<bool> paperFilterEnabled = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FilterProfilesCompanion.insert(
                id: id,
                name: name,
                backgroundColor: backgroundColor,
                overlayColor: overlayColor,
                overlayOpacity: overlayOpacity,
                brightness: brightness,
                fontSize: fontSize,
                paperFilterEnabled: paperFilterEnabled,
                isDefault: isDefault,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FilterProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FilterProfilesTable,
      FilterProfileRow,
      $$FilterProfilesTableFilterComposer,
      $$FilterProfilesTableOrderingComposer,
      $$FilterProfilesTableAnnotationComposer,
      $$FilterProfilesTableCreateCompanionBuilder,
      $$FilterProfilesTableUpdateCompanionBuilder,
      (
        FilterProfileRow,
        BaseReferences<_$AppDatabase, $FilterProfilesTable, FilterProfileRow>,
      ),
      FilterProfileRow,
      PrefetchHooks Function()
    >;
typedef $$ReadingProgressEntriesTableCreateCompanionBuilder =
    ReadingProgressEntriesCompanion Function({
      required String bookId,
      required String position,
      Value<double> percentage,
      Value<int?> totalUnits,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ReadingProgressEntriesTableUpdateCompanionBuilder =
    ReadingProgressEntriesCompanion Function({
      Value<String> bookId,
      Value<String> position,
      Value<double> percentage,
      Value<int?> totalUnits,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ReadingProgressEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReadingProgressEntriesTable,
          ReadingProgressRow
        > {
  $$ReadingProgressEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('reading_progress_entries__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingProgressEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingProgressEntriesTable> {
  $$ReadingProgressEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingProgressEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingProgressEntriesTable> {
  $$ReadingProgressEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingProgressEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingProgressEntriesTable> {
  $$ReadingProgressEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<double> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingProgressEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingProgressEntriesTable,
          ReadingProgressRow,
          $$ReadingProgressEntriesTableFilterComposer,
          $$ReadingProgressEntriesTableOrderingComposer,
          $$ReadingProgressEntriesTableAnnotationComposer,
          $$ReadingProgressEntriesTableCreateCompanionBuilder,
          $$ReadingProgressEntriesTableUpdateCompanionBuilder,
          (ReadingProgressRow, $$ReadingProgressEntriesTableReferences),
          ReadingProgressRow,
          PrefetchHooks Function({bool bookId})
        > {
  $$ReadingProgressEntriesTableTableManager(
    _$AppDatabase db,
    $ReadingProgressEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingProgressEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ReadingProgressEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ReadingProgressEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> bookId = const Value.absent(),
                Value<String> position = const Value.absent(),
                Value<double> percentage = const Value.absent(),
                Value<int?> totalUnits = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingProgressEntriesCompanion(
                bookId: bookId,
                position: position,
                percentage: percentage,
                totalUnits: totalUnits,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String bookId,
                required String position,
                Value<double> percentage = const Value.absent(),
                Value<int?> totalUnits = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReadingProgressEntriesCompanion.insert(
                bookId: bookId,
                position: position,
                percentage: percentage,
                totalUnits: totalUnits,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReadingProgressEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable:
                                    $$ReadingProgressEntriesTableReferences
                                        ._bookIdTable(db),
                                referencedColumn:
                                    $$ReadingProgressEntriesTableReferences
                                        ._bookIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadingProgressEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingProgressEntriesTable,
      ReadingProgressRow,
      $$ReadingProgressEntriesTableFilterComposer,
      $$ReadingProgressEntriesTableOrderingComposer,
      $$ReadingProgressEntriesTableAnnotationComposer,
      $$ReadingProgressEntriesTableCreateCompanionBuilder,
      $$ReadingProgressEntriesTableUpdateCompanionBuilder,
      (ReadingProgressRow, $$ReadingProgressEntriesTableReferences),
      ReadingProgressRow,
      PrefetchHooks Function({bool bookId})
    >;
typedef $$ReadingSessionsTableCreateCompanionBuilder =
    ReadingSessionsCompanion Function({
      required String id,
      required String bookId,
      required DateTime startedAt,
      required DateTime endedAt,
      Value<int> rowid,
    });
typedef $$ReadingSessionsTableUpdateCompanionBuilder =
    ReadingSessionsCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int> rowid,
    });

final class $$ReadingSessionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReadingSessionsTable,
          ReadingSessionRow
        > {
  $$ReadingSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('reading_sessions__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingSessionsTable> {
  $$ReadingSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingSessionsTable> {
  $$ReadingSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingSessionsTable> {
  $$ReadingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingSessionsTable,
          ReadingSessionRow,
          $$ReadingSessionsTableFilterComposer,
          $$ReadingSessionsTableOrderingComposer,
          $$ReadingSessionsTableAnnotationComposer,
          $$ReadingSessionsTableCreateCompanionBuilder,
          $$ReadingSessionsTableUpdateCompanionBuilder,
          (ReadingSessionRow, $$ReadingSessionsTableReferences),
          ReadingSessionRow,
          PrefetchHooks Function({bool bookId})
        > {
  $$ReadingSessionsTableTableManager(
    _$AppDatabase db,
    $ReadingSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingSessionsCompanion(
                id: id,
                bookId: bookId,
                startedAt: startedAt,
                endedAt: endedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                required DateTime startedAt,
                required DateTime endedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReadingSessionsCompanion.insert(
                id: id,
                bookId: bookId,
                startedAt: startedAt,
                endedAt: endedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReadingSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable:
                                    $$ReadingSessionsTableReferences
                                        ._bookIdTable(db),
                                referencedColumn:
                                    $$ReadingSessionsTableReferences
                                        ._bookIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadingSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingSessionsTable,
      ReadingSessionRow,
      $$ReadingSessionsTableFilterComposer,
      $$ReadingSessionsTableOrderingComposer,
      $$ReadingSessionsTableAnnotationComposer,
      $$ReadingSessionsTableCreateCompanionBuilder,
      $$ReadingSessionsTableUpdateCompanionBuilder,
      (ReadingSessionRow, $$ReadingSessionsTableReferences),
      ReadingSessionRow,
      PrefetchHooks Function({bool bookId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ShelvesTableTableManager get shelves =>
      $$ShelvesTableTableManager(_db, _db.shelves);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db, _db.books);
  $$FilterProfilesTableTableManager get filterProfiles =>
      $$FilterProfilesTableTableManager(_db, _db.filterProfiles);
  $$ReadingProgressEntriesTableTableManager get readingProgressEntries =>
      $$ReadingProgressEntriesTableTableManager(
        _db,
        _db.readingProgressEntries,
      );
  $$ReadingSessionsTableTableManager get readingSessions =>
      $$ReadingSessionsTableTableManager(_db, _db.readingSessions);
}
