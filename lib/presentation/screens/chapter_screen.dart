import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galatians_nepali/data/model.dart';
import 'package:galatians_nepali/data/model_data.dart';
import 'package:galatians_nepali/logics/providers.dart';

class ChapterScreen extends ConsumerWidget {

  final List<GalatiansModel> allChapters = GalatiansData.allChapter;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(pageStateProvider);
    return SingleChildScrollView(
      child: InteractiveViewer(
        child: Card(
          shadowColor: Colors.black26,
          elevation: 4,
          margin: EdgeInsets.all(12),
            child: Column(
              children: [
                Center(child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(allChapters[state].nId!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                )),
                Html(data: allChapters[state].commentary,),
              ],
            )),
      ),
    );
  }
}
