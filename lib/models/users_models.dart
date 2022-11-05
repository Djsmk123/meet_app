import 'package:cloud_firestore/cloud_firestore.dart';


class MemberModel {
  Map info = {
    'name': "",
    'phno': 0,
    'title': "",
    "comments": "",
    'em': ""
  };
}

class UserModel {
  UserModel({
    required this.age,
    required this.bio,
    required this.email,
    required this.img,
    required this.jobTitle,
    required this.name,
    required this.phoneNumber,
    required this.profileLinks,
    required this.skills,
  });
  late final int age;
  late final String bio;
  late final String email;
  late final String img;
  late final String jobTitle;
  late final String name;
  late final String phoneNumber;
  late final List<ProfileLinks> profileLinks;
  late final List<RegisterEventModel> events;
  late final List<String> skills;

  UserModel.fromJson(Map<String, dynamic> json){
    age = json['age'];
    bio = json['bio'];
    email = json['email'];
    img = json['img'];
    jobTitle = json['job_title'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    profileLinks = List.from(json['profile_links']).map((e)=>ProfileLinks.fromJson(e)).toList();
    events = List.from(json['events']).map((e)=>RegisterEventModel.fromJson(e)).toList();
    skills = List.castFrom<dynamic, String>(json['skills']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['age'] = age;
    data['bio'] = bio;
    data['email'] = email;
    data['img'] = img;
    data['job_title'] = jobTitle;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['profile_links'] = profileLinks.map((e)=>e.toJson()).toList();
    data['skills'] = skills;
    return data;
  }
}

class ProfileLinks {
  ProfileLinks({
    required this.isVisible,
    required this.label,
    required this.url,
  });
  late final bool isVisible;
  late final String label;
  late final String url;

  ProfileLinks.fromJson(Map<String, dynamic> json){
    isVisible = json['is_visible'];
    label = json['label'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['is_visible'] = isVisible;
    data['label'] = label;
    data['url'] = url;
    return data;
  }
}

class RegisterEventModel{
  late final String id;
  late final String isAttending;
  late final Timestamp ts;
  RegisterEventModel.fromJson(Map<String, dynamic> json){
    id=json['id'];
    isAttending=json['isAttending'];
    ts=json['ts'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id']=id;
    data['isAttending']=isAttending;
    data['ts']=ts;
    return data;
  }
}

