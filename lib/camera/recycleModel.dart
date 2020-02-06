
class RecycleModel{
  List<String> displayHistory = ['No Recyclable','Recyclable','Council collect','Council collect'];
  String commentCheck(int result) {
    if(result == 0){
      return 'this item can not be recycled';
    }
    if (result == 1) {
      return 'This item can be recyclable';
    }
    if (result == 2) {
      return 'Please contact local council for pick up or drop off';
    }
    if (result == 3) {
      return 'This is an E-waste please contact local council for pick up or drop off';
    }
    return '';
  }

}
