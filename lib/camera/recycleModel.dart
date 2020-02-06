
class RecycleModel{
  List<String> displayHistory = ['No Recycle','Recycle','Council collect','Councile collect'];
  String commentCheck(int result) {
    if(result == 0){
      return 'this item can not be recycled';
    }
    if (result == 1) {
      return 'this item can be recycled';
    }
    if (result == 2) {
      return 'please contact local council for pick up or drop off';
    }
    if (result == 3) {
      return 'this is E-waste please contact local council for pick up or drop off';
    }
    return '';
  }

}
