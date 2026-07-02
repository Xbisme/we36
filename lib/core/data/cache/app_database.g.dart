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

class $MeProfilesTable extends MeProfiles
    with TableInfo<$MeProfilesTable, CachedMeProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarMediaIdMeta = const VerificationMeta(
    'avatarMediaId',
  );
  @override
  late final GeneratedColumn<String> avatarMediaId = GeneratedColumn<String>(
    'avatar_media_id',
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
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pronounsMeta = const VerificationMeta(
    'pronouns',
  );
  @override
  late final GeneratedColumn<String> pronouns = GeneratedColumn<String>(
    'pronouns',
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
  static const VerificationMeta _profileCompletedMeta = const VerificationMeta(
    'profileCompleted',
  );
  @override
  late final GeneratedColumn<bool> profileCompleted = GeneratedColumn<bool>(
    'profile_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("profile_completed" IN (0, 1))',
    ),
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
    email,
    username,
    displayName,
    avatarMediaId,
    bio,
    website,
    pronouns,
    isPrivate,
    isVerified,
    profileCompleted,
    createdAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'me_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedMeProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('avatar_media_id')) {
      context.handle(
        _avatarMediaIdMeta,
        avatarMediaId.isAcceptableOrUnknown(
          data['avatar_media_id']!,
          _avatarMediaIdMeta,
        ),
      );
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('pronouns')) {
      context.handle(
        _pronounsMeta,
        pronouns.isAcceptableOrUnknown(data['pronouns']!, _pronounsMeta),
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
    if (data.containsKey('profile_completed')) {
      context.handle(
        _profileCompletedMeta,
        profileCompleted.isAcceptableOrUnknown(
          data['profile_completed']!,
          _profileCompletedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_profileCompletedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  CachedMeProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedMeProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      avatarMediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_media_id'],
      ),
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      ),
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      pronouns: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pronouns'],
      ),
      isPrivate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_private'],
      )!,
      isVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_verified'],
      )!,
      profileCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}profile_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $MeProfilesTable createAlias(String alias) {
    return $MeProfilesTable(attachedDatabase, alias);
  }
}

