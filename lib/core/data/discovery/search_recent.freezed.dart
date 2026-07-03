// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_recent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchRecent {

 String get id; SearchRecentType get type; DateTime get recordedAt; String? get term; UserSummary? get account; HashtagResult? get hashtag; Place? get place;
/// Create a copy of SearchRecent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchRecentCopyWith<SearchRecent> get copyWith => _$SearchRecentCopyWithImpl<SearchRecent>(this as SearchRecent, _$identity);

  /// Serializes this SearchRecent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchRecent&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.term, term) || other.term == term)&&(identical(other.account, account) || other.account == account)&&(identical(other.hashtag, hashtag) || other.hashtag == hashtag)&&(identical(other.place, place) || other.place == place));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,recordedAt,term,account,hashtag,place);

@override
String toString() {
  return 'SearchRecent(id: $id, type: $type, recordedAt: $recordedAt, term: $term, account: $account, hashtag: $hashtag, place: $place)';
}


}

/// @nodoc
abstract mixin class $SearchRecentCopyWith<$Res>  {
  factory $SearchRecentCopyWith(SearchRecent value, $Res Function(SearchRecent) _then) = _$SearchRecentCopyWithImpl;
@useResult
$Res call({
 String id, SearchRecentType type, DateTime recordedAt, String? term, UserSummary? account, HashtagResult? hashtag, Place? place
});


$UserSummaryCopyWith<$Res>? get account;$HashtagResultCopyWith<$Res>? get hashtag;$PlaceCopyWith<$Res>? get place;

}
/// @nodoc
class _$SearchRecentCopyWithImpl<$Res>
    implements $SearchRecentCopyWith<$Res> {
  _$SearchRecentCopyWithImpl(this._self, this._then);

  final SearchRecent _self;
  final $Res Function(SearchRecent) _then;

/// Create a copy of SearchRecent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? recordedAt = null,Object? term = freezed,Object? account = freezed,Object? hashtag = freezed,Object? place = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SearchRecentType,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,term: freezed == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as String?,account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as UserSummary?,hashtag: freezed == hashtag ? _self.hashtag : hashtag // ignore: cast_nullable_to_non_nullable
as HashtagResult?,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as Place?,
  ));
}
/// Create a copy of SearchRecent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res>? get account {
    if (_self.account == null) {
    return null;
  }

  return $UserSummaryCopyWith<$Res>(_self.account!, (value) {
    return _then(_self.copyWith(account: value));
  });
}/// Create a copy of SearchRecent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HashtagResultCopyWith<$Res>? get hashtag {
    if (_self.hashtag == null) {
    return null;
  }

  return $HashtagResultCopyWith<$Res>(_self.hashtag!, (value) {
    return _then(_self.copyWith(hashtag: value));
  });
}/// Create a copy of SearchRecent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaceCopyWith<$Res>? get place {
    if (_self.place == null) {
    return null;
  }

  return $PlaceCopyWith<$Res>(_self.place!, (value) {
    return _then(_self.copyWith(place: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchRecent].
extension SearchRecentPatterns on SearchRecent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchRecent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchRecent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchRecent value)  $default,){
final _that = this;
switch (_that) {
case _SearchRecent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchRecent value)?  $default,){
final _that = this;
switch (_that) {
case _SearchRecent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  SearchRecentType type,  DateTime recordedAt,  String? term,  UserSummary? account,  HashtagResult? hashtag,  Place? place)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchRecent() when $default != null:
return $default(_that.id,_that.type,_that.recordedAt,_that.term,_that.account,_that.hashtag,_that.place);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  SearchRecentType type,  DateTime recordedAt,  String? term,  UserSummary? account,  HashtagResult? hashtag,  Place? place)  $default,) {final _that = this;
switch (_that) {
case _SearchRecent():
return $default(_that.id,_that.type,_that.recordedAt,_that.term,_that.account,_that.hashtag,_that.place);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  SearchRecentType type,  DateTime recordedAt,  String? term,  UserSummary? account,  HashtagResult? hashtag,  Place? place)?  $default,) {final _that = this;
switch (_that) {
case _SearchRecent() when $default != null:
return $default(_that.id,_that.type,_that.recordedAt,_that.term,_that.account,_that.hashtag,_that.place);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchRecent implements SearchRecent {
  const _SearchRecent({required this.id, required this.type, required this.recordedAt, this.term, this.account, this.hashtag, this.place});
  factory _SearchRecent.fromJson(Map<String, dynamic> json) => _$SearchRecentFromJson(json);

@override final  String id;
@override final  SearchRecentType type;
@override final  DateTime recordedAt;
@override final  String? term;
@override final  UserSummary? account;
@override final  HashtagResult? hashtag;
@override final  Place? place;

/// Create a copy of SearchRecent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchRecentCopyWith<_SearchRecent> get copyWith => __$SearchRecentCopyWithImpl<_SearchRecent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchRecentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchRecent&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.term, term) || other.term == term)&&(identical(other.account, account) || other.account == account)&&(identical(other.hashtag, hashtag) || other.hashtag == hashtag)&&(identical(other.place, place) || other.place == place));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,recordedAt,term,account,hashtag,place);

@override
String toString() {
  return 'SearchRecent(id: $id, type: $type, recordedAt: $recordedAt, term: $term, account: $account, hashtag: $hashtag, place: $place)';
}


}

/// @nodoc
abstract mixin class _$SearchRecentCopyWith<$Res> implements $SearchRecentCopyWith<$Res> {
  factory _$SearchRecentCopyWith(_SearchRecent value, $Res Function(_SearchRecent) _then) = __$SearchRecentCopyWithImpl;
@override @useResult
$Res call({
 String id, SearchRecentType type, DateTime recordedAt, String? term, UserSummary? account, HashtagResult? hashtag, Place? place
});


@override $UserSummaryCopyWith<$Res>? get account;@override $HashtagResultCopyWith<$Res>? get hashtag;@override $PlaceCopyWith<$Res>? get place;

}
/// @nodoc
class __$SearchRecentCopyWithImpl<$Res>
    implements _$SearchRecentCopyWith<$Res> {
  __$SearchRecentCopyWithImpl(this._self, this._then);

  final _SearchRecent _self;
  final $Res Function(_SearchRecent) _then;

/// Create a copy of SearchRecent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? recordedAt = null,Object? term = freezed,Object? account = freezed,Object? hashtag = freezed,Object? place = freezed,}) {
  return _then(_SearchRecent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SearchRecentType,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,term: freezed == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as String?,account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as UserSummary?,hashtag: freezed == hashtag ? _self.hashtag : hashtag // ignore: cast_nullable_to_non_nullable
as HashtagResult?,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as Place?,
  ));
}

/// Create a copy of SearchRecent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res>? get account {
    if (_self.account == null) {
    return null;
  }

  return $UserSummaryCopyWith<$Res>(_self.account!, (value) {
    return _then(_self.copyWith(account: value));
  });
}/// Create a copy of SearchRecent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HashtagResultCopyWith<$Res>? get hashtag {
    if (_self.hashtag == null) {
    return null;
  }

  return $HashtagResultCopyWith<$Res>(_self.hashtag!, (value) {
    return _then(_self.copyWith(hashtag: value));
  });
}/// Create a copy of SearchRecent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaceCopyWith<$Res>? get place {
    if (_self.place == null) {
    return null;
  }

  return $PlaceCopyWith<$Res>(_self.place!, (value) {
    return _then(_self.copyWith(place: value));
  });
}
}

// dart format on
