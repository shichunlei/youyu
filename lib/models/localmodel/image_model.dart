enum ImageModelType { normal, add, sub }

class ImageModel {
  ImageModel(
      {this.type = ImageModelType.normal,
      this.imageId,
      required this.imageUrl,
      this.ext});

  final int? imageId;
  final String imageUrl;
  final ImageModelType type;
  dynamic ext;

  static ImageModel fromJson(Map<String, dynamic> json) => ImageModel(
      imageId: json['imageId'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String,
      type: ImageModelType.normal);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'imageId': imageId,
        'imageUrl': imageUrl,
      };
}