class CachedMeProfile extends DataClass implements Insertable<CachedMeProfile> {
  final String id;
  final String email;
  final String? username;
  final String? displayName;
  final String? avatarMediaId;
  final String? bio;
  final String? website;
  final String? pronouns;
  final bool isPrivate;
  final bool isVerified;
  final bool profileCompleted;
  final DateTime createdAt;
  final DateTime cachedAt;
  const CachedMeProfile({
    required this.id,
    required this.email,
    this.username,
    this.displayName,
    this.avatarMediaId,
    this.bio,
    this.website,
    this.pronouns,
    required this.isPrivate,
    required this.isVerified,
    required this.profileCompleted,
    required this.createdAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || avatarMediaId != null) {
      map['avatar_media_id'] = Variable<String>(avatarMediaId);
    }
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    if (!nullToAbsent || pronouns != null) {
      map['pronouns'] = Variable<String>(pronouns);
    }
    map['is_private'] = Variable<bool>(isPrivate);
    map['is_verified'] = Variable<bool>(isVerified);
    map['profile_completed'] = Variable<bool>(profileCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  MeProfilesCompanion toCompanion(bool nullToAbsent) {
    return MeProfilesCompanion(
      id: Value(id),
      email: Value(email),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      avatarMediaId: avatarMediaId == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarMediaId),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      pronouns: pronouns == null && nullToAbsent
          ? const Value.absent()
          : Value(pronouns),
      isPrivate: Value(isPrivate),
      isVerified: Value(isVerified),
      profileCompleted: Value(profileCompleted),
      createdAt: Value(createdAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedMeProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedMeProfile(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      username: serializer.fromJson<String?>(json['username']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      avatarMediaId: serializer.fromJson<String?>(json['avatarMediaId']),
      bio: serializer.fromJson<String?>(json['bio']),
      website: serializer.fromJson<String?>(json['website']),
      pronouns: serializer.fromJson<String?>(json['pronouns']),
      isPrivate: serializer.fromJson<bool>(json['isPrivate']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      profileCompleted: serializer.fromJson<bool>(json['profileCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'username': serializer.toJson<String?>(username),
      'displayName': serializer.toJson<String?>(displayName),
      'avatarMediaId': serializer.toJson<String?>(avatarMediaId),
      'bio': serializer.toJson<String?>(bio),
      'website': serializer.toJson<String?>(website),
      'pronouns': serializer.toJson<String?>(pronouns),
      'isPrivate': serializer.toJson<bool>(isPrivate),
      'isVerified': serializer.toJson<bool>(isVerified),
      'profileCompleted': serializer.toJson<bool>(profileCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedMeProfile copyWith({
    String? id,
    String? email,
    Value<String?> username = const Value.absent(),
    Value<String?> displayName = const Value.absent(),
    Value<String?> avatarMediaId = const Value.absent(),
    Value<String?> bio = const Value.absent(),
    Value<String?> website = const Value.absent(),
    Value<String?> pronouns = const Value.absent(),
    bool? isPrivate,
    bool? isVerified,
    bool? profileCompleted,
    DateTime? createdAt,
    DateTime? cachedAt,
  }) => CachedMeProfile(
    id: id ?? this.id,
    email: email ?? this.email,
    username: username.present ? username.value : this.username,
    displayName: displayName.present ? displayName.value : this.displayName,
    avatarMediaId: avatarMediaId.present
        ? avatarMediaId.value
        : this.avatarMediaId,
    bio: bio.present ? bio.value : this.bio,
    website: website.present ? website.value : this.website,
    pronouns: pronouns.present ? pronouns.value : this.pronouns,
    isPrivate: isPrivate ?? this.isPrivate,
    isVerified: isVerified ?? this.isVerified,
    profileCompleted: profileCompleted ?? this.profileCompleted,
    createdAt: createdAt ?? this.createdAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedMeProfile copyWithCompanion(MeProfilesCompanion data) {
    return CachedMeProfile(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      username: data.username.present ? data.username.value : this.username,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      avatarMediaId: data.avatarMediaId.present
          ? data.avatarMediaId.value
          : this.avatarMediaId,
      bio: data.bio.present ? data.bio.value : this.bio,
      website: data.website.present ? data.website.value : this.website,
      pronouns: data.pronouns.present ? data.pronouns.value : this.pronouns,
      isPrivate: data.isPrivate.present ? data.isPrivate.value : this.isPrivate,
      isVerified: data.isVerified.present
          ? data.isVerified.value
          : this.isVerified,
      profileCompleted: data.profileCompleted.present
          ? data.profileCompleted.value
          : this.profileCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedMeProfile(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('avatarMediaId: $avatarMediaId, ')
          ..write('bio: $bio, ')
          ..write('website: $website, ')
          ..write('pronouns: $pronouns, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('isVerified: $isVerified, ')
          ..write('profileCompleted: $profileCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    username,
    displayName,
    avatarMediaId,
    bio,
    website,
    pronouns,
    isPrivate,
    isVerified,
    profileCompleted,
    createdAt,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedMeProfile &&
          other.id == this.id &&
          other.email == this.email &&
          other.username == this.username &&
          other.displayName == this.displayName &&
          other.avatarMediaId == this.avatarMediaId &&
          other.bio == this.bio &&
          other.website == this.website &&
          other.pronouns == this.pronouns &&
          other.isPrivate == this.isPrivate &&
          other.isVerified == this.isVerified &&
          other.profileCompleted == this.profileCompleted &&
          other.createdAt == this.createdAt &&
          other.cachedAt == this.cachedAt);
}

class MeProfilesCompanion extends UpdateCompanion<CachedMeProfile> {
  final Value<String> id;
  final Value<String> email;
  final Value<String?> username;
  final Value<String?> displayName;
  final Value<String?> avatarMediaId;
  final Value<String?> bio;
  final Value<String?> website;
  final Value<String?> pronouns;
  final Value<bool> isPrivate;
  final Value<bool> isVerified;
  final Value<bool> profileCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const MeProfilesCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.avatarMediaId = const Value.absent(),
    this.bio = const Value.absent(),
    this.website = const Value.absent(),
    this.pronouns = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.profileCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeProfilesCompanion.insert({
    required String id,
    required String email,
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.avatarMediaId = const Value.absent(),
    this.bio = const Value.absent(),
    this.website = const Value.absent(),
    this.pronouns = const Value.absent(),
    required bool isPrivate,
    required bool isVerified,
    required bool profileCompleted,
    required DateTime createdAt,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email),
       isPrivate = Value(isPrivate),
       isVerified = Value(isVerified),
       profileCompleted = Value(profileCompleted),
       createdAt = Value(createdAt),
       cachedAt = Value(cachedAt);
  static Insertable<CachedMeProfile> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? username,
    Expression<String>? displayName,
    Expression<String>? avatarMediaId,
    Expression<String>? bio,
    Expression<String>? website,
    Expression<String>? pronouns,
    Expression<bool>? isPrivate,
    Expression<bool>? isVerified,
    Expression<bool>? profileCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (avatarMediaId != null) 'avatar_media_id': avatarMediaId,
      if (bio != null) 'bio': bio,
      if (website != null) 'website': website,
      if (pronouns != null) 'pronouns': pronouns,
      if (isPrivate != null) 'is_private': isPrivate,
      if (isVerified != null) 'is_verified': isVerified,
      if (profileCompleted != null) 'profile_completed': profileCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String?>? username,
    Value<String?>? displayName,
    Value<String?>? avatarMediaId,
    Value<String?>? bio,
    Value<String?>? website,
    Value<String?>? pronouns,
    Value<bool>? isPrivate,
    Value<bool>? isVerified,
    Value<bool>? profileCompleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return MeProfilesCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarMediaId: avatarMediaId ?? this.avatarMediaId,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      pronouns: pronouns ?? this.pronouns,
      isPrivate: isPrivate ?? this.isPrivate,
      isVerified: isVerified ?? this.isVerified,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      createdAt: createdAt ?? this.createdAt,
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
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (avatarMediaId.present) {
      map['avatar_media_id'] = Variable<String>(avatarMediaId.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (pronouns.present) {
      map['pronouns'] = Variable<String>(pronouns.value);
    }
    if (isPrivate.present) {
      map['is_private'] = Variable<bool>(isPrivate.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (profileCompleted.present) {
      map['profile_completed'] = Variable<bool>(profileCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('MeProfilesCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('avatarMediaId: $avatarMediaId, ')
          ..write('bio: $bio, ')
          ..write('website: $website, ')
          ..write('pronouns: $pronouns, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('isVerified: $isVerified, ')
          ..write('profileCompleted: $profileCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostsTable extends Posts with TableInfo<$PostsTable, CachedPost> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorUsernameMeta = const VerificationMeta(
    'authorUsername',
  );
  @override
  late final GeneratedColumn<String> authorUsername = GeneratedColumn<String>(
    'author_username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorDisplayNameMeta = const VerificationMeta(
    'authorDisplayName',
  );
  @override
  late final GeneratedColumn<String> authorDisplayName =
      GeneratedColumn<String>(
        'author_display_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _authorAvatarUrlMeta = const VerificationMeta(
    'authorAvatarUrl',
  );
  @override
  late final GeneratedColumn<String> authorAvatarUrl = GeneratedColumn<String>(
    'author_avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorIsVerifiedMeta = const VerificationMeta(
    'authorIsVerified',
  );
  @override
  late final GeneratedColumn<bool> authorIsVerified = GeneratedColumn<bool>(
    'author_is_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("author_is_verified" IN (0, 1))',
    ),
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaImageUrlMeta = const VerificationMeta(
    'mediaImageUrl',
  );
  @override
  late final GeneratedColumn<String> mediaImageUrl = GeneratedColumn<String>(
    'media_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaWidthMeta = const VerificationMeta(
    'mediaWidth',
  );
  @override
  late final GeneratedColumn<int> mediaWidth = GeneratedColumn<int>(
    'media_width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaHeightMeta = const VerificationMeta(
    'mediaHeight',
  );
  @override
  late final GeneratedColumn<int> mediaHeight = GeneratedColumn<int>(
    'media_height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationNameMeta = const VerificationMeta(
    'locationName',
  );
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
    'location_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _likeCountMeta = const VerificationMeta(
    'likeCount',
  );
  @override
  late final GeneratedColumn<int> likeCount = GeneratedColumn<int>(
    'like_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saveCountMeta = const VerificationMeta(
    'saveCount',
  );
  @override
  late final GeneratedColumn<int> saveCount = GeneratedColumn<int>(
    'save_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commentCountMeta = const VerificationMeta(
    'commentCount',
  );
  @override
  late final GeneratedColumn<int> commentCount = GeneratedColumn<int>(
    'comment_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _viewerHasLikedMeta = const VerificationMeta(
    'viewerHasLiked',
  );
  @override
  late final GeneratedColumn<bool> viewerHasLiked = GeneratedColumn<bool>(
    'viewer_has_liked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("viewer_has_liked" IN (0, 1))',
    ),
  );
  static const VerificationMeta _viewerHasSavedMeta = const VerificationMeta(
    'viewerHasSaved',
  );
  @override
  late final GeneratedColumn<bool> viewerHasSaved = GeneratedColumn<bool>(
    'viewer_has_saved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("viewer_has_saved" IN (0, 1))',
    ),
  );
  static const VerificationMeta _commentsDisabledMeta = const VerificationMeta(
    'commentsDisabled',
  );
  @override
  late final GeneratedColumn<bool> commentsDisabled = GeneratedColumn<bool>(
    'comments_disabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("comments_disabled" IN (0, 1))',
    ),
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
    authorId,
    authorUsername,
    authorDisplayName,
    authorAvatarUrl,
    authorIsVerified,
    caption,
    mediaImageUrl,
    mediaWidth,
    mediaHeight,
    locationName,
    likeCount,
    saveCount,
    commentCount,
    viewerHasLiked,
    viewerHasSaved,
    commentsDisabled,
    createdAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'posts';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedPost> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('author_username')) {
      context.handle(
        _authorUsernameMeta,
        authorUsername.isAcceptableOrUnknown(
          data['author_username']!,
          _authorUsernameMeta,
        ),
      );
    }
    if (data.containsKey('author_display_name')) {
      context.handle(
        _authorDisplayNameMeta,
        authorDisplayName.isAcceptableOrUnknown(
          data['author_display_name']!,
          _authorDisplayNameMeta,
        ),
      );
    }
    if (data.containsKey('author_avatar_url')) {
      context.handle(
        _authorAvatarUrlMeta,
        authorAvatarUrl.isAcceptableOrUnknown(
          data['author_avatar_url']!,
          _authorAvatarUrlMeta,
        ),
      );
    }
    if (data.containsKey('author_is_verified')) {
      context.handle(
        _authorIsVerifiedMeta,
        authorIsVerified.isAcceptableOrUnknown(
          data['author_is_verified']!,
          _authorIsVerifiedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorIsVerifiedMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('media_image_url')) {
      context.handle(
        _mediaImageUrlMeta,
        mediaImageUrl.isAcceptableOrUnknown(
          data['media_image_url']!,
          _mediaImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('media_width')) {
      context.handle(
        _mediaWidthMeta,
        mediaWidth.isAcceptableOrUnknown(data['media_width']!, _mediaWidthMeta),
      );
    }
    if (data.containsKey('media_height')) {
      context.handle(
        _mediaHeightMeta,
        mediaHeight.isAcceptableOrUnknown(
          data['media_height']!,
          _mediaHeightMeta,
        ),
      );
    }
    if (data.containsKey('location_name')) {
      context.handle(
        _locationNameMeta,
        locationName.isAcceptableOrUnknown(
          data['location_name']!,
          _locationNameMeta,
        ),
      );
    }
    if (data.containsKey('like_count')) {
      context.handle(
        _likeCountMeta,
        likeCount.isAcceptableOrUnknown(data['like_count']!, _likeCountMeta),
      );
    } else if (isInserting) {
      context.missing(_likeCountMeta);
    }
    if (data.containsKey('save_count')) {
      context.handle(
        _saveCountMeta,
        saveCount.isAcceptableOrUnknown(data['save_count']!, _saveCountMeta),
      );
    } else if (isInserting) {
      context.missing(_saveCountMeta);
    }
    if (data.containsKey('comment_count')) {
      context.handle(
        _commentCountMeta,
        commentCount.isAcceptableOrUnknown(
          data['comment_count']!,
          _commentCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_commentCountMeta);
    }
    if (data.containsKey('viewer_has_liked')) {
      context.handle(
        _viewerHasLikedMeta,
        viewerHasLiked.isAcceptableOrUnknown(
          data['viewer_has_liked']!,
          _viewerHasLikedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_viewerHasLikedMeta);
    }
    if (data.containsKey('viewer_has_saved')) {
      context.handle(
        _viewerHasSavedMeta,
        viewerHasSaved.isAcceptableOrUnknown(
          data['viewer_has_saved']!,
          _viewerHasSavedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_viewerHasSavedMeta);
    }
    if (data.containsKey('comments_disabled')) {
      context.handle(
        _commentsDisabledMeta,
        commentsDisabled.isAcceptableOrUnknown(
          data['comments_disabled']!,
          _commentsDisabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_commentsDisabledMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  CachedPost map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedPost(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      authorUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_username'],
      ),
      authorDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_display_name'],
      ),
      authorAvatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_avatar_url'],
      ),
      authorIsVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}author_is_verified'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      mediaImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_image_url'],
      ),
      mediaWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_width'],
      ),
      mediaHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_height'],
      ),
      locationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_name'],
      ),
      likeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}like_count'],
      )!,
      saveCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}save_count'],
      )!,
      commentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}comment_count'],
      )!,
      viewerHasLiked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}viewer_has_liked'],
      )!,
      viewerHasSaved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}viewer_has_saved'],
      )!,
      commentsDisabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}comments_disabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $PostsTable createAlias(String alias) {
    return $PostsTable(attachedDatabase, alias);
  }
}

class CachedPost extends DataClass implements Insertable<CachedPost> {
  final String id;
  final String authorId;
  final String? authorUsername;
  final String? authorDisplayName;
  final String? authorAvatarUrl;
  final bool authorIsVerified;
  final String? caption;
  final String? mediaImageUrl;
  final int? mediaWidth;
  final int? mediaHeight;
  final String? locationName;
  final int likeCount;
  final int saveCount;
  final int commentCount;
  final bool viewerHasLiked;
  final bool viewerHasSaved;
  final bool commentsDisabled;
  final DateTime createdAt;
  final DateTime cachedAt;
  const CachedPost({
    required this.id,
    required this.authorId,
    this.authorUsername,
    this.authorDisplayName,
    this.authorAvatarUrl,
    required this.authorIsVerified,
    this.caption,
    this.mediaImageUrl,
    this.mediaWidth,
    this.mediaHeight,
    this.locationName,
    required this.likeCount,
    required this.saveCount,
    required this.commentCount,
    required this.viewerHasLiked,
    required this.viewerHasSaved,
    required this.commentsDisabled,
    required this.createdAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['author_id'] = Variable<String>(authorId);
    if (!nullToAbsent || authorUsername != null) {
      map['author_username'] = Variable<String>(authorUsername);
    }
    if (!nullToAbsent || authorDisplayName != null) {
      map['author_display_name'] = Variable<String>(authorDisplayName);
    }
    if (!nullToAbsent || authorAvatarUrl != null) {
      map['author_avatar_url'] = Variable<String>(authorAvatarUrl);
    }
    map['author_is_verified'] = Variable<bool>(authorIsVerified);
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    if (!nullToAbsent || mediaImageUrl != null) {
      map['media_image_url'] = Variable<String>(mediaImageUrl);
    }
    if (!nullToAbsent || mediaWidth != null) {
      map['media_width'] = Variable<int>(mediaWidth);
    }
    if (!nullToAbsent || mediaHeight != null) {
      map['media_height'] = Variable<int>(mediaHeight);
    }
    if (!nullToAbsent || locationName != null) {
      map['location_name'] = Variable<String>(locationName);
    }
    map['like_count'] = Variable<int>(likeCount);
    map['save_count'] = Variable<int>(saveCount);
    map['comment_count'] = Variable<int>(commentCount);
    map['viewer_has_liked'] = Variable<bool>(viewerHasLiked);
    map['viewer_has_saved'] = Variable<bool>(viewerHasSaved);
    map['comments_disabled'] = Variable<bool>(commentsDisabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  PostsCompanion toCompanion(bool nullToAbsent) {
    return PostsCompanion(
      id: Value(id),
      authorId: Value(authorId),
      authorUsername: authorUsername == null && nullToAbsent
          ? const Value.absent()
          : Value(authorUsername),
      authorDisplayName: authorDisplayName == null && nullToAbsent
          ? const Value.absent()
          : Value(authorDisplayName),
      authorAvatarUrl: authorAvatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(authorAvatarUrl),
      authorIsVerified: Value(authorIsVerified),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      mediaImageUrl: mediaImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaImageUrl),
      mediaWidth: mediaWidth == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaWidth),
      mediaHeight: mediaHeight == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaHeight),
      locationName: locationName == null && nullToAbsent
          ? const Value.absent()
          : Value(locationName),
      likeCount: Value(likeCount),
      saveCount: Value(saveCount),
      commentCount: Value(commentCount),
      viewerHasLiked: Value(viewerHasLiked),
      viewerHasSaved: Value(viewerHasSaved),
      commentsDisabled: Value(commentsDisabled),
      createdAt: Value(createdAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedPost.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedPost(
      id: serializer.fromJson<String>(json['id']),
      authorId: serializer.fromJson<String>(json['authorId']),
      authorUsername: serializer.fromJson<String?>(json['authorUsername']),
      authorDisplayName: serializer.fromJson<String?>(
        json['authorDisplayName'],
      ),
      authorAvatarUrl: serializer.fromJson<String?>(json['authorAvatarUrl']),
      authorIsVerified: serializer.fromJson<bool>(json['authorIsVerified']),
      caption: serializer.fromJson<String?>(json['caption']),
      mediaImageUrl: serializer.fromJson<String?>(json['mediaImageUrl']),
      mediaWidth: serializer.fromJson<int?>(json['mediaWidth']),
      mediaHeight: serializer.fromJson<int?>(json['mediaHeight']),
      locationName: serializer.fromJson<String?>(json['locationName']),
      likeCount: serializer.fromJson<int>(json['likeCount']),
      saveCount: serializer.fromJson<int>(json['saveCount']),
      commentCount: serializer.fromJson<int>(json['commentCount']),
      viewerHasLiked: serializer.fromJson<bool>(json['viewerHasLiked']),
      viewerHasSaved: serializer.fromJson<bool>(json['viewerHasSaved']),
      commentsDisabled: serializer.fromJson<bool>(json['commentsDisabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'authorId': serializer.toJson<String>(authorId),
      'authorUsername': serializer.toJson<String?>(authorUsername),
      'authorDisplayName': serializer.toJson<String?>(authorDisplayName),
      'authorAvatarUrl': serializer.toJson<String?>(authorAvatarUrl),
      'authorIsVerified': serializer.toJson<bool>(authorIsVerified),
      'caption': serializer.toJson<String?>(caption),
      'mediaImageUrl': serializer.toJson<String?>(mediaImageUrl),
      'mediaWidth': serializer.toJson<int?>(mediaWidth),
      'mediaHeight': serializer.toJson<int?>(mediaHeight),
      'locationName': serializer.toJson<String?>(locationName),
      'likeCount': serializer.toJson<int>(likeCount),
      'saveCount': serializer.toJson<int>(saveCount),
      'commentCount': serializer.toJson<int>(commentCount),
      'viewerHasLiked': serializer.toJson<bool>(viewerHasLiked),
      'viewerHasSaved': serializer.toJson<bool>(viewerHasSaved),
      'commentsDisabled': serializer.toJson<bool>(commentsDisabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedPost copyWith({
    String? id,
    String? authorId,
    Value<String?> authorUsername = const Value.absent(),
    Value<String?> authorDisplayName = const Value.absent(),
    Value<String?> authorAvatarUrl = const Value.absent(),
    bool? authorIsVerified,
    Value<String?> caption = const Value.absent(),
    Value<String?> mediaImageUrl = const Value.absent(),
    Value<int?> mediaWidth = const Value.absent(),
    Value<int?> mediaHeight = const Value.absent(),
    Value<String?> locationName = const Value.absent(),
    int? likeCount,
    int? saveCount,
    int? commentCount,
    bool? viewerHasLiked,
    bool? viewerHasSaved,
    bool? commentsDisabled,
    DateTime? createdAt,
    DateTime? cachedAt,
  }) => CachedPost(
    id: id ?? this.id,
    authorId: authorId ?? this.authorId,
    authorUsername: authorUsername.present
        ? authorUsername.value
        : this.authorUsername,
    authorDisplayName: authorDisplayName.present
        ? authorDisplayName.value
        : this.authorDisplayName,
    authorAvatarUrl: authorAvatarUrl.present
        ? authorAvatarUrl.value
        : this.authorAvatarUrl,
    authorIsVerified: authorIsVerified ?? this.authorIsVerified,
    caption: caption.present ? caption.value : this.caption,
    mediaImageUrl: mediaImageUrl.present
        ? mediaImageUrl.value
        : this.mediaImageUrl,
    mediaWidth: mediaWidth.present ? mediaWidth.value : this.mediaWidth,
    mediaHeight: mediaHeight.present ? mediaHeight.value : this.mediaHeight,
    locationName: locationName.present ? locationName.value : this.locationName,
    likeCount: likeCount ?? this.likeCount,
    saveCount: saveCount ?? this.saveCount,
    commentCount: commentCount ?? this.commentCount,
    viewerHasLiked: viewerHasLiked ?? this.viewerHasLiked,
    viewerHasSaved: viewerHasSaved ?? this.viewerHasSaved,
    commentsDisabled: commentsDisabled ?? this.commentsDisabled,
    createdAt: createdAt ?? this.createdAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedPost copyWithCompanion(PostsCompanion data) {
    return CachedPost(
      id: data.id.present ? data.id.value : this.id,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      authorUsername: data.authorUsername.present
          ? data.authorUsername.value
          : this.authorUsername,
      authorDisplayName: data.authorDisplayName.present
          ? data.authorDisplayName.value
          : this.authorDisplayName,
      authorAvatarUrl: data.authorAvatarUrl.present
          ? data.authorAvatarUrl.value
          : this.authorAvatarUrl,
      authorIsVerified: data.authorIsVerified.present
          ? data.authorIsVerified.value
          : this.authorIsVerified,
      caption: data.caption.present ? data.caption.value : this.caption,
      mediaImageUrl: data.mediaImageUrl.present
          ? data.mediaImageUrl.value
          : this.mediaImageUrl,
      mediaWidth: data.mediaWidth.present
          ? data.mediaWidth.value
          : this.mediaWidth,
      mediaHeight: data.mediaHeight.present
          ? data.mediaHeight.value
          : this.mediaHeight,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
      likeCount: data.likeCount.present ? data.likeCount.value : this.likeCount,
      saveCount: data.saveCount.present ? data.saveCount.value : this.saveCount,
      commentCount: data.commentCount.present
          ? data.commentCount.value
          : this.commentCount,
      viewerHasLiked: data.viewerHasLiked.present
          ? data.viewerHasLiked.value
          : this.viewerHasLiked,
      viewerHasSaved: data.viewerHasSaved.present
          ? data.viewerHasSaved.value
          : this.viewerHasSaved,
      commentsDisabled: data.commentsDisabled.present
          ? data.commentsDisabled.value
          : this.commentsDisabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedPost(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('authorDisplayName: $authorDisplayName, ')
          ..write('authorAvatarUrl: $authorAvatarUrl, ')
          ..write('authorIsVerified: $authorIsVerified, ')
          ..write('caption: $caption, ')
          ..write('mediaImageUrl: $mediaImageUrl, ')
          ..write('mediaWidth: $mediaWidth, ')
          ..write('mediaHeight: $mediaHeight, ')
          ..write('locationName: $locationName, ')
          ..write('likeCount: $likeCount, ')
          ..write('saveCount: $saveCount, ')
          ..write('commentCount: $commentCount, ')
          ..write('viewerHasLiked: $viewerHasLiked, ')
          ..write('viewerHasSaved: $viewerHasSaved, ')
          ..write('commentsDisabled: $commentsDisabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    authorId,
    authorUsername,
    authorDisplayName,
    authorAvatarUrl,
    authorIsVerified,
    caption,
    mediaImageUrl,
    mediaWidth,
    mediaHeight,
    locationName,
    likeCount,
    saveCount,
    commentCount,
    viewerHasLiked,
    viewerHasSaved,
    commentsDisabled,
    createdAt,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedPost &&
          other.id == this.id &&
          other.authorId == this.authorId &&
          other.authorUsername == this.authorUsername &&
          other.authorDisplayName == this.authorDisplayName &&
          other.authorAvatarUrl == this.authorAvatarUrl &&
          other.authorIsVerified == this.authorIsVerified &&
          other.caption == this.caption &&
          other.mediaImageUrl == this.mediaImageUrl &&
          other.mediaWidth == this.mediaWidth &&
          other.mediaHeight == this.mediaHeight &&
          other.locationName == this.locationName &&
          other.likeCount == this.likeCount &&
          other.saveCount == this.saveCount &&
          other.commentCount == this.commentCount &&
          other.viewerHasLiked == this.viewerHasLiked &&
          other.viewerHasSaved == this.viewerHasSaved &&
          other.commentsDisabled == this.commentsDisabled &&
          other.createdAt == this.createdAt &&
          other.cachedAt == this.cachedAt);
}

class PostsCompanion extends UpdateCompanion<CachedPost> {
  final Value<String> id;
  final Value<String> authorId;
  final Value<String?> authorUsername;
  final Value<String?> authorDisplayName;
  final Value<String?> authorAvatarUrl;
  final Value<bool> authorIsVerified;
  final Value<String?> caption;
  final Value<String?> mediaImageUrl;
  final Value<int?> mediaWidth;
  final Value<int?> mediaHeight;
  final Value<String?> locationName;
  final Value<int> likeCount;
  final Value<int> saveCount;
  final Value<int> commentCount;
  final Value<bool> viewerHasLiked;
  final Value<bool> viewerHasSaved;
  final Value<bool> commentsDisabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const PostsCompanion({
    this.id = const Value.absent(),
    this.authorId = const Value.absent(),
    this.authorUsername = const Value.absent(),
    this.authorDisplayName = const Value.absent(),
    this.authorAvatarUrl = const Value.absent(),
    this.authorIsVerified = const Value.absent(),
    this.caption = const Value.absent(),
    this.mediaImageUrl = const Value.absent(),
    this.mediaWidth = const Value.absent(),
    this.mediaHeight = const Value.absent(),
    this.locationName = const Value.absent(),
    this.likeCount = const Value.absent(),
    this.saveCount = const Value.absent(),
    this.commentCount = const Value.absent(),
    this.viewerHasLiked = const Value.absent(),
    this.viewerHasSaved = const Value.absent(),
    this.commentsDisabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostsCompanion.insert({
    required String id,
    required String authorId,
    this.authorUsername = const Value.absent(),
    this.authorDisplayName = const Value.absent(),
    this.authorAvatarUrl = const Value.absent(),
    required bool authorIsVerified,
    this.caption = const Value.absent(),
    this.mediaImageUrl = const Value.absent(),
    this.mediaWidth = const Value.absent(),
    this.mediaHeight = const Value.absent(),
    this.locationName = const Value.absent(),
    required int likeCount,
    required int saveCount,
    required int commentCount,
    required bool viewerHasLiked,
    required bool viewerHasSaved,
    required bool commentsDisabled,
    required DateTime createdAt,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       authorId = Value(authorId),
       authorIsVerified = Value(authorIsVerified),
       likeCount = Value(likeCount),
       saveCount = Value(saveCount),
       commentCount = Value(commentCount),
       viewerHasLiked = Value(viewerHasLiked),
       viewerHasSaved = Value(viewerHasSaved),
       commentsDisabled = Value(commentsDisabled),
       createdAt = Value(createdAt),
       cachedAt = Value(cachedAt);
  static Insertable<CachedPost> custom({
    Expression<String>? id,
    Expression<String>? authorId,
    Expression<String>? authorUsername,
    Expression<String>? authorDisplayName,
    Expression<String>? authorAvatarUrl,
    Expression<bool>? authorIsVerified,
    Expression<String>? caption,
    Expression<String>? mediaImageUrl,
    Expression<int>? mediaWidth,
    Expression<int>? mediaHeight,
    Expression<String>? locationName,
    Expression<int>? likeCount,
    Expression<int>? saveCount,
    Expression<int>? commentCount,
    Expression<bool>? viewerHasLiked,
    Expression<bool>? viewerHasSaved,
    Expression<bool>? commentsDisabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (authorId != null) 'author_id': authorId,
      if (authorUsername != null) 'author_username': authorUsername,
      if (authorDisplayName != null) 'author_display_name': authorDisplayName,
      if (authorAvatarUrl != null) 'author_avatar_url': authorAvatarUrl,
      if (authorIsVerified != null) 'author_is_verified': authorIsVerified,
      if (caption != null) 'caption': caption,
      if (mediaImageUrl != null) 'media_image_url': mediaImageUrl,
      if (mediaWidth != null) 'media_width': mediaWidth,
      if (mediaHeight != null) 'media_height': mediaHeight,
      if (locationName != null) 'location_name': locationName,
      if (likeCount != null) 'like_count': likeCount,
      if (saveCount != null) 'save_count': saveCount,
      if (commentCount != null) 'comment_count': commentCount,
      if (viewerHasLiked != null) 'viewer_has_liked': viewerHasLiked,
      if (viewerHasSaved != null) 'viewer_has_saved': viewerHasSaved,
      if (commentsDisabled != null) 'comments_disabled': commentsDisabled,
      if (createdAt != null) 'created_at': createdAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostsCompanion copyWith({
    Value<String>? id,
    Value<String>? authorId,
    Value<String?>? authorUsername,
    Value<String?>? authorDisplayName,
    Value<String?>? authorAvatarUrl,
    Value<bool>? authorIsVerified,
    Value<String?>? caption,
    Value<String?>? mediaImageUrl,
    Value<int?>? mediaWidth,
    Value<int?>? mediaHeight,
    Value<String?>? locationName,
    Value<int>? likeCount,
    Value<int>? saveCount,
    Value<int>? commentCount,
    Value<bool>? viewerHasLiked,
    Value<bool>? viewerHasSaved,
    Value<bool>? commentsDisabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return PostsCompanion(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorUsername: authorUsername ?? this.authorUsername,
      authorDisplayName: authorDisplayName ?? this.authorDisplayName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      authorIsVerified: authorIsVerified ?? this.authorIsVerified,
      caption: caption ?? this.caption,
      mediaImageUrl: mediaImageUrl ?? this.mediaImageUrl,
      mediaWidth: mediaWidth ?? this.mediaWidth,
      mediaHeight: mediaHeight ?? this.mediaHeight,
      locationName: locationName ?? this.locationName,
      likeCount: likeCount ?? this.likeCount,
      saveCount: saveCount ?? this.saveCount,
      commentCount: commentCount ?? this.commentCount,
      viewerHasLiked: viewerHasLiked ?? this.viewerHasLiked,
      viewerHasSaved: viewerHasSaved ?? this.viewerHasSaved,
      commentsDisabled: commentsDisabled ?? this.commentsDisabled,
      createdAt: createdAt ?? this.createdAt,
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
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (authorUsername.present) {
      map['author_username'] = Variable<String>(authorUsername.value);
    }
    if (authorDisplayName.present) {
      map['author_display_name'] = Variable<String>(authorDisplayName.value);
    }
    if (authorAvatarUrl.present) {
      map['author_avatar_url'] = Variable<String>(authorAvatarUrl.value);
    }
    if (authorIsVerified.present) {
      map['author_is_verified'] = Variable<bool>(authorIsVerified.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (mediaImageUrl.present) {
      map['media_image_url'] = Variable<String>(mediaImageUrl.value);
    }
    if (mediaWidth.present) {
      map['media_width'] = Variable<int>(mediaWidth.value);
    }
    if (mediaHeight.present) {
      map['media_height'] = Variable<int>(mediaHeight.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (likeCount.present) {
      map['like_count'] = Variable<int>(likeCount.value);
    }
    if (saveCount.present) {
      map['save_count'] = Variable<int>(saveCount.value);
    }
    if (commentCount.present) {
      map['comment_count'] = Variable<int>(commentCount.value);
    }
    if (viewerHasLiked.present) {
      map['viewer_has_liked'] = Variable<bool>(viewerHasLiked.value);
    }
    if (viewerHasSaved.present) {
      map['viewer_has_saved'] = Variable<bool>(viewerHasSaved.value);
    }
    if (commentsDisabled.present) {
      map['comments_disabled'] = Variable<bool>(commentsDisabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('PostsCompanion(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('authorDisplayName: $authorDisplayName, ')
          ..write('authorAvatarUrl: $authorAvatarUrl, ')
          ..write('authorIsVerified: $authorIsVerified, ')
          ..write('caption: $caption, ')
          ..write('mediaImageUrl: $mediaImageUrl, ')
          ..write('mediaWidth: $mediaWidth, ')
          ..write('mediaHeight: $mediaHeight, ')
          ..write('locationName: $locationName, ')
          ..write('likeCount: $likeCount, ')
          ..write('saveCount: $saveCount, ')
          ..write('commentCount: $commentCount, ')
          ..write('viewerHasLiked: $viewerHasLiked, ')
          ..write('viewerHasSaved: $viewerHasSaved, ')
          ..write('commentsDisabled: $commentsDisabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StorySeenSegmentsTable extends StorySeenSegments
    with TableInfo<$StorySeenSegmentsTable, SeenSegment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StorySeenSegmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _segmentIdMeta = const VerificationMeta(
    'segmentId',
  );
  @override
  late final GeneratedColumn<String> segmentId = GeneratedColumn<String>(
    'segment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seenAtMeta = const VerificationMeta('seenAt');
  @override
  late final GeneratedColumn<DateTime> seenAt = GeneratedColumn<DateTime>(
    'seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [segmentId, authorId, seenAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'story_seen_segments';
  @override
  VerificationContext validateIntegrity(
    Insertable<SeenSegment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('segment_id')) {
      context.handle(
        _segmentIdMeta,
        segmentId.isAcceptableOrUnknown(data['segment_id']!, _segmentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_segmentIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('seen_at')) {
      context.handle(
        _seenAtMeta,
        seenAt.isAcceptableOrUnknown(data['seen_at']!, _seenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_seenAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {segmentId};
  @override
  SeenSegment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeenSegment(
      segmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}segment_id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      seenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}seen_at'],
      )!,
    );
  }

  @override
  $StorySeenSegmentsTable createAlias(String alias) {
    return $StorySeenSegmentsTable(attachedDatabase, alias);
  }
}

class SeenSegment extends DataClass implements Insertable<SeenSegment> {
  final String segmentId;
  final String authorId;
  final DateTime seenAt;
  const SeenSegment({
    required this.segmentId,
    required this.authorId,
    required this.seenAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['segment_id'] = Variable<String>(segmentId);
    map['author_id'] = Variable<String>(authorId);
    map['seen_at'] = Variable<DateTime>(seenAt);
    return map;
  }

  StorySeenSegmentsCompanion toCompanion(bool nullToAbsent) {
    return StorySeenSegmentsCompanion(
      segmentId: Value(segmentId),
      authorId: Value(authorId),
      seenAt: Value(seenAt),
    );
  }

  factory SeenSegment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeenSegment(
      segmentId: serializer.fromJson<String>(json['segmentId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      seenAt: serializer.fromJson<DateTime>(json['seenAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'segmentId': serializer.toJson<String>(segmentId),
      'authorId': serializer.toJson<String>(authorId),
      'seenAt': serializer.toJson<DateTime>(seenAt),
    };
  }

  SeenSegment copyWith({
    String? segmentId,
    String? authorId,
    DateTime? seenAt,
  }) => SeenSegment(
    segmentId: segmentId ?? this.segmentId,
    authorId: authorId ?? this.authorId,
    seenAt: seenAt ?? this.seenAt,
  );
  SeenSegment copyWithCompanion(StorySeenSegmentsCompanion data) {
    return SeenSegment(
      segmentId: data.segmentId.present ? data.segmentId.value : this.segmentId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      seenAt: data.seenAt.present ? data.seenAt.value : this.seenAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeenSegment(')
          ..write('segmentId: $segmentId, ')
          ..write('authorId: $authorId, ')
          ..write('seenAt: $seenAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(segmentId, authorId, seenAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeenSegment &&
          other.segmentId == this.segmentId &&
          other.authorId == this.authorId &&
          other.seenAt == this.seenAt);
}

class StorySeenSegmentsCompanion extends UpdateCompanion<SeenSegment> {
  final Value<String> segmentId;
  final Value<String> authorId;
  final Value<DateTime> seenAt;
  final Value<int> rowid;
  const StorySeenSegmentsCompanion({
    this.segmentId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.seenAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StorySeenSegmentsCompanion.insert({
    required String segmentId,
    required String authorId,
    required DateTime seenAt,
    this.rowid = const Value.absent(),
  }) : segmentId = Value(segmentId),
       authorId = Value(authorId),
       seenAt = Value(seenAt);
  static Insertable<SeenSegment> custom({
    Expression<String>? segmentId,
    Expression<String>? authorId,
    Expression<DateTime>? seenAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (segmentId != null) 'segment_id': segmentId,
      if (authorId != null) 'author_id': authorId,
      if (seenAt != null) 'seen_at': seenAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StorySeenSegmentsCompanion copyWith({
    Value<String>? segmentId,
    Value<String>? authorId,
    Value<DateTime>? seenAt,
    Value<int>? rowid,
  }) {
    return StorySeenSegmentsCompanion(
      segmentId: segmentId ?? this.segmentId,
      authorId: authorId ?? this.authorId,
      seenAt: seenAt ?? this.seenAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (segmentId.present) {
      map['segment_id'] = Variable<String>(segmentId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (seenAt.present) {
      map['seen_at'] = Variable<DateTime>(seenAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StorySeenSegmentsCompanion(')
          ..write('segmentId: $segmentId, ')
          ..write('authorId: $authorId, ')
          ..write('seenAt: $seenAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ComposeDraftsTable extends ComposeDrafts
    with TableInfo<$ComposeDraftsTable, ComposeDraftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComposeDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
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
    id,
    idempotencyKey,
    payload,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'compose_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ComposeDraftRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ComposeDraftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComposeDraftRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ComposeDraftsTable createAlias(String alias) {
    return $ComposeDraftsTable(attachedDatabase, alias);
  }
}

class ComposeDraftRow extends DataClass implements Insertable<ComposeDraftRow> {
  final String id;
  final String idempotencyKey;
  final String payload;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ComposeDraftRow({
    required this.id,
    required this.idempotencyKey,
    required this.payload,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ComposeDraftsCompanion toCompanion(bool nullToAbsent) {
    return ComposeDraftsCompanion(
      id: Value(id),
      idempotencyKey: Value(idempotencyKey),
      payload: Value(payload),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ComposeDraftRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComposeDraftRow(
      id: serializer.fromJson<String>(json['id']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ComposeDraftRow copyWith({
    String? id,
    String? idempotencyKey,
    String? payload,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ComposeDraftRow(
    id: id ?? this.id,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ComposeDraftRow copyWithCompanion(ComposeDraftsCompanion data) {
    return ComposeDraftRow(
      id: data.id.present ? data.id.value : this.id,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ComposeDraftRow(')
          ..write('id: $id, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, idempotencyKey, payload, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComposeDraftRow &&
          other.id == this.id &&
          other.idempotencyKey == this.idempotencyKey &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ComposeDraftsCompanion extends UpdateCompanion<ComposeDraftRow> {
  final Value<String> id;
  final Value<String> idempotencyKey;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ComposeDraftsCompanion({
    this.id = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ComposeDraftsCompanion.insert({
    required String id,
    required String idempotencyKey,
    required String payload,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idempotencyKey = Value(idempotencyKey),
       payload = Value(payload),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ComposeDraftRow> custom({
    Expression<String>? id,
    Expression<String>? idempotencyKey,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ComposeDraftsCompanion copyWith({
    Value<String>? id,
    Value<String>? idempotencyKey,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ComposeDraftsCompanion(
      id: id ?? this.id,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('ComposeDraftsCompanion(')
          ..write('id: $id, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReelsTable extends Reels with TableInfo<$ReelsTable, CachedReel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorUsernameMeta = const VerificationMeta(
    'authorUsername',
  );
  @override
  late final GeneratedColumn<String> authorUsername = GeneratedColumn<String>(
    'author_username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorDisplayNameMeta = const VerificationMeta(
    'authorDisplayName',
  );
  @override
  late final GeneratedColumn<String> authorDisplayName =
      GeneratedColumn<String>(
        'author_display_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _authorAvatarUrlMeta = const VerificationMeta(
    'authorAvatarUrl',
  );
  @override
  late final GeneratedColumn<String> authorAvatarUrl = GeneratedColumn<String>(
    'author_avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorIsVerifiedMeta = const VerificationMeta(
    'authorIsVerified',
  );
  @override
  late final GeneratedColumn<bool> authorIsVerified = GeneratedColumn<bool>(
    'author_is_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("author_is_verified" IN (0, 1))',
    ),
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _videoUrlMeta = const VerificationMeta(
    'videoUrl',
  );
  @override
  late final GeneratedColumn<String> videoUrl = GeneratedColumn<String>(
    'video_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _posterUrlMeta = const VerificationMeta(
    'posterUrl',
  );
  @override
  late final GeneratedColumn<String> posterUrl = GeneratedColumn<String>(
    'poster_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _videoWidthMeta = const VerificationMeta(
    'videoWidth',
  );
  @override
  late final GeneratedColumn<int> videoWidth = GeneratedColumn<int>(
    'video_width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _videoHeightMeta = const VerificationMeta(
    'videoHeight',
  );
  @override
  late final GeneratedColumn<int> videoHeight = GeneratedColumn<int>(
    'video_height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _videoDurationMsMeta = const VerificationMeta(
    'videoDurationMs',
  );
  @override
  late final GeneratedColumn<int> videoDurationMs = GeneratedColumn<int>(
    'video_duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isVideoReadyMeta = const VerificationMeta(
    'isVideoReady',
  );
  @override
  late final GeneratedColumn<bool> isVideoReady = GeneratedColumn<bool>(
    'is_video_ready',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_video_ready" IN (0, 1))',
    ),
  );
  static const VerificationMeta _locationNameMeta = const VerificationMeta(
    'locationName',
  );
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
    'location_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _likeCountMeta = const VerificationMeta(
    'likeCount',
  );
  @override
  late final GeneratedColumn<int> likeCount = GeneratedColumn<int>(
    'like_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saveCountMeta = const VerificationMeta(
    'saveCount',
  );
  @override
  late final GeneratedColumn<int> saveCount = GeneratedColumn<int>(
    'save_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commentCountMeta = const VerificationMeta(
    'commentCount',
  );
  @override
  late final GeneratedColumn<int> commentCount = GeneratedColumn<int>(
    'comment_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _viewerHasLikedMeta = const VerificationMeta(
    'viewerHasLiked',
  );
  @override
  late final GeneratedColumn<bool> viewerHasLiked = GeneratedColumn<bool>(
    'viewer_has_liked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("viewer_has_liked" IN (0, 1))',
    ),
  );
  static const VerificationMeta _viewerHasSavedMeta = const VerificationMeta(
    'viewerHasSaved',
  );
  @override
  late final GeneratedColumn<bool> viewerHasSaved = GeneratedColumn<bool>(
    'viewer_has_saved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("viewer_has_saved" IN (0, 1))',
    ),
  );
  static const VerificationMeta _commentsDisabledMeta = const VerificationMeta(
    'commentsDisabled',
  );
  @override
  late final GeneratedColumn<bool> commentsDisabled = GeneratedColumn<bool>(
    'comments_disabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("comments_disabled" IN (0, 1))',
    ),
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
    authorId,
    authorUsername,
    authorDisplayName,
    authorAvatarUrl,
    authorIsVerified,
    caption,
    videoUrl,
    posterUrl,
    videoWidth,
    videoHeight,
    videoDurationMs,
    isVideoReady,
    locationName,
    likeCount,
    saveCount,
    commentCount,
    viewerHasLiked,
    viewerHasSaved,
    commentsDisabled,
    createdAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reels';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedReel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('author_username')) {
      context.handle(
        _authorUsernameMeta,
        authorUsername.isAcceptableOrUnknown(
          data['author_username']!,
          _authorUsernameMeta,
        ),
      );
    }
    if (data.containsKey('author_display_name')) {
      context.handle(
        _authorDisplayNameMeta,
        authorDisplayName.isAcceptableOrUnknown(
          data['author_display_name']!,
          _authorDisplayNameMeta,
        ),
      );
    }
    if (data.containsKey('author_avatar_url')) {
      context.handle(
        _authorAvatarUrlMeta,
        authorAvatarUrl.isAcceptableOrUnknown(
          data['author_avatar_url']!,
          _authorAvatarUrlMeta,
        ),
      );
    }
    if (data.containsKey('author_is_verified')) {
      context.handle(
        _authorIsVerifiedMeta,
        authorIsVerified.isAcceptableOrUnknown(
          data['author_is_verified']!,
          _authorIsVerifiedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorIsVerifiedMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('video_url')) {
      context.handle(
        _videoUrlMeta,
        videoUrl.isAcceptableOrUnknown(data['video_url']!, _videoUrlMeta),
      );
    }
    if (data.containsKey('poster_url')) {
      context.handle(
        _posterUrlMeta,
        posterUrl.isAcceptableOrUnknown(data['poster_url']!, _posterUrlMeta),
      );
    }
    if (data.containsKey('video_width')) {
      context.handle(
        _videoWidthMeta,
        videoWidth.isAcceptableOrUnknown(data['video_width']!, _videoWidthMeta),
      );
    }
    if (data.containsKey('video_height')) {
      context.handle(
        _videoHeightMeta,
        videoHeight.isAcceptableOrUnknown(
          data['video_height']!,
          _videoHeightMeta,
        ),
      );
    }
    if (data.containsKey('video_duration_ms')) {
      context.handle(
        _videoDurationMsMeta,
        videoDurationMs.isAcceptableOrUnknown(
          data['video_duration_ms']!,
          _videoDurationMsMeta,
        ),
      );
    }
    if (data.containsKey('is_video_ready')) {
      context.handle(
        _isVideoReadyMeta,
        isVideoReady.isAcceptableOrUnknown(
          data['is_video_ready']!,
          _isVideoReadyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isVideoReadyMeta);
    }
    if (data.containsKey('location_name')) {
      context.handle(
        _locationNameMeta,
        locationName.isAcceptableOrUnknown(
          data['location_name']!,
          _locationNameMeta,
        ),
      );
    }
    if (data.containsKey('like_count')) {
      context.handle(
        _likeCountMeta,
        likeCount.isAcceptableOrUnknown(data['like_count']!, _likeCountMeta),
      );
    } else if (isInserting) {
      context.missing(_likeCountMeta);
    }
    if (data.containsKey('save_count')) {
      context.handle(
        _saveCountMeta,
        saveCount.isAcceptableOrUnknown(data['save_count']!, _saveCountMeta),
      );
    } else if (isInserting) {
      context.missing(_saveCountMeta);
    }
    if (data.containsKey('comment_count')) {
      context.handle(
        _commentCountMeta,
        commentCount.isAcceptableOrUnknown(
          data['comment_count']!,
          _commentCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_commentCountMeta);
    }
    if (data.containsKey('viewer_has_liked')) {
      context.handle(
        _viewerHasLikedMeta,
        viewerHasLiked.isAcceptableOrUnknown(
          data['viewer_has_liked']!,
          _viewerHasLikedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_viewerHasLikedMeta);
    }
    if (data.containsKey('viewer_has_saved')) {
      context.handle(
        _viewerHasSavedMeta,
        viewerHasSaved.isAcceptableOrUnknown(
          data['viewer_has_saved']!,
          _viewerHasSavedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_viewerHasSavedMeta);
    }
    if (data.containsKey('comments_disabled')) {
      context.handle(
        _commentsDisabledMeta,
        commentsDisabled.isAcceptableOrUnknown(
          data['comments_disabled']!,
          _commentsDisabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_commentsDisabledMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  CachedReel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedReel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      authorUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_username'],
      ),
      authorDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_display_name'],
      ),
      authorAvatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_avatar_url'],
      ),
      authorIsVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}author_is_verified'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      videoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}video_url'],
      ),
      posterUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_url'],
      ),
      videoWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}video_width'],
      ),
      videoHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}video_height'],
      ),
      videoDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}video_duration_ms'],
      ),
      isVideoReady: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_video_ready'],
      )!,
      locationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_name'],
      ),
      likeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}like_count'],
      )!,
      saveCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}save_count'],
      )!,
      commentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}comment_count'],
      )!,
      viewerHasLiked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}viewer_has_liked'],
      )!,
      viewerHasSaved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}viewer_has_saved'],
      )!,
      commentsDisabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}comments_disabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $ReelsTable createAlias(String alias) {
    return $ReelsTable(attachedDatabase, alias);
  }
}

class CachedReel extends DataClass implements Insertable<CachedReel> {
  final String id;
  final String authorId;
  final String? authorUsername;
  final String? authorDisplayName;
  final String? authorAvatarUrl;
  final bool authorIsVerified;
  final String? caption;
  final String? videoUrl;
  final String? posterUrl;
  final int? videoWidth;
  final int? videoHeight;
  final int? videoDurationMs;
  final bool isVideoReady;
  final String? locationName;
  final int likeCount;
  final int saveCount;
  final int commentCount;
  final bool viewerHasLiked;
  final bool viewerHasSaved;
  final bool commentsDisabled;
  final DateTime createdAt;
  final DateTime cachedAt;
  const CachedReel({
    required this.id,
    required this.authorId,
    this.authorUsername,
    this.authorDisplayName,
    this.authorAvatarUrl,
    required this.authorIsVerified,
    this.caption,
    this.videoUrl,
    this.posterUrl,
    this.videoWidth,
    this.videoHeight,
    this.videoDurationMs,
    required this.isVideoReady,
    this.locationName,
    required this.likeCount,
    required this.saveCount,
    required this.commentCount,
    required this.viewerHasLiked,
    required this.viewerHasSaved,
    required this.commentsDisabled,
    required this.createdAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['author_id'] = Variable<String>(authorId);
    if (!nullToAbsent || authorUsername != null) {
      map['author_username'] = Variable<String>(authorUsername);
    }
    if (!nullToAbsent || authorDisplayName != null) {
      map['author_display_name'] = Variable<String>(authorDisplayName);
    }
    if (!nullToAbsent || authorAvatarUrl != null) {
      map['author_avatar_url'] = Variable<String>(authorAvatarUrl);
    }
    map['author_is_verified'] = Variable<bool>(authorIsVerified);
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    if (!nullToAbsent || videoUrl != null) {
      map['video_url'] = Variable<String>(videoUrl);
    }
    if (!nullToAbsent || posterUrl != null) {
      map['poster_url'] = Variable<String>(posterUrl);
    }
    if (!nullToAbsent || videoWidth != null) {
      map['video_width'] = Variable<int>(videoWidth);
    }
    if (!nullToAbsent || videoHeight != null) {
      map['video_height'] = Variable<int>(videoHeight);
    }
    if (!nullToAbsent || videoDurationMs != null) {
      map['video_duration_ms'] = Variable<int>(videoDurationMs);
    }
    map['is_video_ready'] = Variable<bool>(isVideoReady);
    if (!nullToAbsent || locationName != null) {
      map['location_name'] = Variable<String>(locationName);
    }
    map['like_count'] = Variable<int>(likeCount);
    map['save_count'] = Variable<int>(saveCount);
    map['comment_count'] = Variable<int>(commentCount);
    map['viewer_has_liked'] = Variable<bool>(viewerHasLiked);
    map['viewer_has_saved'] = Variable<bool>(viewerHasSaved);
    map['comments_disabled'] = Variable<bool>(commentsDisabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  ReelsCompanion toCompanion(bool nullToAbsent) {
    return ReelsCompanion(
      id: Value(id),
      authorId: Value(authorId),
      authorUsername: authorUsername == null && nullToAbsent
          ? const Value.absent()
          : Value(authorUsername),
      authorDisplayName: authorDisplayName == null && nullToAbsent
          ? const Value.absent()
          : Value(authorDisplayName),
      authorAvatarUrl: authorAvatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(authorAvatarUrl),
      authorIsVerified: Value(authorIsVerified),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      videoUrl: videoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(videoUrl),
      posterUrl: posterUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(posterUrl),
      videoWidth: videoWidth == null && nullToAbsent
          ? const Value.absent()
          : Value(videoWidth),
      videoHeight: videoHeight == null && nullToAbsent
          ? const Value.absent()
          : Value(videoHeight),
      videoDurationMs: videoDurationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(videoDurationMs),
      isVideoReady: Value(isVideoReady),
      locationName: locationName == null && nullToAbsent
          ? const Value.absent()
          : Value(locationName),
      likeCount: Value(likeCount),
      saveCount: Value(saveCount),
      commentCount: Value(commentCount),
      viewerHasLiked: Value(viewerHasLiked),
      viewerHasSaved: Value(viewerHasSaved),
      commentsDisabled: Value(commentsDisabled),
      createdAt: Value(createdAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedReel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedReel(
      id: serializer.fromJson<String>(json['id']),
      authorId: serializer.fromJson<String>(json['authorId']),
      authorUsername: serializer.fromJson<String?>(json['authorUsername']),
      authorDisplayName: serializer.fromJson<String?>(
        json['authorDisplayName'],
      ),
      authorAvatarUrl: serializer.fromJson<String?>(json['authorAvatarUrl']),
      authorIsVerified: serializer.fromJson<bool>(json['authorIsVerified']),
      caption: serializer.fromJson<String?>(json['caption']),
      videoUrl: serializer.fromJson<String?>(json['videoUrl']),
      posterUrl: serializer.fromJson<String?>(json['posterUrl']),
      videoWidth: serializer.fromJson<int?>(json['videoWidth']),
      videoHeight: serializer.fromJson<int?>(json['videoHeight']),
      videoDurationMs: serializer.fromJson<int?>(json['videoDurationMs']),
      isVideoReady: serializer.fromJson<bool>(json['isVideoReady']),
      locationName: serializer.fromJson<String?>(json['locationName']),
      likeCount: serializer.fromJson<int>(json['likeCount']),
      saveCount: serializer.fromJson<int>(json['saveCount']),
      commentCount: serializer.fromJson<int>(json['commentCount']),
      viewerHasLiked: serializer.fromJson<bool>(json['viewerHasLiked']),
      viewerHasSaved: serializer.fromJson<bool>(json['viewerHasSaved']),
      commentsDisabled: serializer.fromJson<bool>(json['commentsDisabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'authorId': serializer.toJson<String>(authorId),
      'authorUsername': serializer.toJson<String?>(authorUsername),
      'authorDisplayName': serializer.toJson<String?>(authorDisplayName),
      'authorAvatarUrl': serializer.toJson<String?>(authorAvatarUrl),
      'authorIsVerified': serializer.toJson<bool>(authorIsVerified),
      'caption': serializer.toJson<String?>(caption),
      'videoUrl': serializer.toJson<String?>(videoUrl),
      'posterUrl': serializer.toJson<String?>(posterUrl),
      'videoWidth': serializer.toJson<int?>(videoWidth),
      'videoHeight': serializer.toJson<int?>(videoHeight),
      'videoDurationMs': serializer.toJson<int?>(videoDurationMs),
      'isVideoReady': serializer.toJson<bool>(isVideoReady),
      'locationName': serializer.toJson<String?>(locationName),
      'likeCount': serializer.toJson<int>(likeCount),
      'saveCount': serializer.toJson<int>(saveCount),
      'commentCount': serializer.toJson<int>(commentCount),
      'viewerHasLiked': serializer.toJson<bool>(viewerHasLiked),
      'viewerHasSaved': serializer.toJson<bool>(viewerHasSaved),
      'commentsDisabled': serializer.toJson<bool>(commentsDisabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedReel copyWith({
    String? id,
    String? authorId,
    Value<String?> authorUsername = const Value.absent(),
    Value<String?> authorDisplayName = const Value.absent(),
    Value<String?> authorAvatarUrl = const Value.absent(),
    bool? authorIsVerified,
    Value<String?> caption = const Value.absent(),
    Value<String?> videoUrl = const Value.absent(),
    Value<String?> posterUrl = const Value.absent(),
    Value<int?> videoWidth = const Value.absent(),
    Value<int?> videoHeight = const Value.absent(),
    Value<int?> videoDurationMs = const Value.absent(),
    bool? isVideoReady,
    Value<String?> locationName = const Value.absent(),
    int? likeCount,
    int? saveCount,
    int? commentCount,
    bool? viewerHasLiked,
    bool? viewerHasSaved,
    bool? commentsDisabled,
    DateTime? createdAt,
    DateTime? cachedAt,
  }) => CachedReel(
    id: id ?? this.id,
    authorId: authorId ?? this.authorId,
    authorUsername: authorUsername.present
        ? authorUsername.value
        : this.authorUsername,
    authorDisplayName: authorDisplayName.present
        ? authorDisplayName.value
        : this.authorDisplayName,
    authorAvatarUrl: authorAvatarUrl.present
        ? authorAvatarUrl.value
        : this.authorAvatarUrl,
    authorIsVerified: authorIsVerified ?? this.authorIsVerified,
    caption: caption.present ? caption.value : this.caption,
    videoUrl: videoUrl.present ? videoUrl.value : this.videoUrl,
    posterUrl: posterUrl.present ? posterUrl.value : this.posterUrl,
    videoWidth: videoWidth.present ? videoWidth.value : this.videoWidth,
    videoHeight: videoHeight.present ? videoHeight.value : this.videoHeight,
    videoDurationMs: videoDurationMs.present
        ? videoDurationMs.value
        : this.videoDurationMs,
    isVideoReady: isVideoReady ?? this.isVideoReady,
    locationName: locationName.present ? locationName.value : this.locationName,
    likeCount: likeCount ?? this.likeCount,
    saveCount: saveCount ?? this.saveCount,
    commentCount: commentCount ?? this.commentCount,
    viewerHasLiked: viewerHasLiked ?? this.viewerHasLiked,
    viewerHasSaved: viewerHasSaved ?? this.viewerHasSaved,
    commentsDisabled: commentsDisabled ?? this.commentsDisabled,
    createdAt: createdAt ?? this.createdAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedReel copyWithCompanion(ReelsCompanion data) {
    return CachedReel(
      id: data.id.present ? data.id.value : this.id,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      authorUsername: data.authorUsername.present
          ? data.authorUsername.value
          : this.authorUsername,
      authorDisplayName: data.authorDisplayName.present
          ? data.authorDisplayName.value
          : this.authorDisplayName,
      authorAvatarUrl: data.authorAvatarUrl.present
          ? data.authorAvatarUrl.value
          : this.authorAvatarUrl,
      authorIsVerified: data.authorIsVerified.present
          ? data.authorIsVerified.value
          : this.authorIsVerified,
      caption: data.caption.present ? data.caption.value : this.caption,
      videoUrl: data.videoUrl.present ? data.videoUrl.value : this.videoUrl,
      posterUrl: data.posterUrl.present ? data.posterUrl.value : this.posterUrl,
      videoWidth: data.videoWidth.present
          ? data.videoWidth.value
          : this.videoWidth,
      videoHeight: data.videoHeight.present
          ? data.videoHeight.value
          : this.videoHeight,
      videoDurationMs: data.videoDurationMs.present
          ? data.videoDurationMs.value
          : this.videoDurationMs,
      isVideoReady: data.isVideoReady.present
          ? data.isVideoReady.value
          : this.isVideoReady,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
      likeCount: data.likeCount.present ? data.likeCount.value : this.likeCount,
      saveCount: data.saveCount.present ? data.saveCount.value : this.saveCount,
      commentCount: data.commentCount.present
          ? data.commentCount.value
          : this.commentCount,
      viewerHasLiked: data.viewerHasLiked.present
          ? data.viewerHasLiked.value
          : this.viewerHasLiked,
      viewerHasSaved: data.viewerHasSaved.present
          ? data.viewerHasSaved.value
          : this.viewerHasSaved,
      commentsDisabled: data.commentsDisabled.present
          ? data.commentsDisabled.value
          : this.commentsDisabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedReel(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('authorDisplayName: $authorDisplayName, ')
          ..write('authorAvatarUrl: $authorAvatarUrl, ')
          ..write('authorIsVerified: $authorIsVerified, ')
          ..write('caption: $caption, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('posterUrl: $posterUrl, ')
          ..write('videoWidth: $videoWidth, ')
          ..write('videoHeight: $videoHeight, ')
          ..write('videoDurationMs: $videoDurationMs, ')
          ..write('isVideoReady: $isVideoReady, ')
          ..write('locationName: $locationName, ')
          ..write('likeCount: $likeCount, ')
          ..write('saveCount: $saveCount, ')
          ..write('commentCount: $commentCount, ')
          ..write('viewerHasLiked: $viewerHasLiked, ')
          ..write('viewerHasSaved: $viewerHasSaved, ')
          ..write('commentsDisabled: $commentsDisabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    authorId,
    authorUsername,
    authorDisplayName,
    authorAvatarUrl,
    authorIsVerified,
    caption,
    videoUrl,
    posterUrl,
    videoWidth,
    videoHeight,
    videoDurationMs,
    isVideoReady,
    locationName,
    likeCount,
    saveCount,
    commentCount,
    viewerHasLiked,
    viewerHasSaved,
    commentsDisabled,
    createdAt,
    cachedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedReel &&
          other.id == this.id &&
          other.authorId == this.authorId &&
          other.authorUsername == this.authorUsername &&
          other.authorDisplayName == this.authorDisplayName &&
          other.authorAvatarUrl == this.authorAvatarUrl &&
          other.authorIsVerified == this.authorIsVerified &&
          other.caption == this.caption &&
          other.videoUrl == this.videoUrl &&
          other.posterUrl == this.posterUrl &&
          other.videoWidth == this.videoWidth &&
          other.videoHeight == this.videoHeight &&
          other.videoDurationMs == this.videoDurationMs &&
          other.isVideoReady == this.isVideoReady &&
          other.locationName == this.locationName &&
          other.likeCount == this.likeCount &&
          other.saveCount == this.saveCount &&
          other.commentCount == this.commentCount &&
          other.viewerHasLiked == this.viewerHasLiked &&
          other.viewerHasSaved == this.viewerHasSaved &&
          other.commentsDisabled == this.commentsDisabled &&
          other.createdAt == this.createdAt &&
          other.cachedAt == this.cachedAt);
}

class ReelsCompanion extends UpdateCompanion<CachedReel> {
  final Value<String> id;
  final Value<String> authorId;
  final Value<String?> authorUsername;
  final Value<String?> authorDisplayName;
  final Value<String?> authorAvatarUrl;
  final Value<bool> authorIsVerified;
  final Value<String?> caption;
  final Value<String?> videoUrl;
  final Value<String?> posterUrl;
  final Value<int?> videoWidth;
  final Value<int?> videoHeight;
  final Value<int?> videoDurationMs;
  final Value<bool> isVideoReady;
  final Value<String?> locationName;
  final Value<int> likeCount;
  final Value<int> saveCount;
  final Value<int> commentCount;
  final Value<bool> viewerHasLiked;
  final Value<bool> viewerHasSaved;
  final Value<bool> commentsDisabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const ReelsCompanion({
    this.id = const Value.absent(),
    this.authorId = const Value.absent(),
    this.authorUsername = const Value.absent(),
    this.authorDisplayName = const Value.absent(),
    this.authorAvatarUrl = const Value.absent(),
    this.authorIsVerified = const Value.absent(),
    this.caption = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.posterUrl = const Value.absent(),
    this.videoWidth = const Value.absent(),
    this.videoHeight = const Value.absent(),
    this.videoDurationMs = const Value.absent(),
    this.isVideoReady = const Value.absent(),
    this.locationName = const Value.absent(),
    this.likeCount = const Value.absent(),
    this.saveCount = const Value.absent(),
    this.commentCount = const Value.absent(),
    this.viewerHasLiked = const Value.absent(),
    this.viewerHasSaved = const Value.absent(),
    this.commentsDisabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReelsCompanion.insert({
    required String id,
    required String authorId,
    this.authorUsername = const Value.absent(),
    this.authorDisplayName = const Value.absent(),
    this.authorAvatarUrl = const Value.absent(),
    required bool authorIsVerified,
    this.caption = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.posterUrl = const Value.absent(),
    this.videoWidth = const Value.absent(),
    this.videoHeight = const Value.absent(),
    this.videoDurationMs = const Value.absent(),
    required bool isVideoReady,
    this.locationName = const Value.absent(),
    required int likeCount,
    required int saveCount,
    required int commentCount,
    required bool viewerHasLiked,
    required bool viewerHasSaved,
    required bool commentsDisabled,
    required DateTime createdAt,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       authorId = Value(authorId),
       authorIsVerified = Value(authorIsVerified),
       isVideoReady = Value(isVideoReady),
       likeCount = Value(likeCount),
       saveCount = Value(saveCount),
       commentCount = Value(commentCount),
       viewerHasLiked = Value(viewerHasLiked),
       viewerHasSaved = Value(viewerHasSaved),
       commentsDisabled = Value(commentsDisabled),
       createdAt = Value(createdAt),
       cachedAt = Value(cachedAt);
  static Insertable<CachedReel> custom({
    Expression<String>? id,
    Expression<String>? authorId,
    Expression<String>? authorUsername,
    Expression<String>? authorDisplayName,
    Expression<String>? authorAvatarUrl,
    Expression<bool>? authorIsVerified,
    Expression<String>? caption,
    Expression<String>? videoUrl,
    Expression<String>? posterUrl,
    Expression<int>? videoWidth,
    Expression<int>? videoHeight,
    Expression<int>? videoDurationMs,
    Expression<bool>? isVideoReady,
    Expression<String>? locationName,
    Expression<int>? likeCount,
    Expression<int>? saveCount,
    Expression<int>? commentCount,
    Expression<bool>? viewerHasLiked,
    Expression<bool>? viewerHasSaved,
    Expression<bool>? commentsDisabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (authorId != null) 'author_id': authorId,
      if (authorUsername != null) 'author_username': authorUsername,
      if (authorDisplayName != null) 'author_display_name': authorDisplayName,
      if (authorAvatarUrl != null) 'author_avatar_url': authorAvatarUrl,
      if (authorIsVerified != null) 'author_is_verified': authorIsVerified,
      if (caption != null) 'caption': caption,
      if (videoUrl != null) 'video_url': videoUrl,
      if (posterUrl != null) 'poster_url': posterUrl,
      if (videoWidth != null) 'video_width': videoWidth,
      if (videoHeight != null) 'video_height': videoHeight,
      if (videoDurationMs != null) 'video_duration_ms': videoDurationMs,
      if (isVideoReady != null) 'is_video_ready': isVideoReady,
      if (locationName != null) 'location_name': locationName,
      if (likeCount != null) 'like_count': likeCount,
      if (saveCount != null) 'save_count': saveCount,
      if (commentCount != null) 'comment_count': commentCount,
      if (viewerHasLiked != null) 'viewer_has_liked': viewerHasLiked,
      if (viewerHasSaved != null) 'viewer_has_saved': viewerHasSaved,
      if (commentsDisabled != null) 'comments_disabled': commentsDisabled,
      if (createdAt != null) 'created_at': createdAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReelsCompanion copyWith({
    Value<String>? id,
    Value<String>? authorId,
    Value<String?>? authorUsername,
    Value<String?>? authorDisplayName,
    Value<String?>? authorAvatarUrl,
    Value<bool>? authorIsVerified,
    Value<String?>? caption,
    Value<String?>? videoUrl,
    Value<String?>? posterUrl,
    Value<int?>? videoWidth,
    Value<int?>? videoHeight,
    Value<int?>? videoDurationMs,
    Value<bool>? isVideoReady,
    Value<String?>? locationName,
    Value<int>? likeCount,
    Value<int>? saveCount,
    Value<int>? commentCount,
    Value<bool>? viewerHasLiked,
    Value<bool>? viewerHasSaved,
    Value<bool>? commentsDisabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return ReelsCompanion(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorUsername: authorUsername ?? this.authorUsername,
      authorDisplayName: authorDisplayName ?? this.authorDisplayName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      authorIsVerified: authorIsVerified ?? this.authorIsVerified,
      caption: caption ?? this.caption,
      videoUrl: videoUrl ?? this.videoUrl,
      posterUrl: posterUrl ?? this.posterUrl,
      videoWidth: videoWidth ?? this.videoWidth,
      videoHeight: videoHeight ?? this.videoHeight,
      videoDurationMs: videoDurationMs ?? this.videoDurationMs,
      isVideoReady: isVideoReady ?? this.isVideoReady,
      locationName: locationName ?? this.locationName,
      likeCount: likeCount ?? this.likeCount,
      saveCount: saveCount ?? this.saveCount,
      commentCount: commentCount ?? this.commentCount,
      viewerHasLiked: viewerHasLiked ?? this.viewerHasLiked,
      viewerHasSaved: viewerHasSaved ?? this.viewerHasSaved,
      commentsDisabled: commentsDisabled ?? this.commentsDisabled,
      createdAt: createdAt ?? this.createdAt,
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
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (authorUsername.present) {
      map['author_username'] = Variable<String>(authorUsername.value);
    }
    if (authorDisplayName.present) {
      map['author_display_name'] = Variable<String>(authorDisplayName.value);
    }
    if (authorAvatarUrl.present) {
      map['author_avatar_url'] = Variable<String>(authorAvatarUrl.value);
    }
    if (authorIsVerified.present) {
      map['author_is_verified'] = Variable<bool>(authorIsVerified.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (videoUrl.present) {
      map['video_url'] = Variable<String>(videoUrl.value);
    }
    if (posterUrl.present) {
      map['poster_url'] = Variable<String>(posterUrl.value);
    }
    if (videoWidth.present) {
      map['video_width'] = Variable<int>(videoWidth.value);
    }
    if (videoHeight.present) {
      map['video_height'] = Variable<int>(videoHeight.value);
    }
    if (videoDurationMs.present) {
      map['video_duration_ms'] = Variable<int>(videoDurationMs.value);
    }
    if (isVideoReady.present) {
      map['is_video_ready'] = Variable<bool>(isVideoReady.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (likeCount.present) {
      map['like_count'] = Variable<int>(likeCount.value);
    }
    if (saveCount.present) {
      map['save_count'] = Variable<int>(saveCount.value);
    }
    if (commentCount.present) {
      map['comment_count'] = Variable<int>(commentCount.value);
    }
    if (viewerHasLiked.present) {
      map['viewer_has_liked'] = Variable<bool>(viewerHasLiked.value);
    }
    if (viewerHasSaved.present) {
      map['viewer_has_saved'] = Variable<bool>(viewerHasSaved.value);
    }
    if (commentsDisabled.present) {
      map['comments_disabled'] = Variable<bool>(commentsDisabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('ReelsCompanion(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('authorDisplayName: $authorDisplayName, ')
          ..write('authorAvatarUrl: $authorAvatarUrl, ')
          ..write('authorIsVerified: $authorIsVerified, ')
          ..write('caption: $caption, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('posterUrl: $posterUrl, ')
          ..write('videoWidth: $videoWidth, ')
          ..write('videoHeight: $videoHeight, ')
          ..write('videoDurationMs: $videoDurationMs, ')
          ..write('isVideoReady: $isVideoReady, ')
          ..write('locationName: $locationName, ')
          ..write('likeCount: $likeCount, ')
          ..write('saveCount: $saveCount, ')
          ..write('commentCount: $commentCount, ')
          ..write('viewerHasLiked: $viewerHasLiked, ')
          ..write('viewerHasSaved: $viewerHasSaved, ')
          ..write('commentsDisabled: $commentsDisabled, ')
          ..write('createdAt: $createdAt, ')
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
  late final $MeProfilesTable meProfiles = $MeProfilesTable(this);
  late final $PostsTable posts = $PostsTable(this);
  late final $StorySeenSegmentsTable storySeenSegments =
      $StorySeenSegmentsTable(this);
  late final $ComposeDraftsTable composeDrafts = $ComposeDraftsTable(this);
  late final $ReelsTable reels = $ReelsTable(this);
  late final UsersDao usersDao = UsersDao(this as AppDatabase);
  late final MeProfileDao meProfileDao = MeProfileDao(this as AppDatabase);
  late final PostsDao postsDao = PostsDao(this as AppDatabase);
  late final StorySeenDao storySeenDao = StorySeenDao(this as AppDatabase);
  late final ComposeDraftDao composeDraftDao = ComposeDraftDao(
    this as AppDatabase,
  );
  late final ReelsDao reelsDao = ReelsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    meProfiles,
    posts,
    storySeenSegments,
    composeDrafts,
    reels,
  ];
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
typedef $$MeProfilesTableCreateCompanionBuilder =
    MeProfilesCompanion Function({
      required String id,
      required String email,
      Value<String?> username,
      Value<String?> displayName,
      Value<String?> avatarMediaId,
      Value<String?> bio,
      Value<String?> website,
      Value<String?> pronouns,
      required bool isPrivate,
      required bool isVerified,
      required bool profileCompleted,
      required DateTime createdAt,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$MeProfilesTableUpdateCompanionBuilder =
    MeProfilesCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String?> username,
      Value<String?> displayName,
      Value<String?> avatarMediaId,
      Value<String?> bio,
      Value<String?> website,
      Value<String?> pronouns,
      Value<bool> isPrivate,
      Value<bool> isVerified,
      Value<bool> profileCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$MeProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $MeProfilesTable> {
  $$MeProfilesTableFilterComposer({
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
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

  ColumnFilters<String> get avatarMediaId => $composableBuilder(
    column: $table.avatarMediaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pronouns => $composableBuilder(
    column: $table.pronouns,
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

  ColumnFilters<bool> get profileCompleted => $composableBuilder(
    column: $table.profileCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MeProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $MeProfilesTable> {
  $$MeProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
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

  ColumnOrderings<String> get avatarMediaId => $composableBuilder(
    column: $table.avatarMediaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pronouns => $composableBuilder(
    column: $table.pronouns,
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

  ColumnOrderings<bool> get profileCompleted => $composableBuilder(
    column: $table.profileCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MeProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeProfilesTable> {
  $$MeProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarMediaId => $composableBuilder(
    column: $table.avatarMediaId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get pronouns =>
      $composableBuilder(column: $table.pronouns, builder: (column) => column);

  GeneratedColumn<bool> get isPrivate =>
      $composableBuilder(column: $table.isPrivate, builder: (column) => column);

  GeneratedColumn<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get profileCompleted => $composableBuilder(
    column: $table.profileCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$MeProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeProfilesTable,
          CachedMeProfile,
          $$MeProfilesTableFilterComposer,
          $$MeProfilesTableOrderingComposer,
          $$MeProfilesTableAnnotationComposer,
          $$MeProfilesTableCreateCompanionBuilder,
          $$MeProfilesTableUpdateCompanionBuilder,
          (
            CachedMeProfile,
            BaseReferences<_$AppDatabase, $MeProfilesTable, CachedMeProfile>,
          ),
          CachedMeProfile,
          PrefetchHooks Function()
        > {
  $$MeProfilesTableTableManager(_$AppDatabase db, $MeProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> avatarMediaId = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> pronouns = const Value.absent(),
                Value<bool> isPrivate = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<bool> profileCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeProfilesCompanion(
                id: id,
                email: email,
                username: username,
                displayName: displayName,
                avatarMediaId: avatarMediaId,
                bio: bio,
                website: website,
                pronouns: pronouns,
                isPrivate: isPrivate,
                isVerified: isVerified,
                profileCompleted: profileCompleted,
                createdAt: createdAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                Value<String?> username = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> avatarMediaId = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> pronouns = const Value.absent(),
                required bool isPrivate,
                required bool isVerified,
                required bool profileCompleted,
                required DateTime createdAt,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => MeProfilesCompanion.insert(
                id: id,
                email: email,
                username: username,
                displayName: displayName,
                avatarMediaId: avatarMediaId,
                bio: bio,
                website: website,
                pronouns: pronouns,
                isPrivate: isPrivate,
                isVerified: isVerified,
                profileCompleted: profileCompleted,
                createdAt: createdAt,
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

typedef $$MeProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeProfilesTable,
      CachedMeProfile,
      $$MeProfilesTableFilterComposer,
      $$MeProfilesTableOrderingComposer,
      $$MeProfilesTableAnnotationComposer,
      $$MeProfilesTableCreateCompanionBuilder,
      $$MeProfilesTableUpdateCompanionBuilder,
      (
        CachedMeProfile,
        BaseReferences<_$AppDatabase, $MeProfilesTable, CachedMeProfile>,
      ),
      CachedMeProfile,
      PrefetchHooks Function()
    >;
typedef $$PostsTableCreateCompanionBuilder =
    PostsCompanion Function({
      required String id,
      required String authorId,
      Value<String?> authorUsername,
      Value<String?> authorDisplayName,
      Value<String?> authorAvatarUrl,
      required bool authorIsVerified,
      Value<String?> caption,
      Value<String?> mediaImageUrl,
      Value<int?> mediaWidth,
      Value<int?> mediaHeight,
      Value<String?> locationName,
      required int likeCount,
      required int saveCount,
      required int commentCount,
      required bool viewerHasLiked,
      required bool viewerHasSaved,
      required bool commentsDisabled,
      required DateTime createdAt,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$PostsTableUpdateCompanionBuilder =
    PostsCompanion Function({
      Value<String> id,
      Value<String> authorId,
      Value<String?> authorUsername,
      Value<String?> authorDisplayName,
      Value<String?> authorAvatarUrl,
      Value<bool> authorIsVerified,
      Value<String?> caption,
      Value<String?> mediaImageUrl,
      Value<int?> mediaWidth,
      Value<int?> mediaHeight,
      Value<String?> locationName,
      Value<int> likeCount,
      Value<int> saveCount,
      Value<int> commentCount,
      Value<bool> viewerHasLiked,
      Value<bool> viewerHasSaved,
      Value<bool> commentsDisabled,
      Value<DateTime> createdAt,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$PostsTableFilterComposer extends Composer<_$AppDatabase, $PostsTable> {
  $$PostsTableFilterComposer({
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

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorDisplayName => $composableBuilder(
    column: $table.authorDisplayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorAvatarUrl => $composableBuilder(
    column: $table.authorAvatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get authorIsVerified => $composableBuilder(
    column: $table.authorIsVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaImageUrl => $composableBuilder(
    column: $table.mediaImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mediaWidth => $composableBuilder(
    column: $table.mediaWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mediaHeight => $composableBuilder(
    column: $table.mediaHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get likeCount => $composableBuilder(
    column: $table.likeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get saveCount => $composableBuilder(
    column: $table.saveCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get commentCount => $composableBuilder(
    column: $table.commentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get viewerHasLiked => $composableBuilder(
    column: $table.viewerHasLiked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get viewerHasSaved => $composableBuilder(
    column: $table.viewerHasSaved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get commentsDisabled => $composableBuilder(
    column: $table.commentsDisabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PostsTableOrderingComposer
    extends Composer<_$AppDatabase, $PostsTable> {
  $$PostsTableOrderingComposer({
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

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorDisplayName => $composableBuilder(
    column: $table.authorDisplayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorAvatarUrl => $composableBuilder(
    column: $table.authorAvatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get authorIsVerified => $composableBuilder(
    column: $table.authorIsVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaImageUrl => $composableBuilder(
    column: $table.mediaImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mediaWidth => $composableBuilder(
    column: $table.mediaWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mediaHeight => $composableBuilder(
    column: $table.mediaHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get likeCount => $composableBuilder(
    column: $table.likeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get saveCount => $composableBuilder(
    column: $table.saveCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get commentCount => $composableBuilder(
    column: $table.commentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get viewerHasLiked => $composableBuilder(
    column: $table.viewerHasLiked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get viewerHasSaved => $composableBuilder(
    column: $table.viewerHasSaved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get commentsDisabled => $composableBuilder(
    column: $table.commentsDisabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PostsTable> {
  $$PostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorDisplayName => $composableBuilder(
    column: $table.authorDisplayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorAvatarUrl => $composableBuilder(
    column: $table.authorAvatarUrl,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get authorIsVerified => $composableBuilder(
    column: $table.authorIsVerified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<String> get mediaImageUrl => $composableBuilder(
    column: $table.mediaImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mediaWidth => $composableBuilder(
    column: $table.mediaWidth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mediaHeight => $composableBuilder(
    column: $table.mediaHeight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get likeCount =>
      $composableBuilder(column: $table.likeCount, builder: (column) => column);

  GeneratedColumn<int> get saveCount =>
      $composableBuilder(column: $table.saveCount, builder: (column) => column);

  GeneratedColumn<int> get commentCount => $composableBuilder(
    column: $table.commentCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get viewerHasLiked => $composableBuilder(
    column: $table.viewerHasLiked,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get viewerHasSaved => $composableBuilder(
    column: $table.viewerHasSaved,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get commentsDisabled => $composableBuilder(
    column: $table.commentsDisabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$PostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PostsTable,
          CachedPost,
          $$PostsTableFilterComposer,
          $$PostsTableOrderingComposer,
          $$PostsTableAnnotationComposer,
          $$PostsTableCreateCompanionBuilder,
          $$PostsTableUpdateCompanionBuilder,
          (CachedPost, BaseReferences<_$AppDatabase, $PostsTable, CachedPost>),
          CachedPost,
          PrefetchHooks Function()
        > {
  $$PostsTableTableManager(_$AppDatabase db, $PostsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String?> authorUsername = const Value.absent(),
                Value<String?> authorDisplayName = const Value.absent(),
                Value<String?> authorAvatarUrl = const Value.absent(),
                Value<bool> authorIsVerified = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<String?> mediaImageUrl = const Value.absent(),
                Value<int?> mediaWidth = const Value.absent(),
                Value<int?> mediaHeight = const Value.absent(),
                Value<String?> locationName = const Value.absent(),
                Value<int> likeCount = const Value.absent(),
                Value<int> saveCount = const Value.absent(),
                Value<int> commentCount = const Value.absent(),
                Value<bool> viewerHasLiked = const Value.absent(),
                Value<bool> viewerHasSaved = const Value.absent(),
                Value<bool> commentsDisabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostsCompanion(
                id: id,
                authorId: authorId,
                authorUsername: authorUsername,
                authorDisplayName: authorDisplayName,
                authorAvatarUrl: authorAvatarUrl,
                authorIsVerified: authorIsVerified,
                caption: caption,
                mediaImageUrl: mediaImageUrl,
                mediaWidth: mediaWidth,
                mediaHeight: mediaHeight,
                locationName: locationName,
                likeCount: likeCount,
                saveCount: saveCount,
                commentCount: commentCount,
                viewerHasLiked: viewerHasLiked,
                viewerHasSaved: viewerHasSaved,
                commentsDisabled: commentsDisabled,
                createdAt: createdAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String authorId,
                Value<String?> authorUsername = const Value.absent(),
                Value<String?> authorDisplayName = const Value.absent(),
                Value<String?> authorAvatarUrl = const Value.absent(),
                required bool authorIsVerified,
                Value<String?> caption = const Value.absent(),
                Value<String?> mediaImageUrl = const Value.absent(),
                Value<int?> mediaWidth = const Value.absent(),
                Value<int?> mediaHeight = const Value.absent(),
                Value<String?> locationName = const Value.absent(),
                required int likeCount,
                required int saveCount,
                required int commentCount,
                required bool viewerHasLiked,
                required bool viewerHasSaved,
                required bool commentsDisabled,
                required DateTime createdAt,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => PostsCompanion.insert(
                id: id,
                authorId: authorId,
                authorUsername: authorUsername,
                authorDisplayName: authorDisplayName,
                authorAvatarUrl: authorAvatarUrl,
                authorIsVerified: authorIsVerified,
                caption: caption,
                mediaImageUrl: mediaImageUrl,
                mediaWidth: mediaWidth,
                mediaHeight: mediaHeight,
                locationName: locationName,
                likeCount: likeCount,
                saveCount: saveCount,
                commentCount: commentCount,
                viewerHasLiked: viewerHasLiked,
                viewerHasSaved: viewerHasSaved,
                commentsDisabled: commentsDisabled,
                createdAt: createdAt,
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

typedef $$PostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PostsTable,
      CachedPost,
      $$PostsTableFilterComposer,
      $$PostsTableOrderingComposer,
      $$PostsTableAnnotationComposer,
      $$PostsTableCreateCompanionBuilder,
      $$PostsTableUpdateCompanionBuilder,
      (CachedPost, BaseReferences<_$AppDatabase, $PostsTable, CachedPost>),
      CachedPost,
      PrefetchHooks Function()
    >;
typedef $$StorySeenSegmentsTableCreateCompanionBuilder =
    StorySeenSegmentsCompanion Function({
      required String segmentId,
      required String authorId,
      required DateTime seenAt,
      Value<int> rowid,
    });
typedef $$StorySeenSegmentsTableUpdateCompanionBuilder =
    StorySeenSegmentsCompanion Function({
      Value<String> segmentId,
      Value<String> authorId,
      Value<DateTime> seenAt,
      Value<int> rowid,
    });

class $$StorySeenSegmentsTableFilterComposer
    extends Composer<_$AppDatabase, $StorySeenSegmentsTable> {
  $$StorySeenSegmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get segmentId => $composableBuilder(
    column: $table.segmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get seenAt => $composableBuilder(
    column: $table.seenAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StorySeenSegmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StorySeenSegmentsTable> {
  $$StorySeenSegmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get segmentId => $composableBuilder(
    column: $table.segmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get seenAt => $composableBuilder(
    column: $table.seenAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StorySeenSegmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StorySeenSegmentsTable> {
  $$StorySeenSegmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get segmentId =>
      $composableBuilder(column: $table.segmentId, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<DateTime> get seenAt =>
      $composableBuilder(column: $table.seenAt, builder: (column) => column);
}

class $$StorySeenSegmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StorySeenSegmentsTable,
          SeenSegment,
          $$StorySeenSegmentsTableFilterComposer,
          $$StorySeenSegmentsTableOrderingComposer,
          $$StorySeenSegmentsTableAnnotationComposer,
          $$StorySeenSegmentsTableCreateCompanionBuilder,
          $$StorySeenSegmentsTableUpdateCompanionBuilder,
          (
            SeenSegment,
            BaseReferences<_$AppDatabase, $StorySeenSegmentsTable, SeenSegment>,
          ),
          SeenSegment,
          PrefetchHooks Function()
        > {
  $$StorySeenSegmentsTableTableManager(
    _$AppDatabase db,
    $StorySeenSegmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StorySeenSegmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StorySeenSegmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StorySeenSegmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> segmentId = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<DateTime> seenAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StorySeenSegmentsCompanion(
                segmentId: segmentId,
                authorId: authorId,
                seenAt: seenAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String segmentId,
                required String authorId,
                required DateTime seenAt,
                Value<int> rowid = const Value.absent(),
              }) => StorySeenSegmentsCompanion.insert(
                segmentId: segmentId,
                authorId: authorId,
                seenAt: seenAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StorySeenSegmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StorySeenSegmentsTable,
      SeenSegment,
      $$StorySeenSegmentsTableFilterComposer,
      $$StorySeenSegmentsTableOrderingComposer,
      $$StorySeenSegmentsTableAnnotationComposer,
      $$StorySeenSegmentsTableCreateCompanionBuilder,
      $$StorySeenSegmentsTableUpdateCompanionBuilder,
      (
        SeenSegment,
        BaseReferences<_$AppDatabase, $StorySeenSegmentsTable, SeenSegment>,
      ),
      SeenSegment,
      PrefetchHooks Function()
    >;
typedef $$ComposeDraftsTableCreateCompanionBuilder =
    ComposeDraftsCompanion Function({
      required String id,
      required String idempotencyKey,
      required String payload,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ComposeDraftsTableUpdateCompanionBuilder =
    ComposeDraftsCompanion Function({
      Value<String> id,
      Value<String> idempotencyKey,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ComposeDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $ComposeDraftsTable> {
  $$ComposeDraftsTableFilterComposer({
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

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ComposeDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ComposeDraftsTable> {
  $$ComposeDraftsTableOrderingComposer({
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

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ComposeDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComposeDraftsTable> {
  $$ComposeDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ComposeDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComposeDraftsTable,
          ComposeDraftRow,
          $$ComposeDraftsTableFilterComposer,
          $$ComposeDraftsTableOrderingComposer,
          $$ComposeDraftsTableAnnotationComposer,
          $$ComposeDraftsTableCreateCompanionBuilder,
          $$ComposeDraftsTableUpdateCompanionBuilder,
          (
            ComposeDraftRow,
            BaseReferences<_$AppDatabase, $ComposeDraftsTable, ComposeDraftRow>,
          ),
          ComposeDraftRow,
          PrefetchHooks Function()
        > {
  $$ComposeDraftsTableTableManager(_$AppDatabase db, $ComposeDraftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComposeDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComposeDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComposeDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComposeDraftsCompanion(
                id: id,
                idempotencyKey: idempotencyKey,
                payload: payload,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String idempotencyKey,
                required String payload,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ComposeDraftsCompanion.insert(
                id: id,
                idempotencyKey: idempotencyKey,
                payload: payload,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ComposeDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComposeDraftsTable,
      ComposeDraftRow,
      $$ComposeDraftsTableFilterComposer,
      $$ComposeDraftsTableOrderingComposer,
      $$ComposeDraftsTableAnnotationComposer,
      $$ComposeDraftsTableCreateCompanionBuilder,
      $$ComposeDraftsTableUpdateCompanionBuilder,
      (
        ComposeDraftRow,
        BaseReferences<_$AppDatabase, $ComposeDraftsTable, ComposeDraftRow>,
      ),
      ComposeDraftRow,
      PrefetchHooks Function()
    >;
typedef $$ReelsTableCreateCompanionBuilder =
    ReelsCompanion Function({
      required String id,
      required String authorId,
      Value<String?> authorUsername,
      Value<String?> authorDisplayName,
      Value<String?> authorAvatarUrl,
      required bool authorIsVerified,
      Value<String?> caption,
      Value<String?> videoUrl,
      Value<String?> posterUrl,
      Value<int?> videoWidth,
      Value<int?> videoHeight,
      Value<int?> videoDurationMs,
      required bool isVideoReady,
      Value<String?> locationName,
      required int likeCount,
      required int saveCount,
      required int commentCount,
      required bool viewerHasLiked,
      required bool viewerHasSaved,
      required bool commentsDisabled,
      required DateTime createdAt,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$ReelsTableUpdateCompanionBuilder =
    ReelsCompanion Function({
      Value<String> id,
      Value<String> authorId,
      Value<String?> authorUsername,
      Value<String?> authorDisplayName,
      Value<String?> authorAvatarUrl,
      Value<bool> authorIsVerified,
      Value<String?> caption,
      Value<String?> videoUrl,
      Value<String?> posterUrl,
      Value<int?> videoWidth,
      Value<int?> videoHeight,
      Value<int?> videoDurationMs,
      Value<bool> isVideoReady,
      Value<String?> locationName,
      Value<int> likeCount,
      Value<int> saveCount,
      Value<int> commentCount,
      Value<bool> viewerHasLiked,
      Value<bool> viewerHasSaved,
      Value<bool> commentsDisabled,
      Value<DateTime> createdAt,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$ReelsTableFilterComposer extends Composer<_$AppDatabase, $ReelsTable> {
  $$ReelsTableFilterComposer({
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

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorDisplayName => $composableBuilder(
    column: $table.authorDisplayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorAvatarUrl => $composableBuilder(
    column: $table.authorAvatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get authorIsVerified => $composableBuilder(
    column: $table.authorIsVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get videoUrl => $composableBuilder(
    column: $table.videoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterUrl => $composableBuilder(
    column: $table.posterUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get videoWidth => $composableBuilder(
    column: $table.videoWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get videoHeight => $composableBuilder(
    column: $table.videoHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get videoDurationMs => $composableBuilder(
    column: $table.videoDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVideoReady => $composableBuilder(
    column: $table.isVideoReady,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get likeCount => $composableBuilder(
    column: $table.likeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get saveCount => $composableBuilder(
    column: $table.saveCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get commentCount => $composableBuilder(
    column: $table.commentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get viewerHasLiked => $composableBuilder(
    column: $table.viewerHasLiked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get viewerHasSaved => $composableBuilder(
    column: $table.viewerHasSaved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get commentsDisabled => $composableBuilder(
    column: $table.commentsDisabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReelsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReelsTable> {
  $$ReelsTableOrderingComposer({
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

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorDisplayName => $composableBuilder(
    column: $table.authorDisplayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorAvatarUrl => $composableBuilder(
    column: $table.authorAvatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get authorIsVerified => $composableBuilder(
    column: $table.authorIsVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get videoUrl => $composableBuilder(
    column: $table.videoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterUrl => $composableBuilder(
    column: $table.posterUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get videoWidth => $composableBuilder(
    column: $table.videoWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get videoHeight => $composableBuilder(
    column: $table.videoHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get videoDurationMs => $composableBuilder(
    column: $table.videoDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVideoReady => $composableBuilder(
    column: $table.isVideoReady,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get likeCount => $composableBuilder(
    column: $table.likeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get saveCount => $composableBuilder(
    column: $table.saveCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get commentCount => $composableBuilder(
    column: $table.commentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get viewerHasLiked => $composableBuilder(
    column: $table.viewerHasLiked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get viewerHasSaved => $composableBuilder(
    column: $table.viewerHasSaved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get commentsDisabled => $composableBuilder(
    column: $table.commentsDisabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReelsTable> {
  $$ReelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorDisplayName => $composableBuilder(
    column: $table.authorDisplayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorAvatarUrl => $composableBuilder(
    column: $table.authorAvatarUrl,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get authorIsVerified => $composableBuilder(
    column: $table.authorIsVerified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<String> get videoUrl =>
      $composableBuilder(column: $table.videoUrl, builder: (column) => column);

  GeneratedColumn<String> get posterUrl =>
      $composableBuilder(column: $table.posterUrl, builder: (column) => column);

  GeneratedColumn<int> get videoWidth => $composableBuilder(
    column: $table.videoWidth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get videoHeight => $composableBuilder(
    column: $table.videoHeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get videoDurationMs => $composableBuilder(
    column: $table.videoDurationMs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isVideoReady => $composableBuilder(
    column: $table.isVideoReady,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get likeCount =>
      $composableBuilder(column: $table.likeCount, builder: (column) => column);

  GeneratedColumn<int> get saveCount =>
      $composableBuilder(column: $table.saveCount, builder: (column) => column);

  GeneratedColumn<int> get commentCount => $composableBuilder(
    column: $table.commentCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get viewerHasLiked => $composableBuilder(
    column: $table.viewerHasLiked,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get viewerHasSaved => $composableBuilder(
    column: $table.viewerHasSaved,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get commentsDisabled => $composableBuilder(
    column: $table.commentsDisabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$ReelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReelsTable,
          CachedReel,
          $$ReelsTableFilterComposer,
          $$ReelsTableOrderingComposer,
          $$ReelsTableAnnotationComposer,
          $$ReelsTableCreateCompanionBuilder,
          $$ReelsTableUpdateCompanionBuilder,
          (CachedReel, BaseReferences<_$AppDatabase, $ReelsTable, CachedReel>),
          CachedReel,
          PrefetchHooks Function()
        > {
  $$ReelsTableTableManager(_$AppDatabase db, $ReelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String?> authorUsername = const Value.absent(),
                Value<String?> authorDisplayName = const Value.absent(),
                Value<String?> authorAvatarUrl = const Value.absent(),
                Value<bool> authorIsVerified = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<String?> videoUrl = const Value.absent(),
                Value<String?> posterUrl = const Value.absent(),
                Value<int?> videoWidth = const Value.absent(),
                Value<int?> videoHeight = const Value.absent(),
                Value<int?> videoDurationMs = const Value.absent(),
                Value<bool> isVideoReady = const Value.absent(),
                Value<String?> locationName = const Value.absent(),
                Value<int> likeCount = const Value.absent(),
                Value<int> saveCount = const Value.absent(),
                Value<int> commentCount = const Value.absent(),
                Value<bool> viewerHasLiked = const Value.absent(),
                Value<bool> viewerHasSaved = const Value.absent(),
                Value<bool> commentsDisabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReelsCompanion(
                id: id,
                authorId: authorId,
                authorUsername: authorUsername,
                authorDisplayName: authorDisplayName,
                authorAvatarUrl: authorAvatarUrl,
                authorIsVerified: authorIsVerified,
                caption: caption,
                videoUrl: videoUrl,
                posterUrl: posterUrl,
                videoWidth: videoWidth,
                videoHeight: videoHeight,
                videoDurationMs: videoDurationMs,
                isVideoReady: isVideoReady,
                locationName: locationName,
                likeCount: likeCount,
                saveCount: saveCount,
                commentCount: commentCount,
                viewerHasLiked: viewerHasLiked,
                viewerHasSaved: viewerHasSaved,
                commentsDisabled: commentsDisabled,
                createdAt: createdAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String authorId,
                Value<String?> authorUsername = const Value.absent(),
                Value<String?> authorDisplayName = const Value.absent(),
                Value<String?> authorAvatarUrl = const Value.absent(),
                required bool authorIsVerified,
                Value<String?> caption = const Value.absent(),
                Value<String?> videoUrl = const Value.absent(),
                Value<String?> posterUrl = const Value.absent(),
                Value<int?> videoWidth = const Value.absent(),
                Value<int?> videoHeight = const Value.absent(),
                Value<int?> videoDurationMs = const Value.absent(),
                required bool isVideoReady,
                Value<String?> locationName = const Value.absent(),
                required int likeCount,
                required int saveCount,
                required int commentCount,
                required bool viewerHasLiked,
                required bool viewerHasSaved,
                required bool commentsDisabled,
                required DateTime createdAt,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReelsCompanion.insert(
                id: id,
                authorId: authorId,
                authorUsername: authorUsername,
                authorDisplayName: authorDisplayName,
                authorAvatarUrl: authorAvatarUrl,
                authorIsVerified: authorIsVerified,
                caption: caption,
                videoUrl: videoUrl,
                posterUrl: posterUrl,
                videoWidth: videoWidth,
                videoHeight: videoHeight,
                videoDurationMs: videoDurationMs,
                isVideoReady: isVideoReady,
                locationName: locationName,
                likeCount: likeCount,
                saveCount: saveCount,
                commentCount: commentCount,
                viewerHasLiked: viewerHasLiked,
                viewerHasSaved: viewerHasSaved,
                commentsDisabled: commentsDisabled,
                createdAt: createdAt,
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

typedef $$ReelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReelsTable,
      CachedReel,
      $$ReelsTableFilterComposer,
      $$ReelsTableOrderingComposer,
      $$ReelsTableAnnotationComposer,
      $$ReelsTableCreateCompanionBuilder,
      $$ReelsTableUpdateCompanionBuilder,
      (CachedReel, BaseReferences<_$AppDatabase, $ReelsTable, CachedReel>),
      CachedReel,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$MeProfilesTableTableManager get meProfiles =>
      $$MeProfilesTableTableManager(_db, _db.meProfiles);
  $$PostsTableTableManager get posts =>
      $$PostsTableTableManager(_db, _db.posts);
  $$StorySeenSegmentsTableTableManager get storySeenSegments =>
      $$StorySeenSegmentsTableTableManager(_db, _db.storySeenSegments);
  $$ComposeDraftsTableTableManager get composeDrafts =>
      $$ComposeDraftsTableTableManager(_db, _db.composeDrafts);
  $$ReelsTableTableManager get reels =>
      $$ReelsTableTableManager(_db, _db.reels);
}
