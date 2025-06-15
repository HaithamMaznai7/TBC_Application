import 'package:flutter/material.dart';
import 'package:tbc_application/app/modules/uesrs/models/user.dart';
import 'package:tbc_application/app/modules/users/models/users.dart';
import 'package:tbc_application/util/constants/colors.dart';

class UserCard extends StatelessWidget{
  final Employee user;
  final void Function(Employee user) onEdit;
  final void Function(Employee user) onDelete;

  const UserCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: FColors.grey,
          child: ClipOval(
            child: Image.network(
              (user.avatar == null || user.avatar == "") ? "https://ui-avatars.com/api/?name=${user.fullname}&color=00f" : user.avatar!,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text('${user.fullname}'),
        subtitle: Text("${user.email}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => onEdit(user),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => onDelete(user),
            ),
          ],
        ),
      ),
    );
  }
}