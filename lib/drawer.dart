import 'package:flutter/material.dart';
import 'package:review_hub_admin/add.dart';
import 'package:review_hub_admin/babyproducts.dart';
import 'package:review_hub_admin/channels.dart';
import 'package:review_hub_admin/clothes.dart';
import 'package:review_hub_admin/constants/color.dart';
import 'package:review_hub_admin/dashboard.dart';
import 'package:review_hub_admin/login.dart';
import 'package:review_hub_admin/makeup.dart';
import 'package:review_hub_admin/movies.dart';
import 'package:review_hub_admin/restaurents.dart';
import 'package:review_hub_admin/services.dart';

Widget customDrawer (BuildContext context){
  return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: maincolor,
              ),
              child: Text('Navigation Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
              },
            ),
            ListTile(
              title: Text('Movies'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Movies()));
              },
            ),
            ListTile(
              title: Text('Restaurants'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Restaurants()));
              },
            ),
            ListTile(
              title: Text('Channels'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Channel()));
              },
            ),
            ListTile(
              title: Text('Services'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Services()));
              },
            ),
            ListTile(
              title: Text('Baby Products'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BabyProducts()));
              },
            ),
            ListTile(
              title: Text('Clothes'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Clothes()));
              },
            ),
            ListTile(
              title: Text('MakeUp'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Makeup()));
              },
            ),
            ListTile(
              title: Text('Add New Item'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Add()));
              },
            ),
             ListTile(
              title: Text('Logout'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        ),
      );
}