import 'package:cloud_firestore/cloud_firestore.dart';

import 'address_model.dart';

const String userId = 'uid';
const String userName = 'name';
const String userEmail = 'email';
const String userMobile = 'mobile';
const String userImage = 'image';
const String userDeviceToken = 'deviceToken';
const String userCreationTime = 'creationTime';
const String userAddress = 'addressModel';

class UserModel {
  String uid, email;
  String? name, mobile, image, deviceToken;
  Timestamp creationTime;
  AddressModel? addressModel;

  UserModel({
    required this.uid,
    this.name,
    required this.email,
    this.mobile,
    this.image,
    this.deviceToken,
    required this.creationTime,
    this.addressModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      userId: uid,
      userName: name,
      userEmail: email,
      userMobile: mobile,
      userImage: image,
      userDeviceToken: deviceToken,
      userCreationTime: creationTime,
      userAddress : addressModel?.toMap(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
      uid: map[userId],
      name: map[userName],
      email: map[userEmail],
      mobile: map[userMobile],
      image: map[userImage],
      deviceToken: map[userDeviceToken],
      creationTime: map[userCreationTime],
      addressModel: AddressModel.fromMap(map[userAddress]),
  );

}
