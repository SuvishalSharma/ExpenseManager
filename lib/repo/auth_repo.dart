// import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../core/result.dart';
import '../models/user.dart';
import 'mappers/user_mapper.dart';
class AuthRepo {
  final AppDatabase db;
  AuthRepo(this.db);

  // Future<Result<bool>> register(){}
  // Future<Result<User>> login(){}
  Future<Result<User>> getLoggedInUser() async{
    final users = await(db.select(db.userTable)..where((u)=>u.isLoggedIn.equals(true))).get();
    if(users.isEmpty) {return Result.success(null);}
    else if(users.length > 1)  {throw Exception('Data Corruption : Multiple users logged in');}  
   return Result.success(users.first.toDomain());
  // Future<Result<bool>> resetPassword(){}
  // Future<void> logout(){}



  }

}