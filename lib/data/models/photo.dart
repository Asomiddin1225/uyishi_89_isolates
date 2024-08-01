// To parse this JSON data, do
//
//     final photoModel = photoModelFromJson(jsonString);

import 'dart:convert';

PhotoModel photoModelFromJson(String str) =>
    PhotoModel.fromJson(json.decode(str));

String photoModelToJson(PhotoModel data) => json.encode(data.toJson());

class PhotoModel {
  String id;
  String type;
  Actor actor;
  Repo repo;
  Payload payload;
  bool public;
  DateTime createdAt;

  PhotoModel({
    required this.id,
    required this.type,
    required this.actor,
    required this.repo,
    required this.payload,
    required this.public,
    required this.createdAt,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) => PhotoModel(
        id: json["id"],
        type: json["type"],
        actor: Actor.fromJson(json["actor"]),
        repo: Repo.fromJson(json["repo"]),
        payload: Payload.fromJson(json["payload"]),
        public: json["public"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "actor": actor.toJson(),
        "repo": repo.toJson(),
        "payload": payload.toJson(),
        "public": public,
        "created_at": createdAt.toIso8601String(),
      };
}

class Actor {
  int id;
  String login;
  String gravatarId;
  String url;
  String avatarUrl;

  Actor({
    required this.id,
    required this.login,
    required this.gravatarId,
    required this.url,
    required this.avatarUrl,
  });

  factory Actor.fromJson(Map<String, dynamic> json) => Actor(
        id: json["id"],
        login: json["login"],
        gravatarId: json["gravatar_id"],
        url: json["url"],
        avatarUrl: json["avatar_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "login": login,
        "gravatar_id": gravatarId,
        "url": url,
        "avatar_url": avatarUrl,
      };
}

class Payload {
  String ref;
  String refType;
  String masterBranch;
  String description;
  String pusherType;

  Payload({
    required this.ref,
    required this.refType,
    required this.masterBranch,
    required this.description,
    required this.pusherType,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        ref: json["ref"] ?? '',
        refType: json["ref_type"] ?? '',
        masterBranch: json["master_branch"] ?? '',
        description: json["description"] ?? '',
        pusherType: json["pusher_type"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ref": ref,
        "ref_type": refType,
        "master_branch": masterBranch,
        "description": description,
        "pusher_type": pusherType,
      };
}

class Repo {
  int id;
  String name;
  String url;

  Repo({
    required this.id,
    required this.name,
    required this.url,
  });

  factory Repo.fromJson(Map<String, dynamic> json) => Repo(
        id: json["id"],
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
      };
}
