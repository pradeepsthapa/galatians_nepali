import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galatians_nepali/data/menu_item.dart';
import 'package:galatians_nepali/data/model.dart';
import 'package:galatians_nepali/data/model_data.dart';
import 'package:galatians_nepali/logics/providers.dart';
import 'package:galatians_nepali/presentation/screens/chapter_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(context, watch) {
    final isDark = watch(themeStateProvider);
    return MaterialApp(
      themeMode: isDark?ThemeMode.dark:ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        fontFamily: GoogleFonts.sourceSansPro().fontFamily,
        primarySwatch: Colors.teal,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {

  final List<GalatiansModel> allChapters = GalatiansData.allChapter;

  static const List<MenuItem> menuItems = [
    MenuItem(text: 'About', icon: Icons.person,),
    MenuItem(text: 'Share', icon: Icons.share,),
    MenuItem(text: 'More Apps', icon: Icons.apps,),
    MenuItem(text: 'Exit', icon: Icons.exit_to_app_rounded,),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark?null:Colors.white.withOpacity(0.9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          title: Row(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("गलातीको पुस्तक",style: TextStyle(fontWeight: FontWeight.bold),),
              Spacer(),
              Consumer(builder: ( context, watch, child) {
                final state = watch(pageStateProvider);
                return DropdownButton<String>(
                  dropdownColor: isDark?Theme.of(context).cardColor:Theme.of(context).primaryColor,
                    value: allChapters[state].nId,
                    style: TextStyle(color: Colors.white),
                    underline: Container(),
                    iconEnabledColor: Colors.white,
                    onChanged: (String? item){
                      context.read(pageStateProvider.notifier).changePage(allChapters.indexOf(allChapters.firstWhere((element) => element.nId==item)));
                    },
                    items:allChapters.map((e) => DropdownMenuItem<String>(
                        value: e.nId,
                        child: Text(e.nId!,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),))).toList());
              },),

            ],
          ),
          actions: [
            IconButton(
                onPressed: ()=>context.read(themeStateProvider.notifier).toggleDark(),
                icon: Icon(Icons.brightness_4,size: 20,)),
            PopupMenuButton<MenuItem>(
              padding: EdgeInsets.only(right: 8),
              iconSize: 20,
              offset: Offset(0,50),
              onSelected: (MenuItem item){
                switch(item.text){
                  case 'About':
                    dialogBox(context);
                    break;
                  case 'Share':
                    share(context);
                    break;
                  case 'More Apps':
                    openStoreLink();
                    break;
                  case 'Exit':
                    SystemNavigator.pop();
                    break;
                }
              },
              itemBuilder: (BuildContext context)=>menuItems.map((e) => PopupMenuItem<MenuItem>(
                value: e,
                  child: Row(
                    children: [
                      Icon(e.icon,color: isDark?Colors.white:Colors.black,size: 20,),
                      SizedBox(width: 7,),
                      Text(e.text!,),
                    ],
                  ))).toList()
              ,)
          ],
        ),
      ),
      body: ChapterScreen(),
    );
  }

  void share(BuildContext context) {
    final String text = 'https://play.google.com/store/apps/details?id=com.ccbc.galatians_nepali.galatians_nepali';
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    Share.share(text,sharePositionOrigin: renderBox.localToGlobal(Offset.zero)&renderBox.size);
  }

  void dialogBox(BuildContext context) {

    showGeneralDialog(context: context,
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black45,
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (context,a1,a2){
      return AlertDialog(
        content: Text("यस पुस्तकमा विभिन्न लेखक र टिप्पणीकारहरुका भनाई पनि उल्लेख छ । यस पुस्कतप्रति तपाईको केही सल्लाह वा जिज्ञासा भए कृपया प्रतिकृया दिनुहोला । यसमा केही भुल वा कमजोरी भए सच्याउनको निम्ति अनुरोध गर्नुहोला । परमेश्वरले तपाईहरु सबैलाई आशिष् दिनुभएको होस् ।"),
      );
        });
  }

  void openStoreLink() async{
    const url = 'https://play.google.com/store/apps/developer?id=pTech';
    if(await canLaunch(url)){
      await launch(url);
    }
    else{
      throw 'Could not launch $url';
    }
  }
}

