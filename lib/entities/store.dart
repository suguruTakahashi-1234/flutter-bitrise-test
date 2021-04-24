import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Store {
  int id;
  String name;
  bool isOpen;
  int currentCrowdStateRaw;
  CrowdState currentCrowdState;
  List<int> crowdStates;
  double latitude;
  double longitude;
  String imageUrl;
  double distance;

  Store(DocumentSnapshot doc) {
    id = doc.data()['id'];
    name = doc.data()['name'];
    isOpen = doc.data()['is_open'];
    currentCrowdStateRaw = doc.data()['current_crowd_state'];
    crowdStates = doc.data()['crowd_states'].cast<int>() as List<int>;
    latitude = doc.data()['latitude'];
    longitude = doc.data()['longitude'];
    imageUrl = doc.data()['image_url'];
  }

  String isOpenStr() {
    return isOpen ? 'OPEN' : 'CLOSED';
  }
}

enum CrowdState { closed, empty, littleCrowded, crowded }

extension CrowdStateExt on CrowdState {
  String get title {
    switch (this) {
      case CrowdState.closed:
        return '休';
        break;
      case CrowdState.empty:
        return '空き';
        break;
      case CrowdState.littleCrowded:
        return 'やや\n混雑';
        break;
      case CrowdState.crowded:
        return '混雑';
        break;
      default:
        return '';
        break;
    }
  }

  Color get color {
    switch (this) {
      case CrowdState.closed:
        return Color.fromRGBO(230, 230, 230, 1.0);
        break;
      case CrowdState.empty:
        return Color.fromRGBO(163, 186, 224, 1.0);
        break;
      case CrowdState.littleCrowded:
        return Color.fromRGBO(224, 224, 163, 1.0);
        break;
      case CrowdState.crowded:
        return Color.fromRGBO(224, 163, 170, 1.0);
        break;
      default:
        return Color.fromRGBO(230, 230, 230, 1.0);
        break;
    }
  }

  static CrowdState getCrowdState(int crowdStateRaw) {
    if (crowdStateRaw >= 5) {
      return CrowdState.crowded;
    }
    if (crowdStateRaw >= 3) {
      return CrowdState.littleCrowded;
    }
    if (crowdStateRaw >= 1) {
      return CrowdState.empty;
    }
    return CrowdState.closed;
  }
}
