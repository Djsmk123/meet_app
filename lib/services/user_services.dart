import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet_app/Models/users_models.dart';
import 'package:meet_app/models/collection.dart';
import 'package:http/http.dart' as http;
import 'package:meet_app/screens/forms/event_model.dart';
import 'package:meet_app/services/networking.dart';
class UserServices{
  static getUserProfileData(uid)async{
    var doc=await Collections().userData.doc(uid).get();
    return doc.data();
  }

  static Future<List<EventsModal>> getAllEvents()async{
    var doc=await Collections().eventData.get();
    List<EventsModal> events=[];
    for(var i in doc.docs)
      {
        Map<String,dynamic> tmp=i.data();
        tmp['id']=i.id;
        events.add(EventsModal.fromJson(tmp));
      }
    return events;
  }
  static  getAllRecommendations(uid,eventId)async{
   try{
     var res=await Networking.postRequest(endpoint: '/getRecommandation', body: {
       'uid':uid,
       'eventId':eventId,
     });
     List userIds=res['d'];
     return await getAllParticipantsProfile(userIds);
   }catch(e){
     log(e.toString());
     return Future.error("Something went wrong");
   }

  }
  static getReco()async {

  }
  static getAllParticipantsProfile(List<dynamic> usersId)async{
    List<UserModel> model=[];
    try{
      for(var i in usersId ){
        var userDoc=await getUserProfileData(i);
        UserModel userModel=UserModel.fromJson(userDoc);
        model.add(userModel);
      }
    }catch(e){
      log(e.toString());
      return Future.error(e.toString());
    }
    return model;
  }
  static checkInEvent(eventId,userId)async{
    await Collections().eventData.doc(eventId).update({
      'participants':FieldValue.arrayUnion([
        {
          'isGoing':true,
          'user_id':userId
        }
      ])
    });
    await Collections().userData.doc(userId).update({
      'events':FieldValue.arrayUnion([{
        'ts':Timestamp.now(),
        'isAttending':true,
        'id':eventId
      }])
    });
  }
}