import 'package:flutter/material.dart';

import 'package:snacc/models.dart';

import 'package:snacc/painting.dart';

import 'package:snacc/pages/restaurant_profile.dart';

import 'package:snacc/pages/map_view.dart';

import 'package:url_launcher/url_launcher.dart';

/// A [ResultTile] is a custom list tile made for the find a restaurant page. It can display conditional
/// content such as the distance from the user.
class ResultTile extends StatelessWidget {
  final Restaurant result;

  ResultTile(this.result);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      RestaurantProfilePage(restaurant: result),
                ),
              ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(
                result.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: (result.distanceFromUser != null)
                  ? // if the user has selected sort by distance, show the distance from them
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('${result.category} | ${result.location}'),
                        SizedBox(width: 10),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.location_on, size: 12),
                              Text(result.distanceFromUser
                                  .toStringAsFixed(1)), // round to 1dp
                            ],
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${result.category} | ${result.location}',
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                minRadius: 20,
                maxRadius: 30,
                backgroundImage: NetworkImage(
                  result.logoUrl,
                ),
              ),
              trailing: SizedBox(width: 60,), // aligns the title to be centred with the bottom menu
            ),
          ),
        ),
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: ShapeDecoration(
            shape: CustomRoundedRectangleBorder(
              leftSide: BorderSide(width: 1, color: Colors.grey[300]),
              rightSide: BorderSide(width: 1, color: Colors.grey[300]),
              bottomSide: BorderSide(width: 1, color: Colors.grey[300]),
              bottomLeftCornerSide: BorderSide(
                width: 1,
                color: Colors.grey[300],
              ),
              bottomRightCornerSide: BorderSide(
                width: 1,
                color: Colors.grey[300],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RawMaterialButton(
                constraints: BoxConstraints(
                  minWidth: 70,
                  minHeight: 40,
                ),
                splashColor: Theme.of(context).cursorColor,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => MapViewPage(
                      viewRestaurant: true,
                      viewingRestaurant: result,
                    ),
                  ),
                ),
                child: Text(
                  'View map',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 1,
                color: Colors.grey[300],
              ),
              RawMaterialButton(
                constraints: BoxConstraints(
                  minWidth: 70,
                  minHeight: 40,
                ),
                splashColor: Theme.of(context).primaryColor,
                onPressed: () => launch(result.websiteUrl),
                child: Text(
                  'Website',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
