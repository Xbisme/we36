// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comments_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReplyContext {

 String get parentId; String get handle;
/// Create a copy of ReplyContext
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReplyContextCopyWith<ReplyContext> get copyWith => _$ReplyContextCopyWithImpl<ReplyContext>(this as ReplyContext, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReplyContext&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.handle, handle) || other.handle == handle));
}


@override
int get hashCode => Object.hash(runtimeType,parentId,handle);

@override
String toString() {
  return 'ReplyContext(parentId: $parentId, handle: $handle)';
}


}

/// @nodoc
abstract mixin class $ReplyContextCopyWith<$Res>  {
  factory $ReplyContextCopyWith(ReplyContext value, $Res Function(ReplyContext) _then) = _$ReplyContextCopyWithImpl;
@useResult
$Res call({
 String parentId, String handle
});




}
/// @nodoc
class _$ReplyContextCopyWithImpl<$Res>
    implements $ReplyContextCopyWith<$Res> {
  _$ReplyContextCopyWithImpl(this._self, this._then);

  final ReplyContext _self;
  final $Res Function(ReplyContext) _then;

/// Create a copy of ReplyContext
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parentId = null,Object? handle = null,}) {
  return _then(_self.copyWith(
parentId: null == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String,handle: null == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReplyContext].
extension ReplyContextPatterns on ReplyContext {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReplyContext value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReplyContext() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReplyContext value)  $default,){
final _that = this;
switch (_that) {
case _ReplyContext():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReplyContext value)?  $default,){
final _that = this;
switch (_that) {
case _ReplyContext() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String parentId,  String handle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReplyContext() when $default != null:
return $default(_that.parentId,_that.handle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String parentId,  String handle)  $default,) {final _that = this;
switch (_that) {
case _ReplyContext():
return $default(_that.parentId,_that.handle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String parentId,  String handle)?  $default,) {final _that = this;
switch (_that) {
case _ReplyContext() when $default != null:
return $default(_that.parentId,_that.handle);case _:
  return null;

}
}

}

/// @nodoc


class _ReplyContext implements ReplyContext {
  const _ReplyContext({required this.parentId, required this.handle});
  

@override final  String parentId;
@override final  String handle;

/// Create a copy of ReplyContext
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReplyContextCopyWith<_ReplyContext> get copyWith => __$ReplyContextCopyWithImpl<_ReplyContext>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReplyContext&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.handle, handle) || other.handle == handle));
}


@override
int get hashCode => Object.hash(runtimeType,parentId,handle);

@override
String toString() {
  return 'ReplyContext(parentId: $parentId, handle: $handle)';
}


}

