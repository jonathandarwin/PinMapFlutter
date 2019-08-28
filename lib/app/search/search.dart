import 'package:flutter/material.dart';
import 'package:pin_map/app/search/search_provider.dart';
import 'package:pin_map/state/event_state.dart';
import 'package:provider/provider.dart';

class SearchLayout extends StatelessWidget{
  @override
  Widget build(BuildContext context) {    
    return ChangeNotifierProvider(
      builder: (_) => SearchProvider(),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    TextFieldSearch(),
                    ButtonSearch()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldSearch extends StatelessWidget{
  @override
  Widget build(BuildContext context) {    
    SearchProvider _provider = Provider.of<SearchProvider>(context, listen: false);

    return Expanded(
      flex: 7,
      child: TextField(
        onChanged: (text) => _provider.search = text,
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
            'Search'
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

    return Expanded(
      flex: 8,
      child: Container(
        child: ListView.builder(
          itemCount: _provider.listPlace.length,
          itemBuilder: (context, i) {
            return Text('Testing');
          },
        )
      ),
    );
  }
}