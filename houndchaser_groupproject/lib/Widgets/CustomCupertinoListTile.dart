import 'package:flutter/cupertino.dart';

class CustomCupertinoListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomCupertinoListTile({super.key, 
    required this.title,
    required this.onTap,
  });

  //Mimics a material ListTile for pet_list
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CupertinoColors.separator, width: 0.0)),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: CupertinoTheme.of(context).textTheme.textStyle),
            const Icon(CupertinoIcons.forward, color: CupertinoColors.systemGrey),
          ],
        ),
      ),
    );
  }
}
