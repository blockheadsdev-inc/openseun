class Project {
  String id;
  String description;
  String location;
  double estimatedReductions;
  String category;
  String name;
  String type;
  String projectStatus;
  String walletStatus;

  Project(
      {this.description = '',
      this.location = '',
      this.estimatedReductions = 0,
      this.category = '',
      this.name = '',
      this.id = '',
      this.type = '',
      this.projectStatus = '',
      this.walletStatus = ''});
}
