import 'package:flutter/material.dart';

class DetailsCard extends StatelessWidget {
  final String title;
  final String ImageUrl;
  final VoidCallback onTap;
  final double height;
  final double width;
  final bool hideTitle;
  final EdgeInsetsGeometry? margin;

  const DetailsCard(
      {required this.title,
      required this.ImageUrl,
      required this.onTap,
      required this.height,
      required this.width,
      this.hideTitle = false,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: margin ?? EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(
            animationDuration: Duration(seconds: 2),
            child: InkWell(
              onTap: onTap,
              child: Stack(
                children: [
                  Ink(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(ImageUrl),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 8,
                      left: 10,
                      child: Text(
                        !hideTitle ? title : '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(
                                  1, 1), // Adjust the offset values as needed
                              blurRadius: 3, // Adjust the blur radius as needed
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//String imagePath = "your_firebase_storage_path/image.jpg"; // Replace with the path to your image in Firebase Storage
//
// // Fetch the Firebase Authentication user
// User? user = FirebaseAuth.instance.currentUser;
// if (user != null) {
//   // Get the Firebase Storage reference
//   firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);

//   // Generate a temporary download URL with Firebase Authentication credentials
//   String downloadURL = await ref.getDownloadURL();
  
//   // Use the generated download URL to load the image with Image.network() widget
//   Image.network(
//     downloadURL,
//     fit: BoxFit.cover,
//     width: 200,
//     height: 200,
//   ),
// } else {
//   // User is not signed in, handle accordingly
// }