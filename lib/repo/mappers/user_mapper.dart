import '../../database/app_database.dart';
import '../../models/user.dart';

extension UserTableDataMapper on UserTableData {
  User toDomain() {
    return User(
      id: id,
      name: name,
      email: email,
      phone: phone,
      isLoggedIn: isLoggedIn,
      createdAt: createdAt,
    );
  }
}
