
import 'package:shared_preferences/shared_preferences.dart';

void main() async {

  // Obtain shared preferences.
  final prefs = await SharedPreferences.getInstance();

  int startWrite = DateTime.now().millisecond;
  for(int i=0 ; i<10000 ; i++){
    await prefs.setString('counter$i', "ali:24:my job is writing codes");
  }
  int startRead = DateTime.now().millisecond;
  for(int i=0 ; i<10000 ; i++){
    final String? action = prefs.getString('counter$i');
  }
  int endRead = DateTime.now().millisecond;

  print("write time:${startRead-startWrite}");
  print("write time:${endRead-startRead}");
}