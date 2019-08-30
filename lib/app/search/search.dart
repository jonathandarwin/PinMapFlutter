import 'package:flutter/material.dart';
import 'package:pin_map/app/search/search_provider.dart';
import 'package:pin_map/model/place.dart';
import 'package:pin_map/state/event_state.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

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
      onChanged: (text) async {
        _provider.search = text;
        int status = await _provider.doSearch();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(place.address),
                    SizedBox(height: 10.0),                    
                    TextAddToMap(place)
                  ],
                )
              )
            ],
          );
        },
      )
    );
  }
}

class TextAddToMap extends StatelessWidget{  
  final Place _place;
  TextAddToMap(this._place);

  @override
  Widget build(BuildContext context) {
    SearchProvider _provider = Provider.of<SearchProvider>(context, listen: false);

    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () async {
            await showDialog(
              context: context,
              builder: (context) => InsertDialog(_provider, _place)
            );            
          },
          child: Text(
            'Add To Map',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold
            ),
          ),
        );
      },
    );
  }
}

class InsertDialog extends StatelessWidget{
  final Place _place;
  final SearchProvider _provider;
  InsertDialog(this._provider, this._place);

  @override
  Widget build(BuildContext context) {        
    return AlertDialog(
      title: Text('Please add description'),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.red
            ),
          ),
        ),
        FlatButton(
          onPressed: () async {            
            String msg = '';
            if(await _provider.insertAddress(_place)){
              msg = 'Insert Success';          
            }
            else{
              msg = 'Error. Please try again';
            }
            Toast.show(msg, context, duration: Toast.LENGTH_LONG);
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),        
      ],
      content: TextField(
        onChanged: (text) => _provider.description = text,
        maxLength: 20,
        decoration: InputDecoration(
          labelText: 'Description'          
        ),
      )
    );
  }
}