/// @nodoc
abstract mixin class _$ReplyContextCopyWith<$Res> implements $ReplyContextCopyWith<$Res> {
  factory _$ReplyContextCopyWith(_ReplyContext value, $Res Function(_ReplyContext) _then) = __$ReplyContextCopyWithImpl;
@override @useResult
$Res call({
 String parentId, String handle
});




}
/// @nodoc
class __$ReplyContextCopyWithImpl<$Res>
    implements _$ReplyContextCopyWith<$Res> {
  __$ReplyContextCopyWithImpl(this._self, this._then);

  final _ReplyContext _self;
  final $Res Function(_ReplyContext) _then;

/// Create a copy of ReplyContext
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parentId = null,Object? handle = null,}) {
  return _then(_ReplyContext(
parentId: null == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String,handle: null == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$CommentsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CommentsState()';
}


}

/// @nodoc
class $CommentsStateCopyWith<$Res>  {
$CommentsStateCopyWith(CommentsState _, $Res Function(CommentsState) __);
}


/// Adds pattern-matching-related methods to [CommentsState].
extension CommentsStatePatterns on CommentsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CommentsInitial value)?  initial,TResult Function( CommentsLoading value)?  loading,TResult Function( CommentsLoaded value)?  loaded,TResult Function( CommentsLoadedPaginating value)?  loadedPaginating,TResult Function( CommentsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CommentsInitial() when initial != null:
return initial(_that);case CommentsLoading() when loading != null:
return loading(_that);case CommentsLoaded() when loaded != null:
return loaded(_that);case CommentsLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that);case CommentsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CommentsInitial value)  initial,required TResult Function( CommentsLoading value)  loading,required TResult Function( CommentsLoaded value)  loaded,required TResult Function( CommentsLoadedPaginating value)  loadedPaginating,required TResult Function( CommentsError value)  error,}){
final _that = this;
switch (_that) {
case CommentsInitial():
return initial(_that);case CommentsLoading():
return loading(_that);case CommentsLoaded():
return loaded(_that);case CommentsLoadedPaginating():
return loadedPaginating(_that);case CommentsError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CommentsInitial value)?  initial,TResult? Function( CommentsLoading value)?  loading,TResult? Function( CommentsLoaded value)?  loaded,TResult? Function( CommentsLoadedPaginating value)?  loadedPaginating,TResult? Function( CommentsError value)?  error,}){
final _that = this;
switch (_that) {
case CommentsInitial() when initial != null:
return initial(_that);case CommentsLoading() when loading != null:
return loading(_that);case CommentsLoaded() when loaded != null:
return loaded(_that);case CommentsLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that);case CommentsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Post? post,  List<Comment> comments,  bool hasMore,  String? nextCursor,  ReplyContext? replyContext)?  loaded,TResult Function( Post? post,  List<Comment> comments,  bool hasMore,  String? nextCursor,  ReplyContext? replyContext)?  loadedPaginating,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CommentsInitial() when initial != null:
return initial();case CommentsLoading() when loading != null:
return loading();case CommentsLoaded() when loaded != null:
return loaded(_that.post,_that.comments,_that.hasMore,_that.nextCursor,_that.replyContext);case CommentsLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that.post,_that.comments,_that.hasMore,_that.nextCursor,_that.replyContext);case CommentsError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Post? post,  List<Comment> comments,  bool hasMore,  String? nextCursor,  ReplyContext? replyContext)  loaded,required TResult Function( Post? post,  List<Comment> comments,  bool hasMore,  String? nextCursor,  ReplyContext? replyContext)  loadedPaginating,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case CommentsInitial():
return initial();case CommentsLoading():
return loading();case CommentsLoaded():
return loaded(_that.post,_that.comments,_that.hasMore,_that.nextCursor,_that.replyContext);case CommentsLoadedPaginating():
return loadedPaginating(_that.post,_that.comments,_that.hasMore,_that.nextCursor,_that.replyContext);case CommentsError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Post? post,  List<Comment> comments,  bool hasMore,  String? nextCursor,  ReplyContext? replyContext)?  loaded,TResult? Function( Post? post,  List<Comment> comments,  bool hasMore,  String? nextCursor,  ReplyContext? replyContext)?  loadedPaginating,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case CommentsInitial() when initial != null:
return initial();case CommentsLoading() when loading != null:
return loading();case CommentsLoaded() when loaded != null:
return loaded(_that.post,_that.comments,_that.hasMore,_that.nextCursor,_that.replyContext);case CommentsLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that.post,_that.comments,_that.hasMore,_that.nextCursor,_that.replyContext);case CommentsError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class CommentsInitial extends CommentsState {
  const CommentsInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CommentsState.initial()';
}


}




/// @nodoc


class CommentsLoading extends CommentsState {
  const CommentsLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CommentsState.loading()';
}


}




/// @nodoc


class CommentsLoaded extends CommentsState {
  const CommentsLoaded({required this.post, required final  List<Comment> comments, required this.hasMore, this.nextCursor, this.replyContext}): _comments = comments,super._();
  

 final  Post? post;
 final  List<Comment> _comments;
 List<Comment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

 final  bool hasMore;
 final  String? nextCursor;
 final  ReplyContext? replyContext;

/// Create a copy of CommentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentsLoadedCopyWith<CommentsLoaded> get copyWith => _$CommentsLoadedCopyWithImpl<CommentsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentsLoaded&&(identical(other.post, post) || other.post == post)&&const DeepCollectionEquality().equals(other._comments, _comments)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.replyContext, replyContext) || other.replyContext == replyContext));
}


@override
int get hashCode => Object.hash(runtimeType,post,const DeepCollectionEquality().hash(_comments),hasMore,nextCursor,replyContext);

@override
String toString() {
  return 'CommentsState.loaded(post: $post, comments: $comments, hasMore: $hasMore, nextCursor: $nextCursor, replyContext: $replyContext)';
}


}

/// @nodoc
abstract mixin class $CommentsLoadedCopyWith<$Res> implements $CommentsStateCopyWith<$Res> {
  factory $CommentsLoadedCopyWith(CommentsLoaded value, $Res Function(CommentsLoaded) _then) = _$CommentsLoadedCopyWithImpl;
@useResult
$Res call({
 Post? post, List<Comment> comments, bool hasMore, String? nextCursor, ReplyContext? replyContext
});


$PostCopyWith<$Res>? get post;$ReplyContextCopyWith<$Res>? get replyContext;

}
/// @nodoc
class _$CommentsLoadedCopyWithImpl<$Res>
    implements $CommentsLoadedCopyWith<$Res> {
  _$CommentsLoadedCopyWithImpl(this._self, this._then);

  final CommentsLoaded _self;
  final $Res Function(CommentsLoaded) _then;

/// Create a copy of CommentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? post = freezed,Object? comments = null,Object? hasMore = null,Object? nextCursor = freezed,Object? replyContext = freezed,}) {
  return _then(CommentsLoaded(
post: freezed == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as Post?,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,replyContext: freezed == replyContext ? _self.replyContext : replyContext // ignore: cast_nullable_to_non_nullable
as ReplyContext?,
  ));
}

