// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_app/constants.dart';
import 'package:meet_app/models/orgModel.dart';
import 'package:meet_app/screens/authentication/welcome_screen.dart';
import 'package:meet_app/services/logins_signup_services.dart';
import 'package:meet_app/services/org_services.dart';
import 'package:meet_app/services/user_services.dart';

import '../forms/event_model.dart';
import '../users-screens/user_home_screen.dart';

class OrgHomeScreen extends StatefulWidget {
  const OrgHomeScreen({Key? key}) : super(key: key);

  @override
  State<OrgHomeScreen> createState() => _OrgHomeScreenState();
}

class _OrgHomeScreenState extends State<OrgHomeScreen> {
  bool isLoading=true;
  List<EventsModal> events=[];
  List<EventsModal> upComingEvents=[];
  List<EventsModal> pastEvents=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();


  }
  initAsync()async{
    try{
      orgModel=OrgModel.fromJson(await OrgServices.fetchOrgDetails(FirebaseAuth.instance.currentUser!.uid));
      events=await UserServices.getAllEventOrg(orgModel.events!);
      for(var i in events)
        {
          if(DateTime.now().difference(i.ts!.toDate()).inDays<0)
            {
              pastEvents.add(i);
            }
          else{
            upComingEvents.add(i);
          }
        }
    }catch(e){
      log(e.toString());
    }finally{
      setState(() {
        isLoading=false;
      });
    }

  }
  @override
  Widget build(BuildContext context) {

    return !isLoading?Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {  },
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
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
                      orgModel.logo!
                    ),
                  )
              ),

            ),
            title: Text(orgModel.name!,style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500
            ),),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.logout,color: Colors.white,),
                  onPressed: () async {
                   try{
                     setState(() {
                       isLoading=true;
                     });
                     await Authentication().logOut();
                     Navigator.popUntil(context, (route) => false);
                     Navigator.push(context, MaterialPageRoute(builder: (builder)=>const WelcomeScreen()));
                   }catch(e){
                     log(e.toString());
                   }finally{
                     setState(() {
                       isLoading=false;
                     });
                   }
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
                    if(upComingEvents.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text("Up comings Events",style: TextStyle(
                            color: ColorsSeeds.kGreyColor,
                            fontSize: 20,
                          ),)
                        ],
                      ),
                    ),
                    if(upComingEvents.isNotEmpty)
                    CarouselSlider.builder(
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        var offer = upComingEvents[index];
                        return EventCard(offer: offer,isOrg: true,);
                      },
                      itemCount:upComingEvents.length,
                      options: CarouselOptions(
                        autoPlay: true,
                        pauseAutoPlayOnTouch: true,
                        height: 320,
                        autoPlayCurve: Curves.easeOutSine,
                        autoPlayInterval: const Duration(seconds: 2),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    if(pastEvents.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text("Past Event",style: TextStyle(
                            color: ColorsSeeds.kGreyColor,
                            fontSize: 20,
                          ),)
                        ],
                      ),
                    ),
                    if(pastEvents.isNotEmpty)
                    CarouselSlider.builder(
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        var offer = pastEvents[index];
                        return EventCard(offer: offer,isOrg:true,);
                      },
                      itemCount:pastEvents.length,
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
      ),
    ):Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: ColorsSeeds.kPrimaryColor,
        ),
      ),
    );
  }
}
