import 'package:hive_ce/hive.dart';

import '../../../core/domain/station.dart';

part 'favorite.g.dart';

@HiveType(typeId: 0)
class Favorite extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  Station station;

  Favorite({required this.id, required this.station});

  @override
  String toString() {
    return 'Favorite{id: $id, station: $station}';
  }
}
