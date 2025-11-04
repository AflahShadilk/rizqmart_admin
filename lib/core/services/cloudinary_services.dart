 
 import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart'as http;

Future<String?>uploadToCloudinary(FilePickerResult? filePickerResult)async{
  if(filePickerResult==null||filePickerResult.files.isEmpty){

    return null;
  }
  final bytes=filePickerResult.files.single.bytes;
  final fileName=filePickerResult.files.single.name;
  if(bytes==null)return null;


  String cloudName=dotenv.env['CLOUDINARY_CLOUD_NAME']??'';
  String preset=dotenv.env['PRESET_NAME']??'';

  var uri=Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
  var request=http.MultipartRequest("POST",uri);
  request.fields['upload_preset']=preset;
  
  

  request.files.add(http.MultipartFile.fromBytes('file',bytes,filename: fileName));
  
  var response= await request.send();
  
  var responseBody= await response.stream.bytesToString();

  if(response.statusCode==200){
    final data=jsonDecode(responseBody);
    return data['secure_url'];
   
  }else{
    return null;
  }

}