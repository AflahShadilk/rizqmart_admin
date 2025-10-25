String? nameFieldValidator(String? value){
  if(value==null||value.trim().isEmpty){
    return 'Name field required';
  }
  final name=value.trim();
  if(name.length<2)return 'Name should have atleast 2 letters';
  final reg= RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ'’\-\.\s]{2,50}$");
  if(!reg.hasMatch(name)){
    return 'Name contains invalid characters';
  }
  return null;
}