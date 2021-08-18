class TileModel {
  String imageAssetPath;
  bool isSelected;

  TileModel({required this.imageAssetPath, required this.isSelected});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setisSelected(bool getIsSelected) {
    isSelected = getIsSelected;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  bool getisSelected() {
    return isSelected;
  }
}
