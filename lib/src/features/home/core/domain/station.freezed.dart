// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Station _$StationFromJson(Map<String, dynamic> json) {
  return _Station.fromJson(json);
}

/// @nodoc
mixin _$Station {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  List<String> get fuelTypes => throw _privateConstructorUsedError;
  Map<String, double> get prices => throw _privateConstructorUsedError;
  bool get hasCompressedAir => throw _privateConstructorUsedError;
  Map<String, String> get address => throw _privateConstructorUsedError;
  String? get openingHours => throw _privateConstructorUsedError;
  bool get wheelchairAccessible => throw _privateConstructorUsedError;
  String get geometryType => throw _privateConstructorUsedError;
  List<LatLng>? get polygonCoordinates => throw _privateConstructorUsedError;
  bool get isOpen => throw _privateConstructorUsedError; // isFaborite
  bool get isFavorite => throw _privateConstructorUsedError;

  /// Serializes this Station to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Station
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StationCopyWith<Station> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StationCopyWith<$Res> {
  factory $StationCopyWith(Station value, $Res Function(Station) then) =
      _$StationCopyWithImpl<$Res, Station>;
  @useResult
  $Res call(
      {String id,
      String name,
      double latitude,
      double longitude,
      String? brand,
      List<String> fuelTypes,
      Map<String, double> prices,
      bool hasCompressedAir,
      Map<String, String> address,
      String? openingHours,
      bool wheelchairAccessible,
      String geometryType,
      List<LatLng>? polygonCoordinates,
      bool isOpen,
      bool isFavorite});
}

/// @nodoc
class _$StationCopyWithImpl<$Res, $Val extends Station>
    implements $StationCopyWith<$Res> {
  _$StationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Station
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? brand = freezed,
    Object? fuelTypes = null,
    Object? prices = null,
    Object? hasCompressedAir = null,
    Object? address = null,
    Object? openingHours = freezed,
    Object? wheelchairAccessible = null,
    Object? geometryType = null,
    Object? polygonCoordinates = freezed,
    Object? isOpen = null,
    Object? isFavorite = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelTypes: null == fuelTypes
          ? _value.fuelTypes
          : fuelTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      prices: null == prices
          ? _value.prices
          : prices // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      hasCompressedAir: null == hasCompressedAir
          ? _value.hasCompressedAir
          : hasCompressedAir // ignore: cast_nullable_to_non_nullable
              as bool,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      openingHours: freezed == openingHours
          ? _value.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as String?,
      wheelchairAccessible: null == wheelchairAccessible
          ? _value.wheelchairAccessible
          : wheelchairAccessible // ignore: cast_nullable_to_non_nullable
              as bool,
      geometryType: null == geometryType
          ? _value.geometryType
          : geometryType // ignore: cast_nullable_to_non_nullable
              as String,
      polygonCoordinates: freezed == polygonCoordinates
          ? _value.polygonCoordinates
          : polygonCoordinates // ignore: cast_nullable_to_non_nullable
              as List<LatLng>?,
      isOpen: null == isOpen
          ? _value.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StationImplCopyWith<$Res> implements $StationCopyWith<$Res> {
  factory _$$StationImplCopyWith(
          _$StationImpl value, $Res Function(_$StationImpl) then) =
      __$$StationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double latitude,
      double longitude,
      String? brand,
      List<String> fuelTypes,
      Map<String, double> prices,
      bool hasCompressedAir,
      Map<String, String> address,
      String? openingHours,
      bool wheelchairAccessible,
      String geometryType,
      List<LatLng>? polygonCoordinates,
      bool isOpen,
      bool isFavorite});
}

