class PublishResponse {
  String message;

  PublishResponse({this.message});

  factory PublishResponse.fromJson(Map<String, dynamic> json) {
    return PublishResponse(
      message: json['message'],
    );
  }
}
