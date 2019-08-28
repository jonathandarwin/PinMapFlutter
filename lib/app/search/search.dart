import 'package:flutter/material.dart';
import 'package:pin_map/app/search/search_provider.dart';
import 'package:pin_map/model/place.dart';
import 'package:pin_map/state/event_state.dart';
import 'package:provider/provider.dart';

class SearchLayout extends StatelessWidget{
  @override
  Widget build(BuildContext context) {    
    return ChangeNotifierProvider(
      builder: (_) => SearchProvider(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: TextFieldSearch(),
          ),
          body: ListAddress(),
        ),
      ),
    );
  }
}

class TextFieldSearch extends StatelessWidget{
  @override
  Widget build(BuildContext context) {    
    SearchProvider _provider = Provider.of<SearchProvider>(context, listen: false);
    return TextField(
      onChanged: (text) => _provider.search = text,      
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white
      ),
      decoration: InputDecoration(
        hintText: 'Search',
        labelStyle: TextStyle(
          color: Colors.white
        ),
        enabledBorder: UnderlineInputBorder(                
          borderSide: BorderSide(
            color: Colors.white
          )
        ),
        focusedBorder: UnderlineInputBorder(                
          borderSide: BorderSide(
            color: Colors.white
          )
        )
      ),
    );      
  }
}

class ButtonSearch extends StatelessWidget{
  @override
  Widget build(BuildContext context) {    
    SearchProvider _provider = Provider.of<SearchProvider>(context, listen: false);

    return Expanded(
      flex: 3,
      child: Container(
        child: FlatButton(
          onPressed: () async {
            int status = await _provider.doSearch();
            print(status);
            switch(status){
              case EventState.SUCCESS:
                _provider.refresh();
                break;
              case EventState.NO_DATA:
                break;
              case EventState.ERROR:
                break;
            }
          },
          child: Text(
            'Search',
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}

class ListAddress extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SearchProvider _provider = Provider.of<SearchProvider>(context);

    return Container(
      margin: EdgeInsets.all(15.0),
      child: ListView.builder(
        itemCount: _provider.listPlace.length,
        itemBuilder: (context, i) {
          Place place = _provider.listPlace[i];
          return Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Icon(
                  Icons.person_pin_circle,
                  size: 30.0,
                  color: Colors.red,
                ),
              ),
              Expanded(
                flex: 8,
                child: Text(place.address)
              )
            ],
          );
        },
      )
    );
  }
}