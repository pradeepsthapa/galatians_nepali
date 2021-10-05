import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class GalatiansModel extends Equatable{
  final int? eId;
  final String? nId;
  final String? commentary;

  GalatiansModel({@required this.eId, @required this.nId, @required this.commentary});

  @override
  List<Object?> get props => [eId,nId,commentary];
}