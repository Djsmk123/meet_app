import 'package:flutter/material.dart';
import 'package:meet_app/Models/users_models.dart';
import 'package:meet_app/screens/profile-screen/text_dat.dart';

import '../../constants.dart';
import '../../gen/assets.gen.dart';


class ProfileScreen extends StatefulWidget {
  final UserModel userModel;
  const ProfileScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final UserModel userModel=widget.userModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsSeeds.kPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Profile Screen",style:  TextStyle(
            color: Colors.white,
            fontSize: 16
        ),),

      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // starting for logo and name
            // end of logo and Name
            const SizedBox(height: 15,),
            // starting for profile image part
            Center(
              child: InkWell
                (
                child:Container(
                  height:100,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image:DecorationImage(
                        image:userModel.img!=null?NetworkImage(userModel.img!):Assets.images.appLogo.provider(),
                      )
                  ),
                ),
              ),
            ),
            // profile image done
            const SizedBox(height: 15,),
            TextData(
              text1: "Bio",
              text2: userModel.bio!,
            ),
            const SizedBox(height: 15,),
            //Bio container
            TextData(
              text1: "Name",
              text2: userModel.name
            ),
            // name field
            const SizedBox(height: 15,),
            TextData(
              text1: "Age",
              text2:userModel.age!=null?userModel.age.toString():"Not Given",
            ),
            const SizedBox(height: 15,),
            TextData(
              text1: "Phone Number",
              text2: userModel.phoneNumber!=null?userModel.phoneNumber.toString():"Not Given",
            ),
            const SizedBox(height: 15,),
            TextData(
              text1: "Skills",
              text2: userModel.skills.isNotEmpty?userModel.skills.toString().split(',').toString().replaceAll(RegExp(r'[^\w\s]+'), ""):"Not Given",
            ),

            const SizedBox(height: 15,),
            TextData(
              text1: "Job Title",
              text2: userModel.jobTitle!=null?userModel.jobTitle.toString():"Not Given",
            ),
            const SizedBox(height: 15,),
            if(userModel.profileLinks.isNotEmpty)
            TextData(
              text1: "Profile Links",
              text2: "",
            ),
            if(userModel.profileLinks.isNotEmpty)
            Column(
              children: List.generate(userModel.profileLinks.length, (index)=> Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Row(
                  children: [
                    Flexible(child: ListTile(
                      onTap: (){
                        launchUrlAsync(userModel.profileLinks[index].url);
                      },
                      leading: Icon(Icons.link_rounded,color: ColorsSeeds.kSecondaryColor,),
                      title: Text(userModel.profileLinks[index].label.toUpperCase(),style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),),
                      trailing: Icon(Icons.navigate_next,color: ColorsSeeds.kSecondaryColor,),
                    ))
                  ],
                ),
              ))
            )









          ],

        ),
      ),

    );
  }
}