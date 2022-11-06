import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:intl/intl.dart';
import 'package:meet_app/Models/users_models.dart';
import 'package:meet_app/constants.dart';

import 'package:meet_app/services/user_services.dart';

import '../../components/custom_drawer.dart';
import '../events_screen/events_screen.dart';
import '../forms/event_model.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  bool isLoading=true;
  List<EventsModal> topEvents=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();
  }
  initAsync()async {
    try{
      var doc=await UserServices.getUserProfileData(FirebaseAuth.instance.currentUser!.uid);
      LoggedInUserModel.userModel=UserModel.fromJson(doc);
      topEvents=await UserServices.getAllEvents();
    }catch(e){
      log(e.toString());
    }
    finally{
      setState(() {
        isLoading=false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
   /* List<EventsModal> topEvents=[
      EventsModal.fromJson({
        "desc":"Android Study Jams are community-organized study groups for people to learn how to build Android apps in the Kotlin programming language, using the curriculum provided by Google. This program is for people who are new to Android development and want to learn the best practices for how to build Android apps in Kotlin. There are two different tracks based on whether someone has prior programming experience or not. As always, you have the flexibility to adapt the level, format, duration, and other aspects of the agenda based on the needs of your community. The prerequisites are basic computer skills and basic math skills. You will be provided with access to a computer. You should bring a physical Android device and USB cable (to connect to the computer).",
        "img":"https://files.speakerdeck.com/presentations/31cbc7b5a7274158b97d4c231651f986/slide_0.jpg",
        "name":"Android Study Jams",
        "orgId":"CJ9BYD3XwxRw2VMbN4CbyyZPTRk1",
        'id':"92x0123op",
        "participants":[
          {
            "isGoing":true,
            'user_id':"180t44HgG7TKg4OCHUVIOtiaCxE3"
          }
        ],
        'ts':Timestamp.now(),
        "orgName":"Flutter New Delhi",
        'venue':"IGDTUW,New Delhi"
      }),
      EventsModal.fromJson({
        "desc":"Feeling social?   You can join us via Spatial Chat, and view the talks from there (and network with other attendees), or you can go direct to the links below!   The space is open from 9am to 6pm GMT.  Click here to enter the space.",
        "img":"https://static.wixstatic.com/media/1b14cf_2f5987c8e01a446fb9701ae352df1b67~mv2.png/v1/crop/x_259,y_0,w_482,h_635/fill/w_544,h_716,al_c,lg_1,q_90,enc_auto/Dashatars.png",
        "name":"Flutter Festivals",
        "orgId":"CJ9BYD3XwxRw2VMbN4CbyyZPTRk1",
        'id':"92x0123op",
        "participants":[
          {
            "isGoing":true,
            'user_id':"180t44HgG7TKg4OCHUVIOtiaCxE3"
          },
          {
            "isGoing":true,
            'user_id':"tvr5oC297tYeZWWbuvOPfgDgjOn1"
          }
        ],
        'ts':Timestamp.now(),
        "orgName":"Flutter New Delhi",
        'venue':"IGDTUW,New Delhi"
      }),

    ];*/
    return Scaffold(
      endDrawer:  !isLoading?EndDrawer(userModel: LoggedInUserModel.userModel):null,
      body: isLoading?Center(
     child:CircularProgressIndicator(
       color: ColorsSeeds.kPrimaryColor,
     )
    ):CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: ColorsSeeds.kPrimaryColor,
            toolbarHeight: 100,
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image:NetworkImage(
                    LoggedInUserModel.userModel.img!,
                  ),
                )
              ),

            ),
            title: Text(LoggedInUserModel.userModel.name,style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500
            ),),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu,color: Colors.white,),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              )
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text("Featured Events",style: TextStyle(
                            color: ColorsSeeds.kGreyColor,
                            fontSize: 20,
                          ),)
                        ],
                      ),
                    ),
                    CarouselSlider.builder(
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        var offer = topEvents[index];
                        return EventCard(offer: offer);
                      },
                      itemCount:topEvents.length,
                      options: CarouselOptions(
                        autoPlay: true,
                        pauseAutoPlayOnTouch: true,
                        height: 320,
                        autoPlayCurve: Curves.easeOutSine,
                        autoPlayInterval: const Duration(seconds: 2),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text("Events near you",style: TextStyle(
                            color: ColorsSeeds.kGreyColor,
                            fontSize: 20,
                          ),)
                        ],
                      ),
                    ),
                    CarouselSlider.builder(
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        var offer = topEvents[index];
                        return EventCard(offer: offer);
                      },
                      itemCount:topEvents.length,
                      options: CarouselOptions(
                        autoPlay: true,
                        pauseAutoPlayOnTouch: true,
                        height: 320,
                        autoPlayCurve: Curves.easeOutSine,
                        autoPlayInterval: const Duration(seconds: 2),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          )
        ],
    ));
  }
}
class EventCard extends StatelessWidget {
  final EventsModal offer;
  const EventCard({Key? key, required this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Bounce(
        duration:const Duration(milliseconds: 200),
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (builder)=>EventScreen(models: offer,)));
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height:200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(offer.img!)
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(offer.name!,style: TextStyle(
                        color: ColorsSeeds.kBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),),
                    Text('Registration ${offer.participants!.length.toString()}',style: TextStyle(
                        color: ColorsSeeds.kBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                    ),)
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(offer.venue!,style: TextStyle(
                        color: ColorsSeeds.kGreyColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),),
                    Text(DateFormat("dd-MM-yy hh:mm").format(offer.ts!.toDate()),style: TextStyle(
                        color: ColorsSeeds.kBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                    ),)
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

