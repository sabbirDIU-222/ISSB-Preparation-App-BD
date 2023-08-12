import 'package:shared_preferences/shared_preferences.dart';

class LocalDb{

 static final uIdKey = 'fdfgsafgaug';


 static Future<bool> savedUserId(String uid)async{
   SharedPreferences preferences =await SharedPreferences.getInstance();
   return await preferences.setString(uIdKey, uid);
 }

 static Future<String?> getUserId() async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return await preferences.getString(uIdKey);
 }

}