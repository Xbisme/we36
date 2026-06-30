// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, CachedUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPrivateMeta = const VerificationMeta(
    'isPrivate',
  );
  @override
  late final GeneratedColumn<bool> isPrivate = GeneratedColumn<bool>(
    'is_private',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_private" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isVerifiedMeta = const VerificationMeta(
    'isVerified',
  );
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
    'is_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_verified" IN (0, 1))',
    ),
  );
  static const VerificationMeta _followersCountMeta = const VerificationMeta(
    'followersCount',
  );
  @override
  late final GeneratedColumn<int> followersCount = GeneratedColumn<int>(
    'followers_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _followingCountMeta = const VerificationMeta(
    'followingCount',
  );
  @override
  late final GeneratedColumn<int> followingCount = GeneratedColumn<int>(
    'following_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postsCountMeta = const VerificationMeta(
    'postsCount',
  );
  @override
  late final GeneratedColumn<int> postsCount = GeneratedColumn<int>(
    'posts_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    displayName,
    avatarUrl,
    bio,
    isPrivate,
    isVerified,
    followersCount,
    followingCount,
    postsCount,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    if (data.containsKey('is_private')) {
      context.handle(
        _isPrivateMeta,
        isPrivate.isAcceptableOrUnknown(data['is_private']!, _isPrivateMeta),
      );
    } else if (isInserting) {
      context.missing(_isPrivateMeta);
    }
    if (data.containsKey('is_verified')) {
      context.handle(
        _isVerifiedMeta,
        isVerified.isAcceptableOrUnknown(data['is_verified']!, _isVerifiedMeta),
      );
    } else if (isInserting) {
      context.missing(_isVerifiedMeta);
    }
    if (data.containsKey('followers_count')) {
      context.handle(
        _followersCountMeta,
        followersCount.isAcceptableOrUnknown(
          data['followers_count']!,
          _followersCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_followersCountMeta);
    }
    if (data.containsKey('following_count')) {
      context.handle(
        _followingCountMeta,
        followingCount.isAcceptableOrUnknown(
          data['following_count']!,
          _followingCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_followingCountMeta);
    }
    if (data.containsKey('posts_count')) {
      context.handle(
        _postsCountMeta,
        postsCount.isAcceptableOrUnknown(data['posts_count']!, _postsCountMeta),
      );
    } else if (isInserting) {
      context.missing(_postsCountMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedUser(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      ),
      isPrivate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_private'],
      )!,
      isVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_verified'],
      )!,
      followersCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}followers_count'],
      )!,
      followingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}following_count'],
      )!,
      postsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}posts_count'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class CachedUser extends DataClass implements Insertable<CachedUser> {
  final String id;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final String? bio;
  final bool isPrivate;
  final bool isVerified;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final DateTime cachedAt;
  const CachedUser({
    required this.id,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    this.bio,
    required this.isPrivate,
    required this.isVerified,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    map['is_private'] = Variable<bool>(isPrivate);
    map['is_verified'] = Variable<bool>(isVerified);
    map['followers_count'] = Variable<int>(followersCount);
    map['following_count'] = Variable<int>(followingCount);
    map['posts_count'] = Variable<int>(postsCount);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      displayName: Value(displayName),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      isPrivate: Value(isPrivate),
      isVerified: Value(isVerified),
      followersCount: Value(followersCount),
      followingCount: Value(followingCount),
      postsCount: Value(postsCount),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedUser(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      displayName: serializer.fromJson<String>(json['displayName']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      bio: serializer.fromJson<String?>(json['bio']),
      isPrivate: serializer.fromJson<bool>(json['isPrivate']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      followersCount: serializer.fromJson<int>(json['followersCount']),
      followingCount: serializer.fromJson<int>(json['followingCount']),
      postsCount: serializer.fromJson<int>(json['postsCount']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'displayName': serializer.toJson<String>(displayName),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'bio': serializer.toJson<String?>(bio),
      'isPrivate': serializer.toJson<bool>(isPrivate),
      'isVerified': serializer.toJson<bool>(isVerified),
      'followersCount': serializer.toJson<int>(followersCount),
      'followingCount': serializer.toJson<int>(followingCount),
      'postsCount': serializer.toJson<int>(postsCount),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedUser copyWith({
    String? id,
    String? username,
    String? displayName,
    Value<String?> avatarUrl = const Value.absent(),
    Value<String?> bio = const Value.absent(),
    bool? isPrivate,
    bool? isVerified,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    DateTime? cachedAt,
  }) => CachedUser(
    id: id ?? this.id,
    username: username ?? this.username,
    displayName: displayName ?? this.displayName,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    bio: bio.present ? bio.value : this.bio,
    isPrivate: isPrivate ?? this.isPrivate,
    isVerified: isVerified ?? this.isVerified,
    followersCount: followersCount ?? this.followersCount,
    followingCount: followingCount ?? this.followingCount,
    postsCount: postsCount ?? this.postsCount,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedUser copyWithCompanion(UsersCompanion data) {
    return CachedUser(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      bio: data.bio.present ? data.bio.value : this.bio,
      isPrivate: data.isPrivate.present ? data.isPrivate.value : this.isPrivate,
      isVerified: data.isVerified.present
          ? data.isVerified.value
          : this.isVerified,
      followersCount: data.followersCount.present
          ? data.followersCount.value
          : this.followersCount,
      followingCount: data.followingCount.present
          ? data.followingCount.value
          : this.followingCount,
      postsCount: data.postsCount.present
          ? data.postsCount.value
          : this.postsCount,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedUser(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('bio: $bio, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('isVerified: $isVerified, ')
          ..write('followersCount: $followersCount, ')
          ..write('followingCount: $followingCount, ')
          ..write('postsCount: $postsCount, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    displayName,
    avatarUrl,
    bio,
    isPrivate,
    isVerified,
    followersCount,
    followingCount,
    postsCount,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedUser &&
          other.id == this.id &&
          other.username == this.username &&
          other.displayName == this.displayName &&
          other.avatarUrl == this.avatarUrl &&
          other.bio == this.bio &&
          other.isPrivate == this.isPrivate &&
          other.isVerified == this.isVerified &&
          other.followersCount == this.followersCount &&
          other.followingCount == this.followingCount &&
          other.postsCount == this.postsCount &&
          other.cachedAt == this.cachedAt);
}

class UsersCompanion extends UpdateCompanion<CachedUser> {
  final Value<String> id;
  final Value<String> username;
  final Value<String> displayName;
  final Value<String?> avatarUrl;
  final Value<String?> bio;
  final Value<bool> isPrivate;
  final Value<bool> isVerified;
  final Value<int> followersCount;
  final Value<int> followingCount;
  final Value<int> postsCount;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.bio = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.followersCount = const Value.absent(),
    this.followingCount = const Value.absent(),
    this.postsCount = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String username,
    required String displayName,
    this.avatarUrl = const Value.absent(),
    this.bio = const Value.absent(),
    required bool isPrivate,
    required bool isVerified,
    required int followersCount,
    required int followingCount,
    required int postsCount,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       username = Value(username),
       displayName = Value(displayName),
       isPrivate = Value(isPrivate),
       isVerified = Value(isVerified),
       followersCount = Value(followersCount),
       followingCount = Value(followingCount),
       postsCount = Value(postsCount),
       cachedAt = Value(cachedAt);
  static Insertable<CachedUser> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? displayName,
    Expression<String>? avatarUrl,
    Expression<String>? bio,
    Expression<bool>? isPrivate,
    Expression<bool>? isVerified,
    Expression<int>? followersCount,
    Expression<int>? followingCount,
    Expression<int>? postsCount,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (bio != null) 'bio': bio,
      if (isPrivate != null) 'is_private': isPrivate,
      if (isVerified != null) 'is_verified': isVerified,
      if (followersCount != null) 'followers_count': followersCount,
      if (followingCount != null) 'following_count': followingCount,
      if (postsCount != null) 'posts_count': postsCount,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? username,
    Value<String>? displayName,
    Value<String?>? avatarUrl,
    Value<String?>? bio,
    Value<bool>? isPrivate,
    Value<bool>? isVerified,
    Value<int>? followersCount,
    Value<int>? followingCount,
    Value<int>? postsCount,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      isPrivate: isPrivate ?? this.isPrivate,
      isVerified: isVerified ?? this.isVerified,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (isPrivate.present) {
      map['is_private'] = Variable<bool>(isPrivate.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (followersCount.present) {
      map['followers_count'] = Variable<int>(followersCount.value);
    }
    if (followingCount.present) {
      map['following_count'] = Variable<int>(followingCount.value);
    }
    if (postsCount.present) {
      map['posts_count'] = Variable<int>(postsCount.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('bio: $bio, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('isVerified: $isVerified, ')
          ..write('followersCount: $followersCount, ')
          ..write('followingCount: $followingCount, ')
          ..write('postsCount: $postsCount, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final UsersDao usersDao = UsersDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [users];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String username,
      required String displayName,
      Value<String?> avatarUrl,
      Value<String?> bio,
      required bool isPrivate,
      required bool isVerified,
      required int followersCount,
      required int followingCount,
      required int postsCount,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> username,
      Value<String> displayName,
      Value<String?> avatarUrl,
      Value<String?> bio,
      Value<bool> isPrivate,
      Value<bool> isVerified,
      Value<int> followersCount,
      Value<int> followingCount,
      Value<int> postsCount,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPrivate => $composableBuilder(
    column: $table.isPrivate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get followersCount => $composableBuilder(
    column: $table.followersCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get followingCount => $composableBuilder(
    column: $table.followingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get postsCount => $composableBuilder(
    column: $table.postsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPrivate => $composableBuilder(
    column: $table.isPrivate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get followersCount => $composableBuilder(
    column: $table.followersCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get followingCount => $composableBuilder(
    column: $table.followingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get postsCount => $composableBuilder(
    column: $table.postsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<bool> get isPrivate =>
      $composableBuilder(column: $table.isPrivate, builder: (column) => column);

  GeneratedColumn<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => column,
  );

  GeneratedColumn<int> get followersCount => $composableBuilder(
    column: $table.followersCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get followingCount => $composableBuilder(
    column: $table.followingCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get postsCount => $composableBuilder(
    column: $table.postsCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          CachedUser,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (CachedUser, BaseReferences<_$AppDatabase, $UsersTable, CachedUser>),
          CachedUser,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<bool> isPrivate = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<int> followersCount = const Value.absent(),
                Value<int> followingCount = const Value.absent(),
                Value<int> postsCount = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                username: username,
                displayName: displayName,
                avatarUrl: avatarUrl,
                bio: bio,
                isPrivate: isPrivate,
                isVerified: isVerified,
                followersCount: followersCount,
                followingCount: followingCount,
                postsCount: postsCount,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String username,
                required String displayName,
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                required bool isPrivate,
                required bool isVerified,
                required int followersCount,
                required int followingCount,
                required int postsCount,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                username: username,
                displayName: displayName,
                avatarUrl: avatarUrl,
                bio: bio,
                isPrivate: isPrivate,
                isVerified: isVerified,
                followersCount: followersCount,
                followingCount: followingCount,
                postsCount: postsCount,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      CachedUser,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (CachedUser, BaseReferences<_$AppDatabase, $UsersTable, CachedUser>),
      CachedUser,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
}
