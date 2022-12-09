class Bus{
  late String VehicleId;
  late String id;
  Bus(){
    VehicleId = "";
    id = "";
  }

  Bus.namedConst(String vid, String id){
    this.VehicleId = vid;
    this.id = id;
  }

  Bus.fromJson(Map<String, dynamic> json)
  : VehicleId = json['vid'],
    id = json['uid'];

  Map<String, dynamic> toJson() => {
    'vid':VehicleId,
    'uid':id, };

  getVid(){
    return this.VehicleId;
  }
  getUid(){
    return this.id;
  }
}