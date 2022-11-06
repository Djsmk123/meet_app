// ignore_for_file: file_names

class OrgModel {
  String? address;
  String? contactNo;
  List<String>? events;
  String? lead;
  String? name;
  String? website;
  String? logo;

  OrgModel(
      {this.address,
        this.contactNo,
        this.events,
        this.lead,
        this.name,
        this.website,
        this.logo});

  OrgModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    contactNo = json['contactNo'];
    events = json['events'].cast<String>();
    lead = json['lead'];
    name = json['name'];
    website = json['website'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['contactNo'] = contactNo;
    data['events'] = events;
    data['lead'] = lead;
    data['name'] = name;
    data['website'] = website;
    data['logo'] = logo;
    return data;
  }
}