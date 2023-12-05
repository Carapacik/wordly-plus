// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LevelResultsTable extends LevelResults
    with TableInfo<$LevelResultsTable, LevelResultRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dictionaryCodeMeta = const VerificationMeta(
    'dictionaryCode',
  );
  @override
  late final GeneratedColumn<String> dictionaryCode = GeneratedColumn<String>(
    'dictionary_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelNumberMeta = const VerificationMeta(
    'levelNumber',
  );
  @override
  late final GeneratedColumn<int> levelNumber = GeneratedColumn<int>(
    'level_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secretWordMeta = const VerificationMeta(
    'secretWord',
  );
  @override
  late final GeneratedColumn<String> secretWord = GeneratedColumn<String>(
    'secret_word',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isWinMeta = const VerificationMeta('isWin');
  @override
  late final GeneratedColumn<bool> isWin = GeneratedColumn<bool>(
    'is_win',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_win" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    dictionaryCode,
    levelNumber,
    secretWord,
    isWin,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'level_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<LevelResultRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dictionary_code')) {
      context.handle(
        _dictionaryCodeMeta,
        dictionaryCode.isAcceptableOrUnknown(
          data['dictionary_code']!,
          _dictionaryCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dictionaryCodeMeta);
    }
    if (data.containsKey('level_number')) {
      context.handle(
        _levelNumberMeta,
        levelNumber.isAcceptableOrUnknown(
          data['level_number']!,
          _levelNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_levelNumberMeta);
    }
    if (data.containsKey('secret_word')) {
      context.handle(
        _secretWordMeta,
        secretWord.isAcceptableOrUnknown(data['secret_word']!, _secretWordMeta),
      );
    }
    if (data.containsKey('is_win')) {
      context.handle(
        _isWinMeta,
        isWin.isAcceptableOrUnknown(data['is_win']!, _isWinMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dictionaryCode, levelNumber};
  @override
  LevelResultRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LevelResultRow(
      dictionaryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dictionary_code'],
      )!,
      levelNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level_number'],
      )!,
      secretWord: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secret_word'],
      ),
      isWin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_win'],
      ),
    );
  }

  @override
  $LevelResultsTable createAlias(String alias) {
    return $LevelResultsTable(attachedDatabase, alias);
  }
}

