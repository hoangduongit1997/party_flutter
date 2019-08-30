import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:zgadula/store/category.dart';
import 'package:zgadula/localizations.dart';
import '../shared/widgets.dart';

class CategoryFavoritesScreen extends StatefulWidget {
  @override
  CategoryFavoritesScreenState createState() {
    return new CategoryFavoritesScreenState();
  }
}

class CategoryFavoritesScreenState extends State<CategoryFavoritesScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<CategoryModel>(
          builder: (context, child, model) {
        if (model.favourites.isEmpty) {
          return Opacity(
            opacity: 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 96),
                  Container(
                    width: 160,
                    child: Text(
                      AppLocalizations.of(context).emptyFavorites,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return CategoryList(categories: model.favourites);
      }),
    );
  }
}
