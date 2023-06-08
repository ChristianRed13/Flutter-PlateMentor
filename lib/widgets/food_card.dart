import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:plate_mentor/repository/user_repository.dart';

import '../blocs/bloc_exports.dart';
import '../blocs/user_bloc/user_bloc.dart';
import '../widgets/category_circle_item.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';

class FoodCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onTap;
  final VoidCallback onTapFavorites;
  final List<Category> categories;
  final IconData icon;

  const FoodCard(
      {required this.name,
      required this.imageUrl,
      required this.categories,
      required this.onTap,
      required this.onTapFavorites,
      required this.icon});

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserBloc(userRepository: UserRepository(getStorage: GetStorage())),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Positioned(
                        right: 5,
                        child: InkWell(
                          onTap: onTapFavorites,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              icon,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.height * 0.04,
                            ),
                          ),
                        ),
                      ),
                      Ink(
                        height: MediaQuery.of(context).size.height * 0.14,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(imageUrl),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.042,
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Ink(
                    height: MediaQuery.of(context).size.height * 0.038,
                    padding: EdgeInsets.only(left: 10, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: categories
                          .map((category) => Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: CategoryCircleIcon(
                                  size:
                                      MediaQuery.of(context).size.height * 0.03,
                                  color: category.color,
                                  iconData: category.imageUrl,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