class LevelResultRow extends DataClass implements Insertable<LevelResultRow> {
  final String dictionaryCode;
  final int levelNumber;
  final String? secretWord;
  final bool? isWin;
  const LevelResultRow({
    required this.dictionaryCode,
    required this.levelNumber,
    this.secretWord,
    this.isWin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['dictionary_code'] = Variable<String>(dictionaryCode);
    map['level_number'] = Variable<int>(levelNumber);
    if (!nullToAbsent || secretWord != null) {
      map['secret_word'] = Variable<String>(secretWord);
    }
    if (!nullToAbsent || isWin != null) {
      map['is_win'] = Variable<bool>(isWin);
    }
    return map;
  }

  LevelResultsCompanion toCompanion(bool nullToAbsent) {
    return LevelResultsCompanion(
      dictionaryCode: Value(dictionaryCode),
      levelNumber: Value(levelNumber),
      secretWord: secretWord == null && nullToAbsent
          ? const Value.absent()
          : Value(secretWord),
      isWin: isWin == null && nullToAbsent
          ? const Value.absent()
          : Value(isWin),
    );
  }

  factory LevelResultRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LevelResultRow(
      dictionaryCode: serializer.fromJson<String>(json['dictionaryCode']),
      levelNumber: serializer.fromJson<int>(json['levelNumber']),
      secretWord: serializer.fromJson<String?>(json['secretWord']),
      isWin: serializer.fromJson<bool?>(json['isWin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dictionaryCode': serializer.toJson<String>(dictionaryCode),
      'levelNumber': serializer.toJson<int>(levelNumber),
      'secretWord': serializer.toJson<String?>(secretWord),
      'isWin': serializer.toJson<bool?>(isWin),
    };
  }

  LevelResultRow copyWith({
    String? dictionaryCode,
    int? levelNumber,
    Value<String?> secretWord = const Value.absent(),
    Value<bool?> isWin = const Value.absent(),
  }) => LevelResultRow(
    dictionaryCode: dictionaryCode ?? this.dictionaryCode,
    levelNumber: levelNumber ?? this.levelNumber,
    secretWord: secretWord.present ? secretWord.value : this.secretWord,
    isWin: isWin.present ? isWin.value : this.isWin,
  );
  LevelResultRow copyWithCompanion(LevelResultsCompanion data) {
    return LevelResultRow(
      dictionaryCode: data.dictionaryCode.present
          ? data.dictionaryCode.value
          : this.dictionaryCode,
      levelNumber: data.levelNumber.present
          ? data.levelNumber.value
          : this.levelNumber,
      secretWord: data.secretWord.present
          ? data.secretWord.value
          : this.secretWord,
      isWin: data.isWin.present ? data.isWin.value : this.isWin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LevelResultRow(')
          ..write('dictionaryCode: $dictionaryCode, ')
          ..write('levelNumber: $levelNumber, ')
          ..write('secretWord: $secretWord, ')
          ..write('isWin: $isWin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(dictionaryCode, levelNumber, secretWord, isWin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LevelResultRow &&
          other.dictionaryCode == this.dictionaryCode &&
          other.levelNumber == this.levelNumber &&
          other.secretWord == this.secretWord &&
          other.isWin == this.isWin);
}

class LevelResultsCompanion extends UpdateCompanion<LevelResultRow> {
  final Value<String> dictionaryCode;
  final Value<int> levelNumber;
  final Value<String?> secretWord;
  final Value<bool?> isWin;
  final Value<int> rowid;
  const LevelResultsCompanion({
    this.dictionaryCode = const Value.absent(),
    this.levelNumber = const Value.absent(),
    this.secretWord = const Value.absent(),
    this.isWin = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LevelResultsCompanion.insert({
    required String dictionaryCode,
    required int levelNumber,
    this.secretWord = const Value.absent(),
    this.isWin = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : dictionaryCode = Value(dictionaryCode),
       levelNumber = Value(levelNumber);
  static Insertable<LevelResultRow> custom({
    Expression<String>? dictionaryCode,
    Expression<int>? levelNumber,
    Expression<String>? secretWord,
    Expression<bool>? isWin,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dictionaryCode != null) 'dictionary_code': dictionaryCode,
      if (levelNumber != null) 'level_number': levelNumber,
      if (secretWord != null) 'secret_word': secretWord,
      if (isWin != null) 'is_win': isWin,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LevelResultsCompanion copyWith({
    Value<String>? dictionaryCode,
    Value<int>? levelNumber,
    Value<String?>? secretWord,
    Value<bool?>? isWin,
    Value<int>? rowid,
  }) {
    return LevelResultsCompanion(
      dictionaryCode: dictionaryCode ?? this.dictionaryCode,
      levelNumber: levelNumber ?? this.levelNumber,
      secretWord: secretWord ?? this.secretWord,
      isWin: isWin ?? this.isWin,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dictionaryCode.present) {
      map['dictionary_code'] = Variable<String>(dictionaryCode.value);
    }
    if (levelNumber.present) {
      map['level_number'] = Variable<int>(levelNumber.value);
    }
    if (secretWord.present) {
      map['secret_word'] = Variable<String>(secretWord.value);
    }
    if (isWin.present) {
      map['is_win'] = Variable<bool>(isWin.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelResultsCompanion(')
          ..write('dictionaryCode: $dictionaryCode, ')
          ..write('levelNumber: $levelNumber, ')
          ..write('secretWord: $secretWord, ')
          ..write('isWin: $isWin, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LevelProgressEntriesTable extends LevelProgressEntries
    with TableInfo<$LevelProgressEntriesTable, LevelProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelProgressEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dictionaryCodeMeta = const VerificationMeta(
    'dictionaryCode',
  );
  @override
  late final GeneratedColumn<String> dictionaryCode = GeneratedColumn<String>(
    'dictionary_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelNumberMeta = const VerificationMeta(
    'levelNumber',
  );
  @override
  late final GeneratedColumn<int> levelNumber = GeneratedColumn<int>(
    'level_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secretWordMeta = const VerificationMeta(
    'secretWord',
  );
  @override
  late final GeneratedColumn<String> secretWord = GeneratedColumn<String>(
    'secret_word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boardJsonMeta = const VerificationMeta(
    'boardJson',
  );
  @override
  late final GeneratedColumn<String> boardJson = GeneratedColumn<String>(
    'board_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    dictionaryCode,
    levelNumber,
    secretWord,
    boardJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'level_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<LevelProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dictionary_code')) {
      context.handle(
        _dictionaryCodeMeta,
        dictionaryCode.isAcceptableOrUnknown(
          data['dictionary_code']!,
          _dictionaryCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dictionaryCodeMeta);
    }
    if (data.containsKey('level_number')) {
      context.handle(
        _levelNumberMeta,
        levelNumber.isAcceptableOrUnknown(
          data['level_number']!,
          _levelNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_levelNumberMeta);
    }
    if (data.containsKey('secret_word')) {
      context.handle(
        _secretWordMeta,
        secretWord.isAcceptableOrUnknown(data['secret_word']!, _secretWordMeta),
      );
    } else if (isInserting) {
      context.missing(_secretWordMeta);
    }
    if (data.containsKey('board_json')) {
      context.handle(
        _boardJsonMeta,
        boardJson.isAcceptableOrUnknown(data['board_json']!, _boardJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_boardJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dictionaryCode};
  @override
  LevelProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LevelProgressRow(
      dictionaryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dictionary_code'],
      )!,
      levelNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level_number'],
      )!,
      secretWord: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secret_word'],
      )!,
      boardJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}board_json'],
      )!,
    );
  }

  @override
  $LevelProgressEntriesTable createAlias(String alias) {
    return $LevelProgressEntriesTable(attachedDatabase, alias);
  }
}

class LevelProgressRow extends DataClass
    implements Insertable<LevelProgressRow> {
  final String dictionaryCode;
  final int levelNumber;
  final String secretWord;
  final String boardJson;
  const LevelProgressRow({
    required this.dictionaryCode,
    required this.levelNumber,
    required this.secretWord,
    required this.boardJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['dictionary_code'] = Variable<String>(dictionaryCode);
    map['level_number'] = Variable<int>(levelNumber);
    map['secret_word'] = Variable<String>(secretWord);
    map['board_json'] = Variable<String>(boardJson);
    return map;
  }

  LevelProgressEntriesCompanion toCompanion(bool nullToAbsent) {
    return LevelProgressEntriesCompanion(
      dictionaryCode: Value(dictionaryCode),
      levelNumber: Value(levelNumber),
      secretWord: Value(secretWord),
      boardJson: Value(boardJson),
    );
  }

  factory LevelProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LevelProgressRow(
      dictionaryCode: serializer.fromJson<String>(json['dictionaryCode']),
      levelNumber: serializer.fromJson<int>(json['levelNumber']),
      secretWord: serializer.fromJson<String>(json['secretWord']),
      boardJson: serializer.fromJson<String>(json['boardJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dictionaryCode': serializer.toJson<String>(dictionaryCode),
      'levelNumber': serializer.toJson<int>(levelNumber),
      'secretWord': serializer.toJson<String>(secretWord),
      'boardJson': serializer.toJson<String>(boardJson),
    };
  }

  LevelProgressRow copyWith({
    String? dictionaryCode,
    int? levelNumber,
    String? secretWord,
    String? boardJson,
  }) => LevelProgressRow(
    dictionaryCode: dictionaryCode ?? this.dictionaryCode,
    levelNumber: levelNumber ?? this.levelNumber,
    secretWord: secretWord ?? this.secretWord,
    boardJson: boardJson ?? this.boardJson,
  );
  LevelProgressRow copyWithCompanion(LevelProgressEntriesCompanion data) {
    return LevelProgressRow(
      dictionaryCode: data.dictionaryCode.present
          ? data.dictionaryCode.value
          : this.dictionaryCode,
      levelNumber: data.levelNumber.present
          ? data.levelNumber.value
          : this.levelNumber,
      secretWord: data.secretWord.present
          ? data.secretWord.value
          : this.secretWord,
      boardJson: data.boardJson.present ? data.boardJson.value : this.boardJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LevelProgressRow(')
          ..write('dictionaryCode: $dictionaryCode, ')
          ..write('levelNumber: $levelNumber, ')
          ..write('secretWord: $secretWord, ')
          ..write('boardJson: $boardJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(dictionaryCode, levelNumber, secretWord, boardJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LevelProgressRow &&
          other.dictionaryCode == this.dictionaryCode &&
          other.levelNumber == this.levelNumber &&
          other.secretWord == this.secretWord &&
          other.boardJson == this.boardJson);
}

class LevelProgressEntriesCompanion extends UpdateCompanion<LevelProgressRow> {
  final Value<String> dictionaryCode;
  final Value<int> levelNumber;
  final Value<String> secretWord;
  final Value<String> boardJson;
  final Value<int> rowid;
  const LevelProgressEntriesCompanion({
    this.dictionaryCode = const Value.absent(),
    this.levelNumber = const Value.absent(),
    this.secretWord = const Value.absent(),
    this.boardJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LevelProgressEntriesCompanion.insert({
    required String dictionaryCode,
    required int levelNumber,
    required String secretWord,
    required String boardJson,
    this.rowid = const Value.absent(),
  }) : dictionaryCode = Value(dictionaryCode),
       levelNumber = Value(levelNumber),
       secretWord = Value(secretWord),
       boardJson = Value(boardJson);
  static Insertable<LevelProgressRow> custom({
    Expression<String>? dictionaryCode,
    Expression<int>? levelNumber,
    Expression<String>? secretWord,
    Expression<String>? boardJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dictionaryCode != null) 'dictionary_code': dictionaryCode,
      if (levelNumber != null) 'level_number': levelNumber,
      if (secretWord != null) 'secret_word': secretWord,
      if (boardJson != null) 'board_json': boardJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LevelProgressEntriesCompanion copyWith({
    Value<String>? dictionaryCode,
    Value<int>? levelNumber,
    Value<String>? secretWord,
    Value<String>? boardJson,
    Value<int>? rowid,
  }) {
    return LevelProgressEntriesCompanion(
      dictionaryCode: dictionaryCode ?? this.dictionaryCode,
      levelNumber: levelNumber ?? this.levelNumber,
      secretWord: secretWord ?? this.secretWord,
      boardJson: boardJson ?? this.boardJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dictionaryCode.present) {
      map['dictionary_code'] = Variable<String>(dictionaryCode.value);
    }
    if (levelNumber.present) {
      map['level_number'] = Variable<int>(levelNumber.value);
    }
    if (secretWord.present) {
      map['secret_word'] = Variable<String>(secretWord.value);
    }
    if (boardJson.present) {
      map['board_json'] = Variable<String>(boardJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelProgressEntriesCompanion(')
          ..write('dictionaryCode: $dictionaryCode, ')
          ..write('levelNumber: $levelNumber, ')
          ..write('secretWord: $secretWord, ')
          ..write('boardJson: $boardJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MigrationMarkersTable extends MigrationMarkers
    with TableInfo<$MigrationMarkersTable, MigrationMarkerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MigrationMarkersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _migrationKeyMeta = const VerificationMeta(
    'migrationKey',
  );
  @override
  late final GeneratedColumn<String> migrationKey = GeneratedColumn<String>(
    'migration_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [migrationKey, version];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'migration_markers';
  @override
  VerificationContext validateIntegrity(
    Insertable<MigrationMarkerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('migration_key')) {
      context.handle(
        _migrationKeyMeta,
        migrationKey.isAcceptableOrUnknown(
          data['migration_key']!,
          _migrationKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_migrationKeyMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {migrationKey};
  @override
  MigrationMarkerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MigrationMarkerRow(
      migrationKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}migration_key'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $MigrationMarkersTable createAlias(String alias) {
    return $MigrationMarkersTable(attachedDatabase, alias);
  }
}

class MigrationMarkerRow extends DataClass
    implements Insertable<MigrationMarkerRow> {
  final String migrationKey;
  final int version;
  const MigrationMarkerRow({required this.migrationKey, required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['migration_key'] = Variable<String>(migrationKey);
    map['version'] = Variable<int>(version);
    return map;
  }

  MigrationMarkersCompanion toCompanion(bool nullToAbsent) {
    return MigrationMarkersCompanion(
      migrationKey: Value(migrationKey),
      version: Value(version),
    );
  }

  factory MigrationMarkerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MigrationMarkerRow(
      migrationKey: serializer.fromJson<String>(json['migrationKey']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'migrationKey': serializer.toJson<String>(migrationKey),
      'version': serializer.toJson<int>(version),
    };
  }

  MigrationMarkerRow copyWith({String? migrationKey, int? version}) =>
      MigrationMarkerRow(
        migrationKey: migrationKey ?? this.migrationKey,
        version: version ?? this.version,
      );
  MigrationMarkerRow copyWithCompanion(MigrationMarkersCompanion data) {
    return MigrationMarkerRow(
      migrationKey: data.migrationKey.present
          ? data.migrationKey.value
          : this.migrationKey,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MigrationMarkerRow(')
          ..write('migrationKey: $migrationKey, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(migrationKey, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MigrationMarkerRow &&
          other.migrationKey == this.migrationKey &&
          other.version == this.version);
}

class MigrationMarkersCompanion extends UpdateCompanion<MigrationMarkerRow> {
  final Value<String> migrationKey;
  final Value<int> version;
  final Value<int> rowid;
  const MigrationMarkersCompanion({
    this.migrationKey = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MigrationMarkersCompanion.insert({
    required String migrationKey,
    required int version,
    this.rowid = const Value.absent(),
  }) : migrationKey = Value(migrationKey),
       version = Value(version);
  static Insertable<MigrationMarkerRow> custom({
    Expression<String>? migrationKey,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (migrationKey != null) 'migration_key': migrationKey,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MigrationMarkersCompanion copyWith({
    Value<String>? migrationKey,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return MigrationMarkersCompanion(
      migrationKey: migrationKey ?? this.migrationKey,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (migrationKey.present) {
      map['migration_key'] = Variable<String>(migrationKey.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MigrationMarkersCompanion(')
          ..write('migrationKey: $migrationKey, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LevelResultsTable levelResults = $LevelResultsTable(this);
  late final $LevelProgressEntriesTable levelProgressEntries =
      $LevelProgressEntriesTable(this);
  late final $MigrationMarkersTable migrationMarkers = $MigrationMarkersTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    levelResults,
    levelProgressEntries,
    migrationMarkers,
  ];
}

typedef $$LevelResultsTableCreateCompanionBuilder =
    LevelResultsCompanion Function({
      required String dictionaryCode,
      required int levelNumber,
      Value<String?> secretWord,
      Value<bool?> isWin,
      Value<int> rowid,
    });
typedef $$LevelResultsTableUpdateCompanionBuilder =
    LevelResultsCompanion Function({
      Value<String> dictionaryCode,
      Value<int> levelNumber,
      Value<String?> secretWord,
      Value<bool?> isWin,
      Value<int> rowid,
    });

class $$LevelResultsTableFilterComposer
    extends Composer<_$AppDatabase, $LevelResultsTable> {
  $$LevelResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dictionaryCode => $composableBuilder(
    column: $table.dictionaryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get levelNumber => $composableBuilder(
    column: $table.levelNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secretWord => $composableBuilder(
    column: $table.secretWord,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isWin => $composableBuilder(
    column: $table.isWin,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LevelResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $LevelResultsTable> {
  $$LevelResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dictionaryCode => $composableBuilder(
    column: $table.dictionaryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get levelNumber => $composableBuilder(
    column: $table.levelNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secretWord => $composableBuilder(
    column: $table.secretWord,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isWin => $composableBuilder(
    column: $table.isWin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LevelResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LevelResultsTable> {
  $$LevelResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dictionaryCode => $composableBuilder(
    column: $table.dictionaryCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get levelNumber => $composableBuilder(
    column: $table.levelNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secretWord => $composableBuilder(
    column: $table.secretWord,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isWin =>
      $composableBuilder(column: $table.isWin, builder: (column) => column);
}

class $$LevelResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LevelResultsTable,
          LevelResultRow,
          $$LevelResultsTableFilterComposer,
          $$LevelResultsTableOrderingComposer,
          $$LevelResultsTableAnnotationComposer,
          $$LevelResultsTableCreateCompanionBuilder,
          $$LevelResultsTableUpdateCompanionBuilder,
          (
            LevelResultRow,
            BaseReferences<_$AppDatabase, $LevelResultsTable, LevelResultRow>,
          ),
          LevelResultRow,
          PrefetchHooks Function()
        > {
  $$LevelResultsTableTableManager(_$AppDatabase db, $LevelResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevelResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevelResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LevelResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> dictionaryCode = const Value.absent(),
                Value<int> levelNumber = const Value.absent(),
                Value<String?> secretWord = const Value.absent(),
                Value<bool?> isWin = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LevelResultsCompanion(
                dictionaryCode: dictionaryCode,
                levelNumber: levelNumber,
                secretWord: secretWord,
                isWin: isWin,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dictionaryCode,
                required int levelNumber,
                Value<String?> secretWord = const Value.absent(),
                Value<bool?> isWin = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LevelResultsCompanion.insert(
                dictionaryCode: dictionaryCode,
                levelNumber: levelNumber,
                secretWord: secretWord,
                isWin: isWin,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LevelResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LevelResultsTable,
      LevelResultRow,
      $$LevelResultsTableFilterComposer,
      $$LevelResultsTableOrderingComposer,
      $$LevelResultsTableAnnotationComposer,
      $$LevelResultsTableCreateCompanionBuilder,
      $$LevelResultsTableUpdateCompanionBuilder,
      (
        LevelResultRow,
        BaseReferences<_$AppDatabase, $LevelResultsTable, LevelResultRow>,
      ),
      LevelResultRow,
      PrefetchHooks Function()
    >;
typedef $$LevelProgressEntriesTableCreateCompanionBuilder =
    LevelProgressEntriesCompanion Function({
      required String dictionaryCode,
      required int levelNumber,
      required String secretWord,
      required String boardJson,
      Value<int> rowid,
    });
typedef $$LevelProgressEntriesTableUpdateCompanionBuilder =
    LevelProgressEntriesCompanion Function({
      Value<String> dictionaryCode,
      Value<int> levelNumber,
      Value<String> secretWord,
      Value<String> boardJson,
      Value<int> rowid,
    });

class $$LevelProgressEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LevelProgressEntriesTable> {
  $$LevelProgressEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dictionaryCode => $composableBuilder(
    column: $table.dictionaryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get levelNumber => $composableBuilder(
    column: $table.levelNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secretWord => $composableBuilder(
    column: $table.secretWord,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get boardJson => $composableBuilder(
    column: $table.boardJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LevelProgressEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LevelProgressEntriesTable> {
  $$LevelProgressEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dictionaryCode => $composableBuilder(
    column: $table.dictionaryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get levelNumber => $composableBuilder(
    column: $table.levelNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secretWord => $composableBuilder(
    column: $table.secretWord,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get boardJson => $composableBuilder(
    column: $table.boardJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LevelProgressEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LevelProgressEntriesTable> {
  $$LevelProgressEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dictionaryCode => $composableBuilder(
    column: $table.dictionaryCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get levelNumber => $composableBuilder(
    column: $table.levelNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secretWord => $composableBuilder(
    column: $table.secretWord,
    builder: (column) => column,
  );

  GeneratedColumn<String> get boardJson =>
      $composableBuilder(column: $table.boardJson, builder: (column) => column);
}

class $$LevelProgressEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LevelProgressEntriesTable,
          LevelProgressRow,
          $$LevelProgressEntriesTableFilterComposer,
          $$LevelProgressEntriesTableOrderingComposer,
          $$LevelProgressEntriesTableAnnotationComposer,
          $$LevelProgressEntriesTableCreateCompanionBuilder,
          $$LevelProgressEntriesTableUpdateCompanionBuilder,
          (
            LevelProgressRow,
            BaseReferences<
              _$AppDatabase,
              $LevelProgressEntriesTable,
              LevelProgressRow
            >,
          ),
          LevelProgressRow,
          PrefetchHooks Function()
        > {
  $$LevelProgressEntriesTableTableManager(
    _$AppDatabase db,
    $LevelProgressEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevelProgressEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevelProgressEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LevelProgressEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> dictionaryCode = const Value.absent(),
                Value<int> levelNumber = const Value.absent(),
                Value<String> secretWord = const Value.absent(),
                Value<String> boardJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LevelProgressEntriesCompanion(
                dictionaryCode: dictionaryCode,
                levelNumber: levelNumber,
                secretWord: secretWord,
                boardJson: boardJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dictionaryCode,
                required int levelNumber,
                required String secretWord,
                required String boardJson,
                Value<int> rowid = const Value.absent(),
              }) => LevelProgressEntriesCompanion.insert(
                dictionaryCode: dictionaryCode,
                levelNumber: levelNumber,
                secretWord: secretWord,
                boardJson: boardJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LevelProgressEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LevelProgressEntriesTable,
      LevelProgressRow,
      $$LevelProgressEntriesTableFilterComposer,
      $$LevelProgressEntriesTableOrderingComposer,
      $$LevelProgressEntriesTableAnnotationComposer,
      $$LevelProgressEntriesTableCreateCompanionBuilder,
      $$LevelProgressEntriesTableUpdateCompanionBuilder,
      (
        LevelProgressRow,
        BaseReferences<
          _$AppDatabase,
          $LevelProgressEntriesTable,
          LevelProgressRow
        >,
      ),
      LevelProgressRow,
      PrefetchHooks Function()
    >;
typedef $$MigrationMarkersTableCreateCompanionBuilder =
    MigrationMarkersCompanion Function({
      required String migrationKey,
      required int version,
      Value<int> rowid,
    });
typedef $$MigrationMarkersTableUpdateCompanionBuilder =
    MigrationMarkersCompanion Function({
      Value<String> migrationKey,
      Value<int> version,
      Value<int> rowid,
    });

class $$MigrationMarkersTableFilterComposer
    extends Composer<_$AppDatabase, $MigrationMarkersTable> {
  $$MigrationMarkersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get migrationKey => $composableBuilder(
    column: $table.migrationKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MigrationMarkersTableOrderingComposer
    extends Composer<_$AppDatabase, $MigrationMarkersTable> {
  $$MigrationMarkersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get migrationKey => $composableBuilder(
    column: $table.migrationKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MigrationMarkersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MigrationMarkersTable> {
  $$MigrationMarkersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get migrationKey => $composableBuilder(
    column: $table.migrationKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$MigrationMarkersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MigrationMarkersTable,
          MigrationMarkerRow,
          $$MigrationMarkersTableFilterComposer,
          $$MigrationMarkersTableOrderingComposer,
          $$MigrationMarkersTableAnnotationComposer,
          $$MigrationMarkersTableCreateCompanionBuilder,
          $$MigrationMarkersTableUpdateCompanionBuilder,
          (
            MigrationMarkerRow,
            BaseReferences<
              _$AppDatabase,
              $MigrationMarkersTable,
              MigrationMarkerRow
            >,
          ),
          MigrationMarkerRow,
          PrefetchHooks Function()
        > {
  $$MigrationMarkersTableTableManager(
    _$AppDatabase db,
    $MigrationMarkersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MigrationMarkersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MigrationMarkersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MigrationMarkersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> migrationKey = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MigrationMarkersCompanion(
                migrationKey: migrationKey,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String migrationKey,
                required int version,
                Value<int> rowid = const Value.absent(),
              }) => MigrationMarkersCompanion.insert(
                migrationKey: migrationKey,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MigrationMarkersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MigrationMarkersTable,
      MigrationMarkerRow,
      $$MigrationMarkersTableFilterComposer,
      $$MigrationMarkersTableOrderingComposer,
      $$MigrationMarkersTableAnnotationComposer,
      $$MigrationMarkersTableCreateCompanionBuilder,
      $$MigrationMarkersTableUpdateCompanionBuilder,
      (
        MigrationMarkerRow,
        BaseReferences<
          _$AppDatabase,
          $MigrationMarkersTable,
          MigrationMarkerRow
        >,
      ),
      MigrationMarkerRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LevelResultsTableTableManager get levelResults =>
      $$LevelResultsTableTableManager(_db, _db.levelResults);
  $$LevelProgressEntriesTableTableManager get levelProgressEntries =>
      $$LevelProgressEntriesTableTableManager(_db, _db.levelProgressEntries);
  $$MigrationMarkersTableTableManager get migrationMarkers =>
      $$MigrationMarkersTableTableManager(_db, _db.migrationMarkers);
}
