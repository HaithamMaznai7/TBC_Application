import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tbc_application/app/model_example.dart';

class Point extends FirebaseModel<Point> {
  String? id;
  String title;
  String description;
  String? userImage;
  String? userNote;
  double? userRating;
  String? supervisorImage;
  String? supervisorNote;
  double? supervisorRating;
  PointStatus status;

  Point({
    this.id,
    this.title = '',
    this.description = '',
    this.userImage,
    this.userNote,
    this.userRating,
    this.supervisorImage,
    this.supervisorNote,
    this.supervisorRating,
    this.status = PointStatus.none,
  }) : super("inspection_points");

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userImage': userImage,
      'userNote': userNote,
      'userRating': userRating,
      'supervisorImage': supervisorImage,
      'supervisorNote': supervisorNote,
      'supervisorRating': supervisorRating,
      'status': status.toString(),
    };
  }

  @override
  Point fromCollection(String? id,Map<String, dynamic> json) {
    return Point(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      userImage: json['userImage'],
      userNote: json['userNote'],
      userRating: (json['userRating'] as num?)?.toDouble(),
      supervisorImage: json['supervisorImage'],
      supervisorNote: json['supervisorNote'],
      supervisorRating: (json['supervisorRating'] as num?)?.toDouble(),
      status: PointStatus.set(json['status']),
    );
  }
  
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userImage': userImage,
      'userNote': userNote,
      'userRating': userRating,
      'supervisorImage': supervisorImage,
      'supervisorNote': supervisorNote,
      'supervisorRating': supervisorRating,
      'status': status.toString(),
    };
  }
}

enum PointStatus{

  review,
  note,
  completed,
  none;

  @override
  toString(){
    switch (this) {
      case PointStatus.review:
        return 'Review';
      case PointStatus.note:
        return 'Note';
      case PointStatus.completed:
        return 'Completed';
      case PointStatus.none:
        return 'None';
    }
  }

  static PointStatus set(String? value){
    if(value == null) return PointStatus.none;
    switch (value) {
      case 'Review':
        return PointStatus.review;
      case 'Note':
        return PointStatus.note;
      case 'Completed':
        return PointStatus.completed;
      default:
        return PointStatus.none;
    }
  }
}