import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:intl/intl.dart';
import 'package:meet_app/constants.dart';
import 'package:meet_app/models/user_model_new.dart';
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
      userModel=UserModel.fromJson(doc);
      topEvents=await UserServices.getAllEvents();
      setState(() {
        isLoading=false;
      });
    }catch(e){
      log(e.toString());
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:  !isLoading && userModel!=null?const EndDrawer():null,
      body: isLoading && userModel==null?Center(
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
                    userModel!.img!,
                  ),
                )
              ),

            ),
            title: Text(userModel!.name,style: const TextStyle(
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
                        return EventCard(offer: offer,isOrg:false,);
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
                        return EventCard(offer: offer,isOrg:false,);
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
  final bool isOrg;
  const EventCard({Key? key, required this.offer, required this.isOrg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Bounce(
        duration:const Duration(milliseconds: 200),
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (builder)=>EventScreen(models: offer,isOrg: isOrg,)));
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

