// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchState()';
}


}

/// @nodoc
class $SearchStateCopyWith<$Res>  {
$SearchStateCopyWith(SearchState _, $Res Function(SearchState) __);
}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchInitial value)?  initial,TResult Function( SearchLoading value)?  loading,TResult Function( SearchLoaded value)?  loaded,TResult Function( SearchError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial(_that);case SearchLoading() when loading != null:
return loading(_that);case SearchLoaded() when loaded != null:
return loaded(_that);case SearchError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchInitial value)  initial,required TResult Function( SearchLoading value)  loading,required TResult Function( SearchLoaded value)  loaded,required TResult Function( SearchError value)  error,}){
final _that = this;
switch (_that) {
case SearchInitial():
return initial(_that);case SearchLoading():
return loading(_that);case SearchLoaded():
return loaded(_that);case SearchError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchInitial value)?  initial,TResult? Function( SearchLoading value)?  loading,TResult? Function( SearchLoaded value)?  loaded,TResult? Function( SearchError value)?  error,}){
final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial(_that);case SearchLoading() when loading != null:
return loading(_that);case SearchLoaded() when loaded != null:
return loaded(_that);case SearchError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String query,  SearchTab tab)?  loading,TResult Function( String query,  SearchTab tab,  List<AccountResult> accounts,  List<HashtagResult> tags,  List<PlaceResult> places,  SearchTop? top,  bool hasMore,  bool loadingMore)?  loaded,TResult Function( String query,  SearchTab tab,  AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial();case SearchLoading() when loading != null:
return loading(_that.query,_that.tab);case SearchLoaded() when loaded != null:
return loaded(_that.query,_that.tab,_that.accounts,_that.tags,_that.places,_that.top,_that.hasMore,_that.loadingMore);case SearchError() when error != null:
return error(_that.query,_that.tab,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String query,  SearchTab tab)  loading,required TResult Function( String query,  SearchTab tab,  List<AccountResult> accounts,  List<HashtagResult> tags,  List<PlaceResult> places,  SearchTop? top,  bool hasMore,  bool loadingMore)  loaded,required TResult Function( String query,  SearchTab tab,  AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case SearchInitial():
return initial();case SearchLoading():
return loading(_that.query,_that.tab);case SearchLoaded():
return loaded(_that.query,_that.tab,_that.accounts,_that.tags,_that.places,_that.top,_that.hasMore,_that.loadingMore);case SearchError():
return error(_that.query,_that.tab,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String query,  SearchTab tab)?  loading,TResult? Function( String query,  SearchTab tab,  List<AccountResult> accounts,  List<HashtagResult> tags,  List<PlaceResult> places,  SearchTop? top,  bool hasMore,  bool loadingMore)?  loaded,TResult? Function( String query,  SearchTab tab,  AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial();case SearchLoading() when loading != null:
return loading(_that.query,_that.tab);case SearchLoaded() when loaded != null:
return loaded(_that.query,_that.tab,_that.accounts,_that.tags,_that.places,_that.top,_that.hasMore,_that.loadingMore);case SearchError() when error != null:
return error(_that.query,_that.tab,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class SearchInitial extends SearchState {
  const SearchInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchState.initial()';
}


}




/// @nodoc


class SearchLoading extends SearchState {
  const SearchLoading({required this.query, required this.tab}): super._();
  

 final  String query;
 final  SearchTab tab;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchLoadingCopyWith<SearchLoading> get copyWith => _$SearchLoadingCopyWithImpl<SearchLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchLoading&&(identical(other.query, query) || other.query == query)&&(identical(other.tab, tab) || other.tab == tab));
}


@override
int get hashCode => Object.hash(runtimeType,query,tab);

@override
String toString() {
  return 'SearchState.loading(query: $query, tab: $tab)';
}


}

/// @nodoc
abstract mixin class $SearchLoadingCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchLoadingCopyWith(SearchLoading value, $Res Function(SearchLoading) _then) = _$SearchLoadingCopyWithImpl;
@useResult
$Res call({
 String query, SearchTab tab
});




}
/// @nodoc
class _$SearchLoadingCopyWithImpl<$Res>
    implements $SearchLoadingCopyWith<$Res> {
  _$SearchLoadingCopyWithImpl(this._self, this._then);

  final SearchLoading _self;
  final $Res Function(SearchLoading) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,Object? tab = null,}) {
  return _then(SearchLoading(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as SearchTab,
  ));
}


}

