class PreferencesModel {
  int? id;
  String? title;
  String? createdAt;
  String? updatedAt;
  bool? isSelected;
  List<PreferencesModel>? preferences;

  PreferencesModel(
      {this.id,
        this.title,
        this.createdAt,
        this.updatedAt,
        this.preferences,
        this.isSelected = false});

  PreferencesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['created_at'];
    isSelected = false;
    updatedAt = json['updated_at'];
    if (json['preferences'] != null) {
      preferences = <PreferencesModel>[];
      json['preferences'].forEach((v) {
        preferences!.add(PreferencesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (preferences != null) {
      data['preferences'] = preferences!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}