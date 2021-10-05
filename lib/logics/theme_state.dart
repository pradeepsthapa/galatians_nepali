import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

class ThemeState extends StateNotifier<bool>{
  ThemeState(bool state) : super(state);

final _box = GetStorage();
  void toggleDark(){
    state = !state;
    _box.write('isDark', state);
  }

}