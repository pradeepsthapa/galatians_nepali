import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galatians_nepali/logics/page_state.dart';
import 'package:galatians_nepali/logics/theme_state.dart';
import 'package:get_storage/get_storage.dart';

final pageStateProvider = StateNotifierProvider<PageState,int>((ref)=>PageState());

final themeStateProvider = StateNotifierProvider<ThemeState,bool>((ref){
  final _box = GetStorage();
  _box.writeIfNull('isDark', false);
  return ThemeState(_box.read('isDark'));
});