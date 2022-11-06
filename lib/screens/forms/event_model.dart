import 'package:cloud_firestore/cloud_firestore.dart';

class EventsModal {
  final String? desc;
  final String? img;
  final String? id;
  final String? name;
  final List<Participants>? participants;
  final Timestamp? ts;
  final String? orgId;
  final String? orgName;
  final String? venue;

  EventsModal(this.orgId, {
    this.desc,
    this.img,
    this.id,
    this.name,
    this.participants,
    this.ts,
    this.orgName,
    this.venue
  });

  EventsModal.fromJson(Map<String, dynamic> json)
      : desc = json['desc'] as String?,
        img = json['img'] as String?,
        name = json['name'] as String?,
        orgId=json['orgId'] as String?,
        orgName=json['orgName'] as String?,
        venue=json['venue'] as String?,
        id=json['id'] as String?,
        participants = (json['participants'] as List?)?.map((dynamic e) => Participants.fromJson(e as Map<String,dynamic>)).toList(),
        ts = json['ts'] as Timestamp?;

  Map<String, dynamic> toJson() => {
    'desc' : desc,
    'img' : img,
    'name' : name,
    'participants' : participants?.map((e) => e.toJson()).toList(),
    'ts' : ts,
    'orgId':orgId,
    'orgName':orgName,
    'venue':venue,
    'id':id
  };
}

class Participants {
  final bool? isGoing;
  final String? userId;

  Participants({
    this.isGoing,
    this.userId,
  });

  Participants.fromJson(Map<String, dynamic> json)
      : isGoing = json['isGoing'] as bool?,
        userId = json['user_id'] as String?;

  Map<String, dynamic> toJson() => {
    'isGoing' : isGoing,
    'user_id' : userId
  };
}