/// @nodoc
class __$$StationImplCopyWithImpl<$Res>
    extends _$StationCopyWithImpl<$Res, _$StationImpl>
    implements _$$StationImplCopyWith<$Res> {
  __$$StationImplCopyWithImpl(
      _$StationImpl _value, $Res Function(_$StationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Station
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? brand = freezed,
    Object? fuelTypes = null,
    Object? prices = null,
    Object? hasCompressedAir = null,
    Object? address = null,
    Object? openingHours = freezed,
    Object? wheelchairAccessible = null,
    Object? geometryType = null,
    Object? polygonCoordinates = freezed,
    Object? isOpen = null,
    Object? isFavorite = null,
  }) {
    return _then(_$StationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelTypes: null == fuelTypes
          ? _value._fuelTypes
          : fuelTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      prices: null == prices
          ? _value._prices
          : prices // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      hasCompressedAir: null == hasCompressedAir
          ? _value.hasCompressedAir
          : hasCompressedAir // ignore: cast_nullable_to_non_nullable
              as bool,
      address: null == address
          ? _value._address
          : address // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      openingHours: freezed == openingHours
          ? _value.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as String?,
      wheelchairAccessible: null == wheelchairAccessible
          ? _value.wheelchairAccessible
          : wheelchairAccessible // ignore: cast_nullable_to_non_nullable
              as bool,
      geometryType: null == geometryType
          ? _value.geometryType
          : geometryType // ignore: cast_nullable_to_non_nullable
              as String,
      polygonCoordinates: freezed == polygonCoordinates
          ? _value._polygonCoordinates
          : polygonCoordinates // ignore: cast_nullable_to_non_nullable
              as List<LatLng>?,
      isOpen: null == isOpen
          ? _value.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StationImpl implements _Station {
  const _$StationImpl(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      this.brand,
      final List<String> fuelTypes = const [],
      final Map<String, double> prices = const {},
      this.hasCompressedAir = false,
      final Map<String, String> address = const {},
      this.openingHours,
      this.wheelchairAccessible = false,
      required this.geometryType,
      final List<LatLng>? polygonCoordinates,
      this.isOpen = false,
      this.isFavorite = false})
      : _fuelTypes = fuelTypes,
        _prices = prices,
        _address = address,
        _polygonCoordinates = polygonCoordinates;

  factory _$StationImpl.fromJson(Map<String, dynamic> json) =>
      _$$StationImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? brand;
  final List<String> _fuelTypes;
  @override
  @JsonKey()
  List<String> get fuelTypes {
    if (_fuelTypes is EqualUnmodifiableListView) return _fuelTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fuelTypes);
  }

  final Map<String, double> _prices;
  @override
  @JsonKey()
  Map<String, double> get prices {
    if (_prices is EqualUnmodifiableMapView) return _prices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_prices);
  }

  @override
  @JsonKey()
  final bool hasCompressedAir;
  final Map<String, String> _address;
  @override
  @JsonKey()
  Map<String, String> get address {
    if (_address is EqualUnmodifiableMapView) return _address;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_address);
  }

  @override
  final String? openingHours;
  @override
  @JsonKey()
  final bool wheelchairAccessible;
  @override
  final String geometryType;
  final List<LatLng>? _polygonCoordinates;
  @override
  List<LatLng>? get polygonCoordinates {
    final value = _polygonCoordinates;
    if (value == null) return null;
    if (_polygonCoordinates is EqualUnmodifiableListView)
      return _polygonCoordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool isOpen;
// isFaborite
  @override
  @JsonKey()
  final bool isFavorite;

  @override
  String toString() {
    return 'Station(id: $id, name: $name, latitude: $latitude, longitude: $longitude, brand: $brand, fuelTypes: $fuelTypes, prices: $prices, hasCompressedAir: $hasCompressedAir, address: $address, openingHours: $openingHours, wheelchairAccessible: $wheelchairAccessible, geometryType: $geometryType, polygonCoordinates: $polygonCoordinates, isOpen: $isOpen, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            const DeepCollectionEquality()
                .equals(other._fuelTypes, _fuelTypes) &&
            const DeepCollectionEquality().equals(other._prices, _prices) &&
            (identical(other.hasCompressedAir, hasCompressedAir) ||
                other.hasCompressedAir == hasCompressedAir) &&
            const DeepCollectionEquality().equals(other._address, _address) &&
            (identical(other.openingHours, openingHours) ||
                other.openingHours == openingHours) &&
            (identical(other.wheelchairAccessible, wheelchairAccessible) ||
                other.wheelchairAccessible == wheelchairAccessible) &&
            (identical(other.geometryType, geometryType) ||
                other.geometryType == geometryType) &&
            const DeepCollectionEquality()
                .equals(other._polygonCoordinates, _polygonCoordinates) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      latitude,
      longitude,
      brand,
      const DeepCollectionEquality().hash(_fuelTypes),
      const DeepCollectionEquality().hash(_prices),
      hasCompressedAir,
      const DeepCollectionEquality().hash(_address),
      openingHours,
      wheelchairAccessible,
      geometryType,
      const DeepCollectionEquality().hash(_polygonCoordinates),
      isOpen,
      isFavorite);

  /// Create a copy of Station
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StationImplCopyWith<_$StationImpl> get copyWith =>
      __$$StationImplCopyWithImpl<_$StationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StationImplToJson(
      this,
    );
  }
}

abstract class _Station implements Station {
  const factory _Station(
      {required final String id,
      required final String name,
      required final double latitude,
      required final double longitude,
      final String? brand,
      final List<String> fuelTypes,
      final Map<String, double> prices,
      final bool hasCompressedAir,
      final Map<String, String> address,
      final String? openingHours,
      final bool wheelchairAccessible,
      required final String geometryType,
      final List<LatLng>? polygonCoordinates,
      final bool isOpen,
      final bool isFavorite}) = _$StationImpl;

  factory _Station.fromJson(Map<String, dynamic> json) = _$StationImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get brand;
  @override
  List<String> get fuelTypes;
  @override
  Map<String, double> get prices;
  @override
  bool get hasCompressedAir;
  @override
  Map<String, String> get address;
  @override
  String? get openingHours;
  @override
  bool get wheelchairAccessible;
  @override
  String get geometryType;
  @override
  List<LatLng>? get polygonCoordinates;
  @override
  bool get isOpen; // isFaborite
  @override
  bool get isFavorite;

  /// Create a copy of Station
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StationImplCopyWith<_$StationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
