import 'package:hive_ce/hive.dart';
import 'package:carbu_track/src/features/home/favorite/infrastructure/domain/favorite.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<Favorite>(),
])
// This is for code generation
// ignore: unused_element
void _() {}
