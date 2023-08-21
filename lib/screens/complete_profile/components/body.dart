import 'package:flutter/material.dart';

import '../../../constant.dart';
import '../../../size_config.dart';
import 'complete_profile_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getSharedPrefValue("currentUser"),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading widget or placeholder while waiting for the value
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          // Access the shared preference variable here
          String sharedVariable = snapshot.data!;
          debugPrint(sharedVariable);
          // Use the sharedVariable in your widget tree
          return SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text("Profil complet", style: headingStyle),
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      Text(
                        "Complétez vos coordonnées ",
                        textAlign: TextAlign.center,
                      ),
                      /*     Text(
                          sharedVariable), // Display the shared preference variable */
                      SizedBox(height: SizeConfig.screenHeight * 0.06),
                      CompleteProfileScreen(),
                      SizedBox(height: getProportionateScreenHeight(30)),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          // Handle error if unable to retrieve shared preference value
          return Text('Error retrieving shared preference value');
        }
      },
    );
  }
}
