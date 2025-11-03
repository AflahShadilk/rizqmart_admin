import 'package:equatable/equatable.dart';

 class CategoryModel extends Equatable{
  final String id;
  final String name;
  final String? logoUrl;
  final List<String>?variants;
const  CategoryModel({required this.id,required this.name,this.logoUrl , this.variants});
@override
 
  List<Object?> get props => [id,name,logoUrl,variants];
}