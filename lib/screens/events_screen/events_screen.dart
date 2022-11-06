import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:meet_app/models/user_model_new.dart';

import 'package:meet_app/screens/forms/event_model.dart';

import 'package:meet_app/services/user_services.dart';

import '../../constants.dart';
import '../../gen/assets.gen.dart';
import '../profile-screen/profile_screen.dart';

class EventScreen extends StatefulWidget {
  final EventsModal models;
  final bool isOrg;
  const EventScreen({Key? key, required this.models, required this.isOrg}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late final  EventsModal model;
  List<UserModel> participantsModels=[];
  bool isRegistered=false;
  List<String> participantsIds=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    model=widget.models;
    if(!widget.isOrg) {
      isRegistered=model.participants!.contains(Participants.fromJson({
      'isGoing':true,
      'user_id':FirebaseAuth.instance.currentUser!.uid
    }));
    }
    for(var i in model.participants!)
      {if(i.isGoing! && i.userId!=FirebaseAuth.instance.currentUser!.uid) {
          participantsIds.add(i.userId!);
        }}
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
     /*Collections().userData.get().then((value){
       int i=0;
       for(var iterator in value.docs)
         { i++;
           if(i!=10) {
             Collections().eventData.doc('92x0123op').update({
             'participants':FieldValue.arrayUnion([{
               'isGoing':true,
               'user_id':iterator.id
             }])
           });
           }
           else {
             break;
           }
         }
     });*/
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsSeeds.kPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(model.name!,style: const TextStyle(
          color: Colors.white,
          fontSize: 16
        ),),

      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(model.img!)
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(model.venue!,style: TextStyle(
                      color: ColorsSeeds.kGreyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                  ),),
                  Text(DateFormat("dd-MM-yy hh:mm ").format(model.ts!.toDate()),style: TextStyle(
                      color: ColorsSeeds.kBlackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                  ),)
                ],
              ),
            ),
             Padding(
              padding:  const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    flex:2,
                    child: Text("About Event",style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  if(!isRegistered && !widget.isOrg)
                    Flexible(

                       child: ListTile(
                         onTap: () async {
                           try{
                             await UserServices.checkInEvent(model.id, FirebaseAuth.instance.currentUser!.uid);
                             Fluttertoast.showToast(msg: "Checked In");
                             setState(() {
                               isRegistered=true;
                             });
                           }catch(e){
                             Fluttertoast.showToast(msg: "Something went wrong");
                           }

                         },
                     contentPadding: EdgeInsets.zero,
                     horizontalTitleGap: 5,
                     leading: const Text("Check-In",style:TextStyle(
                         color: Colors.red,
                         fontSize: 20,
                         fontWeight: FontWeight.w500
                     ),),
                     title: const Icon(Icons.navigate_next,color: Colors.blueAccent,),
                   ))
                ],
              ),
            ),
            Padding(padding:const EdgeInsets.all(10),child:Text(model.desc!,style: TextStyle(
              color: Colors.grey.withOpacity(0.8),
              fontSize: 14
            ),),),
            const Padding(
              padding:  EdgeInsets.all(10),
              child: Text("Participants",style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),
            ),
            if(!widget.isOrg)
            const Padding(
              padding:  EdgeInsets.all(10),
              child: Text("Recommendations for you ",style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),),
            ),
            if(!widget.isOrg)
            FutureBuilder(
              builder: (context,snapshot){
                if(snapshot.hasError)
                {
                  return const Center(child: Text("Something went wrong"));
                }
                if(snapshot.hasData)
                {
                  dynamic model=snapshot.data! as List<UserModel>;
                  return UserListWidget(model: model,);
                }
                return const Card();
              },
              future:UserServices.getAllRecommendations(FirebaseAuth.instance.currentUser!.uid,model.id),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 2,
            ),
            FutureBuilder(
              builder: (context,snapshot){
                if(snapshot.hasError)
                  {
                    return const Center(child: Text("Something went wrong"));
                  }
                if(snapshot.hasData)
                  {
                    dynamic model=snapshot.data! as List<UserModel>;
                    return UserListWidget(model: model,);
                  }
                return const Card();
              },
              future:UserServices.getAllParticipantsProfile(participantsIds),
            ),


          ],
        ),
      ),
    );
  }
}
class UserListWidget extends StatelessWidget {
  final List<UserModel> model;
  const UserListWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: model.length,
        shrinkWrap: true,
        itemBuilder: (context,index) {
          UserModel item=model[index];
          return Card(
            elevation: 5,
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex:2,
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            height:80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image:DecorationImage(
                                  image:item.img!=null?NetworkImage(item.img!):Assets.images.appLogo.provider(),
                                )
                            ),
                          ),
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name,style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),),
                              Text(item.jobTitle!,style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14
                              ),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(

                      child: IconButton(icon: Icon(Icons.navigate_next,size: 30,color: ColorsSeeds.kPrimaryColor,),onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>ProfileScreen(userModel: item)));
                      },))
                ],
              ),
            ),
          );
        }
    );
  }
}
