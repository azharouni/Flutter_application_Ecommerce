import 'package:flutter/widgets.dart';
import 'package:flutterp/screens/ConfirmOrderPage/body.dart';
import 'package:flutterp/screens/DescriptionImage/DescriptionImage_scren.dart';
import 'package:flutterp/screens/Souscategoris_list/Souscategoris_list_scren.dart';
import 'package:flutterp/screens/SuccessCommand/body.dart';
import 'package:flutterp/screens/accountProfile/acountprofile_screen.dart';
import 'package:flutterp/screens/cart_list/cart_list_screen.dart';
import 'package:flutterp/screens/categorie_list/categorie_list_screen.dart';
import 'package:flutterp/screens/complete_profile/complete_profile_screen.dart';
import 'package:flutterp/screens/detailcommande/body.dart';
import 'package:flutterp/screens/edit_profil/edit_profilscreen.dart';
import 'package:flutterp/screens/favorie_list/favoorie_list_screen.dart';
import 'package:flutterp/screens/forgot_password/forgot_password_screen.dart';
import 'package:flutterp/screens/histriiquecommande/body.dart';
import 'package:flutterp/screens/login_success/login_success_screen.dart';
import 'package:flutterp/screens/passer_commande/passer_commande_scren.dart';
import 'package:flutterp/screens/produit_list/produit_list_screnn.dart';
import 'package:flutterp/screens/sign_in/sign_in_screen.dart';
import 'package:flutterp/screens/sign_up/sign_up_screen.dart';
import 'package:flutterp/screens/splach/splach_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplachScreen.routeName: (context) => const SplachScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  FavorieList.routeName: (context) => FavorieList(),
  CartList.routeName: (context) => CartList(),
  DescriptionImage.routeName: (context) => DescriptionImage(),
  CategoryListScreen.routeName: (context) => CategoryListScreen(),
  SousCategoriesList.routeName: (context) => SousCategoriesList(),
  ProduitListScrenn.routeName: (context) => ProduitListScrenn(),
  PasseCommande.routeName: (context) => PasseCommande(),
  Acountprofile.routeName: (context) => Acountprofile(),
  EditProfile.routeName: (context) => EditProfile(),
//  ConfirmOrderPage.routeName: (context) => ConfirmOrderPage(),
  // SuccessCommand.routeName: (context) => SuccessCommand(),

  // detailcommande.routeName: (context) => detailcommande(),

 // histriiquecommande.routeName: (context) => histriiquecommande(),
};
