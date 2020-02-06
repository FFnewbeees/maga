
class RecycleModel{
  List<String> displayHistory = ['Not Recyclable','Recyclable','Council Collect','Council Collect'];
  String commentCheck(int result) {
    if(result == 0){
      return 'This item can not be recycled';
    }
    if (result == 1) {
      return 'This item can be recycled';
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
