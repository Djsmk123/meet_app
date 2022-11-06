import 'package:meet_app/models/collection.dart';

class OrgServices{
  static Future fetchOrgDetails(userId)async{
    var data=await Collections().org.doc(userId).get();
    return data.data();
  }
}