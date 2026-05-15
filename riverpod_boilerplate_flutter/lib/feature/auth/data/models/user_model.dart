class UserModel {
  int? id;
  String? name;
  String? email;
  String? dob;
  int? type;
  int? is_profile_complete;
  int? is_prefrences;
  String? deviceToken;
  String? deviceType;
  String? gender;
  int? isNotification;
  int? userLoginType;
  int? status;
  String? address;
  String? profilePic;
  String? googleId;
  String? facebookId;
  String? appleId;
  String? socialType;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? baseUrl;
  String? token;
  String? country_code;
  String? phone_no;
  String? social_id;
  UserModel? user;

  UserModel(
      {this.id,
        this.name,
        this.email,
        this.dob,
        this.token,
        this.type,
        this.deviceToken,
        this.deviceType,
        this.gender,
        this.isNotification,
        this.userLoginType,
        this.status,
        this.address,
        this.profilePic,
        this.googleId,
        this.facebookId,
        this.appleId,
        this.socialType,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.baseUrl,
        this.user,
        this.is_prefrences,
        this.social_id,
        this.is_profile_complete,
        this.country_code,
        this.phone_no});

  UserModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    dob = json['dob'];
    social_id = json['social_id'];
    is_prefrences = json['is_prefrences'];
    is_profile_complete = json['is_profile_complete'];
    type = json['type'];
    deviceToken = json['device_token'];
    country_code = json['country_code'];
    phone_no = json['phone_no'];
    token = json['token'];
    deviceType = json['device_type'];
    gender = json['gender'];
    isNotification = json['is_notification'];
    userLoginType = json['user_login_type'];
    status = json['status'];
    address = json['address'];
    profilePic = json['profile_pic'];
    googleId = json['google_id'];
    facebookId = json['facebook_id'];
    appleId = json['apple_id'];
    socialType = json['social_type'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    baseUrl = json['baseUrl'];
    user = json["user"] == null ? null : UserModel.fromJson(json["user"]);
  }

  Map<String, dynamic> toJson() {
    final val = <String, dynamic>{};
    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('id', id);
    writeNotNull('name', name);
    writeNotNull('phone_no', phone_no);
    writeNotNull('country_code', country_code);
    writeNotNull('email', email);
    writeNotNull('is_profile_complete', is_profile_complete);
    writeNotNull('social_id', social_id);
    writeNotNull('is_prefrences', is_prefrences);
    writeNotNull('dob', dob);
    writeNotNull('token', token);
    writeNotNull('type', type);
    writeNotNull('device_token', deviceToken);
    writeNotNull('device_type', deviceType);
    writeNotNull('gender', gender);
    writeNotNull('is_notification', isNotification);
    writeNotNull('user_login_type', userLoginType);
    writeNotNull('status', status);
    writeNotNull('address', address);
    writeNotNull('profile_pic', profilePic);
    writeNotNull('google_id', googleId);
    writeNotNull('facebook_id', facebookId);
    writeNotNull('apple_id', appleId);
    writeNotNull('social_type', socialType);
    writeNotNull('email_verified_at', emailVerifiedAt);
    writeNotNull('created_at', createdAt);
    writeNotNull('updated_at', updatedAt);
    writeNotNull('baseUrl', baseUrl);
    writeNotNull('user', user?.toJson());
    return val;
  }
}