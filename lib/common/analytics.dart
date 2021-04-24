import 'package:pre_order_flutter_app/main.dart';

class Analytics {
  static String _isEventType;

  // Firebase Analyticsへ飛ばすlogEvent
  static Future analyticsLogEvent(
    AnalyticsEventType eventType,
    Map<String, dynamic> parameterMap,
  ) async {
    _isEventType = await _enumToString(eventType);
    await analytics.logEvent(
      name: _isEventType,
      parameters: parameterMap,
    );
    print('Send Firebase Analytics: $_isEventType');
  }

  static Future _enumToString(eventType) async {
    return eventType.toString().split('.')[1];
  }
}

enum AnalyticsEventType {
  logout,
}
