import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tbc_application/app/modules/schools/models/school_model.dart';

class SchoolCard extends StatelessWidget{

  School school;
  void Function(School value) onView;
  void Function(School value) onEdit;
  void Function(School value) onDelete;
  
  SchoolCard({
    super.key,
    required this.school,
    required this.onView,
    required this.onEdit,
    required this.onDelete
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${school.name}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Group: ${school.group}"),
            Text("Type: ${school.type.name}"),
            // FutureBuilder<Address?>(
            //   future: await school.address().get() ?, 
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return CircularProgressIndicator(); // أو Placeholder حسب الحاجة
            //     } else if (snapshot.hasError) {
            //       return Text("حدث خطأ في تحميل العنوان");
            //     } else if (!snapshot.hasData || snapshot.data == null) {
            //       return Text("لا يوجد عنوان متوفر");
            //     }

            //     final address = snapshot.data!;
            //     return Text("Address: address.mainAddress, ${address.cityID}");
            //   },
            // ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Iconsax.eye),
              onPressed: () => onView(school),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => onEdit(school),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => onDelete(school),
            ),
          ],
        ),
      ),
    );
  }
}