import 'package:contact_dairy/controller/bottonbarprovider.dart';
import 'package:contact_dairy/controller/contact_provider.dart';
import 'package:contact_dairy/controller/contactlist_provider.dart';
import 'package:contact_dairy/controller/pageprovider.dart';
import 'package:contact_dairy/controller/plateformconvter.dart';
import 'package:contact_dairy/controller/theme_provider.dart';
import 'package:contact_dairy/view/android/add_contacts.dart';
import 'package:contact_dairy/view/android/details.dart';
import 'package:contact_dairy/view/android/homepage.dart';
import 'package:contact_dairy/view/android/indexstack/settings.dart';
import 'package:contact_dairy/view/ios/home.dart';
import 'package:contact_dairy/view/ios/nextpage.dart';
import 'package:contact_dairy/view/ios/profile.dart';
import 'package:contact_dairy/view/theme/dark.dart';
import 'package:contact_dairy/view/theme/light.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return ContactProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (context) => ContactListProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider()..gettheme(),
        ),
        ChangeNotifierProvider(
          create: (context) => PageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlateFormCovter(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomBar(),
        ),
      ],
      builder: (context, child) {
        return Consumer<ThemeProvider>(
          builder: (BuildContext context, theme, Widget? child) {
            var ios = Provider.of<PlateFormCovter>(context).isIos;
            if (ios) {
              return MaterialApp(
                initialRoute: "/",
                debugShowCheckedModeBanner: false,
                theme: light,
                darkTheme: dark,
                themeMode: theme.thememode,
                routes: {
                  "/": (context) => const Homepage(),
                  "AddContact": (context) => const AddContact(),
                  "Settings": (context) => Settings(),
                  "ShowDetails": (context) => ShowDetails(),
                },
              );
            } else {
              return Consumer<ThemeProvider>(
                builder: (BuildContext context, theme, Widget? child) {
                  return CupertinoApp(
                    initialRoute: '/',
                    debugShowCheckedModeBanner: false,
                    theme: CupertinoThemeData(
                        brightness:
                            theme.isDark ? Brightness.dark : Brightness.light),
                    // home: Home(),
                    routes: {
                      "/": (p0) => Home(),
                      "Profile": (p0) => Profile(),
                      "NextPage": (p0) => NextPage(),
                    },
                  );
                },
              );
            }
          },
        );
      },
    );
  }
}
//Provider.of<Themeprovider1>(context).themeData ==
//AppTheme.system
//? ThemeMode.system
//  : Provider.of<Themeprovider1>(context).themeData == AppTheme.light
//? ThemeMode.light
//: ThemeMode.dark,
