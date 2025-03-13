// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StationImpl _$$StationImplFromJson(Map<String, dynamic> json) =>
    _$StationImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      brand: json['brand'] as String?,
      fuelTypes: (json['fuelTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      prices: (json['prices'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      hasCompressedAir: json['hasCompressedAir'] as bool? ?? false,
      address: (json['address'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      openingHours: json['openingHours'] as String?,
      wheelchairAccessible: json['wheelchairAccessible'] as bool? ?? false,
      geometryType: json['geometryType'] as String,
      polygonCoordinates: (json['polygonCoordinates'] as List<dynamic>?)
          ?.map((e) => LatLng.fromJson(e as Map<String, dynamic>))
          .toList(),
      isOpen: json['isOpen'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$$StationImplToJson(_$StationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'brand': instance.brand,
      'fuelTypes': instance.fuelTypes,
      'prices': instance.prices,
      'hasCompressedAir': instance.hasCompressedAir,
      'address': instance.address,
      'openingHours': instance.openingHours,
      'wheelchairAccessible': instance.wheelchairAccessible,
      'geometryType': instance.geometryType,
      'polygonCoordinates': instance.polygonCoordinates,
      'isOpen': instance.isOpen,
      'isFavorite': instance.isFavorite,
    };
