import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageState extends StateNotifier<int>{
  PageState() : super(0);

  void changePage(int index){
    state = index;
  }
}