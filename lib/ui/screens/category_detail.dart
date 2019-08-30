import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:zgadula/models/category.dart';
import 'package:zgadula/services/analytics.dart';

import 'package:zgadula/localizations.dart';
import 'package:zgadula/store/category.dart';
import 'package:zgadula/store/settings.dart';
import 'package:zgadula/ui/templates/back_template.dart';
import 'package:zgadula/ui/theme.dart';
import '../shared/widgets.dart';

class CategoryDetailScreen extends StatefulWidget {
  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  Widget buildFavorite({bool isFavorite, Function onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? secondaryDarkColor : Colors.white,
      ),
    );
  }

  Widget buildRoundTimeSelectItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget buildContent(Category category) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Container(
              width: ThemeConfig.categoryImageSize,
              height: ThemeConfig.categoryImageSize,
              child: Hero(
                tag: 'categoryImage-${category.name}',
                child: ClipOval(
                  child: CategoryImage(
                    photo: category.getImagePath(),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 320,
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text(
                category.description,
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              color: Colors.white30,
              indent: 64,
              endIndent: 64,
            ),
          ),
          ScopedModelDescendant<SettingsModel>(
            builder: (context, child, settingsModel) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: RichText(
                      text: TextSpan(
                        text: AppLocalizations.of(context).roundTime,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ),
                  CupertinoSegmentedControl(
                    borderColor: Colors.white,
                    selectedColor: secondaryColor,
                    pressedColor: secondaryDarkColor,
                    unselectedColor: Theme.of(context).primaryColor,
                    children: {
                      30: buildRoundTimeSelectItem("30s"),
                      60: buildRoundTimeSelectItem("60s"),
                      90: buildRoundTimeSelectItem("90s"),
                      120: buildRoundTimeSelectItem("120s"),
                    },
                    groupValue: settingsModel.roundTime.toDouble(),
                    onValueChanged: (value) {
                      AnalyticsService.logEvent(
                          "settings_round_time", {"value": value});
                      settingsModel.changeRoundTime(value.toInt());
                    },
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: RaisedButton(
              child: Text(AppLocalizations.of(context).preparationPlay),
              onPressed: () {
                SettingsModel.of(context).increaseGamesPlayed();

                Navigator.pushReplacementNamed(
                  context,
                  '/game-play',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackTemplate(
      child: ScopedModelDescendant<CategoryModel>(
        builder: (context, child, model) {
          var category = model.currentCategory;

          return SafeArea(
            child: Stack(
              children: [
                buildContent(category),
                Positioned(
                  top: 0,
                  right: 0,
                  child: buildFavorite(
                    isFavorite: model.isFavorite(category),
                    onPressed: () => model.toggleFavorite(category),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