/// Create a copy of CommentsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCopyWith<$Res>? get post {
    if (_self.post == null) {
    return null;
  }

  return $PostCopyWith<$Res>(_self.post!, (value) {
    return _then(_self.copyWith(post: value));
  });
}/// Create a copy of CommentsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReplyContextCopyWith<$Res>? get replyContext {
    if (_self.replyContext == null) {
    return null;
  }

  return $ReplyContextCopyWith<$Res>(_self.replyContext!, (value) {
    return _then(_self.copyWith(replyContext: value));
  });
}
}

/// @nodoc


class CommentsLoadedPaginating extends CommentsState {
  const CommentsLoadedPaginating({required this.post, required final  List<Comment> comments, required this.hasMore, this.nextCursor, this.replyContext}): _comments = comments,super._();
  

 final  Post? post;
 final  List<Comment> _comments;
 List<Comment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

 final  bool hasMore;
 final  String? nextCursor;
 final  ReplyContext? replyContext;

/// Create a copy of CommentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentsLoadedPaginatingCopyWith<CommentsLoadedPaginating> get copyWith => _$CommentsLoadedPaginatingCopyWithImpl<CommentsLoadedPaginating>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentsLoadedPaginating&&(identical(other.post, post) || other.post == post)&&const DeepCollectionEquality().equals(other._comments, _comments)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.replyContext, replyContext) || other.replyContext == replyContext));
}


@override
int get hashCode => Object.hash(runtimeType,post,const DeepCollectionEquality().hash(_comments),hasMore,nextCursor,replyContext);

@override
String toString() {
  return 'CommentsState.loadedPaginating(post: $post, comments: $comments, hasMore: $hasMore, nextCursor: $nextCursor, replyContext: $replyContext)';
}


}

/// @nodoc
abstract mixin class $CommentsLoadedPaginatingCopyWith<$Res> implements $CommentsStateCopyWith<$Res> {
  factory $CommentsLoadedPaginatingCopyWith(CommentsLoadedPaginating value, $Res Function(CommentsLoadedPaginating) _then) = _$CommentsLoadedPaginatingCopyWithImpl;
@useResult
$Res call({
 Post? post, List<Comment> comments, bool hasMore, String? nextCursor, ReplyContext? replyContext
});


$PostCopyWith<$Res>? get post;$ReplyContextCopyWith<$Res>? get replyContext;

}
/// @nodoc
class _$CommentsLoadedPaginatingCopyWithImpl<$Res>
    implements $CommentsLoadedPaginatingCopyWith<$Res> {
  _$CommentsLoadedPaginatingCopyWithImpl(this._self, this._then);

  final CommentsLoadedPaginating _self;
  final $Res Function(CommentsLoadedPaginating) _then;

/// Create a copy of CommentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? post = freezed,Object? comments = null,Object? hasMore = null,Object? nextCursor = freezed,Object? replyContext = freezed,}) {
  return _then(CommentsLoadedPaginating(
post: freezed == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as Post?,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,replyContext: freezed == replyContext ? _self.replyContext : replyContext // ignore: cast_nullable_to_non_nullable
as ReplyContext?,
  ));
}

/// Create a copy of CommentsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCopyWith<$Res>? get post {
    if (_self.post == null) {
    return null;
  }

  return $PostCopyWith<$Res>(_self.post!, (value) {
    return _then(_self.copyWith(post: value));
  });
}/// Create a copy of CommentsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReplyContextCopyWith<$Res>? get replyContext {
    if (_self.replyContext == null) {
    return null;
  }

  return $ReplyContextCopyWith<$Res>(_self.replyContext!, (value) {
    return _then(_self.copyWith(replyContext: value));
  });
}
}

/// @nodoc


class CommentsError extends CommentsState {
  const CommentsError(this.failure): super._();
  

 final  AppFailure failure;

/// Create a copy of CommentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentsErrorCopyWith<CommentsError> get copyWith => _$CommentsErrorCopyWithImpl<CommentsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentsError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'CommentsState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $CommentsErrorCopyWith<$Res> implements $CommentsStateCopyWith<$Res> {
  factory $CommentsErrorCopyWith(CommentsError value, $Res Function(CommentsError) _then) = _$CommentsErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$CommentsErrorCopyWithImpl<$Res>
    implements $CommentsErrorCopyWith<$Res> {
  _$CommentsErrorCopyWithImpl(this._self, this._then);

  final CommentsError _self;
  final $Res Function(CommentsError) _then;

/// Create a copy of CommentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(CommentsError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of CommentsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppFailureCopyWith<$Res> get failure {
  
  return $AppFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
