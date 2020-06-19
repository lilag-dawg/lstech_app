class Feature {
  final String featureName;
  final bool status;
  final int value;
  Feature({this.featureName, this.status, this.value});

  get name {
    return featureName;
  }

  get isSupported {
    return status;
  }

  get valueContent {
    return value;
  }
}
