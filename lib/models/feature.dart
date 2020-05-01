
class Feature{
  final String featureName;
  final bool status;
  Feature(this.featureName,this.status);

  get name{
    return featureName;
  }

  get isSupported{
    return status;
  }

}