class Liked {
  Liked({
    required this.id,
    required this.title,
    required this.description,
    required this.quantity,
    required this.companyId,
    required this.jobPositionId,
    required this.workingStyleId,
    required this.workingPlace,
  });

  String id;
  String title;
  String description;
  int quantity;
  String companyId;
  String jobPositionId;
  String workingStyleId;
  String workingPlace;

  factory Liked.fromJson(Map<String, dynamic> json) => Liked(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        quantity: json["quantity"],
        companyId: json["company_id"],
        jobPositionId: json["job_position_id"],
        workingStyleId: json["working_style_id"],
        workingPlace: json["working_place"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "quantity": quantity,
        "company_id": companyId,
        "job_position_id": jobPositionId,
        "working_style_id": workingStyleId,
        "working_place": workingPlace,
      };
}
