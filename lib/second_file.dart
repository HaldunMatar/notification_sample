import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider/notification_provider.dart';

class SecondPage extends ConsumerWidget  {
  
  const SecondPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     
      final  todos = ref.watch(notificationProvider);
     // todos.set();

  
      return 
      Scaffold(
        appBar: AppBar(),
            body: Container(height: 700, width: 400,
            
            color:Colors.yellow
            ),
         );

  }

}