/// @nodoc


class SearchLoaded extends SearchState {
  const SearchLoaded({required this.query, required this.tab, required final  List<AccountResult> accounts, required final  List<HashtagResult> tags, required final  List<PlaceResult> places, this.top, this.hasMore = false, this.loadingMore = false}): _accounts = accounts,_tags = tags,_places = places,super._();
  

 final  String query;
 final  SearchTab tab;
 final  List<AccountResult> _accounts;
 List<AccountResult> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

 final  List<HashtagResult> _tags;
 List<HashtagResult> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<PlaceResult> _places;
 List<PlaceResult> get places {
  if (_places is EqualUnmodifiableListView) return _places;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_places);
}

 final  SearchTop? top;
@JsonKey() final  bool hasMore;
@JsonKey() final  bool loadingMore;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchLoadedCopyWith<SearchLoaded> get copyWith => _$SearchLoadedCopyWithImpl<SearchLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchLoaded&&(identical(other.query, query) || other.query == query)&&(identical(other.tab, tab) || other.tab == tab)&&const DeepCollectionEquality().equals(other._accounts, _accounts)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._places, _places)&&(identical(other.top, top) || other.top == top)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,query,tab,const DeepCollectionEquality().hash(_accounts),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_places),top,hasMore,loadingMore);

@override
String toString() {
  return 'SearchState.loaded(query: $query, tab: $tab, accounts: $accounts, tags: $tags, places: $places, top: $top, hasMore: $hasMore, loadingMore: $loadingMore)';
}


}

/// @nodoc
abstract mixin class $SearchLoadedCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchLoadedCopyWith(SearchLoaded value, $Res Function(SearchLoaded) _then) = _$SearchLoadedCopyWithImpl;
@useResult
$Res call({
 String query, SearchTab tab, List<AccountResult> accounts, List<HashtagResult> tags, List<PlaceResult> places, SearchTop? top, bool hasMore, bool loadingMore
});


$SearchTopCopyWith<$Res>? get top;

}
/// @nodoc
class _$SearchLoadedCopyWithImpl<$Res>
    implements $SearchLoadedCopyWith<$Res> {
  _$SearchLoadedCopyWithImpl(this._self, this._then);

  final SearchLoaded _self;
  final $Res Function(SearchLoaded) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,Object? tab = null,Object? accounts = null,Object? tags = null,Object? places = null,Object? top = freezed,Object? hasMore = null,Object? loadingMore = null,}) {
  return _then(SearchLoaded(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as SearchTab,accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<AccountResult>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<HashtagResult>,places: null == places ? _self._places : places // ignore: cast_nullable_to_non_nullable
as List<PlaceResult>,top: freezed == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as SearchTop?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchTopCopyWith<$Res>? get top {
    if (_self.top == null) {
    return null;
  }

  return $SearchTopCopyWith<$Res>(_self.top!, (value) {
    return _then(_self.copyWith(top: value));
  });
}
}

/// @nodoc


class SearchError extends SearchState {
  const SearchError({required this.query, required this.tab, required this.failure}): super._();
  

 final  String query;
 final  SearchTab tab;
 final  AppFailure failure;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchErrorCopyWith<SearchError> get copyWith => _$SearchErrorCopyWithImpl<SearchError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchError&&(identical(other.query, query) || other.query == query)&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,query,tab,failure);

@override
String toString() {
  return 'SearchState.error(query: $query, tab: $tab, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SearchErrorCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchErrorCopyWith(SearchError value, $Res Function(SearchError) _then) = _$SearchErrorCopyWithImpl;
@useResult
$Res call({
 String query, SearchTab tab, AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$SearchErrorCopyWithImpl<$Res>
    implements $SearchErrorCopyWith<$Res> {
  _$SearchErrorCopyWithImpl(this._self, this._then);

  final SearchError _self;
  final $Res Function(SearchError) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,Object? tab = null,Object? failure = null,}) {
  return _then(SearchError(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as SearchTab,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of SearchState
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
