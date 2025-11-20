import 'package:equatable/equatable.dart';

abstract class StatusState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingStatusState extends StatusState{
  @override
  
  List<Object?> get props => [];
}

class ToggleStatusState extends StatusState{
final  bool isEnabled;
 ToggleStatusState(this.isEnabled);
@override

  List<Object?> get props => [isEnabled];
}