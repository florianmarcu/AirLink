import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/screens/trips/trips_provider.dart';

class FiltersPopUpPage extends StatefulWidget {

  @override
  State<FiltersPopUpPage> createState() => _FiltersPopUpPageState();
}

class _FiltersPopUpPageState extends State<FiltersPopUpPage> {
  
  final _filters = kFilters;
  Map<String, List<bool>> _currSelectedFilters = {
    // "types": [], "ambiences": [], "costs": [], 
    "sorts": []
  };
  //var _prevFiltersSelected = false;
  var _currFiltersSelected = false;

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<TripsPageProvider>();
    //var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var prevSelectedFilters = context.read<TripsPageProvider>().activeFilters;
    //_prevFiltersSelected = prevSelectedFilters['types'].fold(false, (prev, curr) => prev || curr) || prevSelectedFilters['ambiences'].fold(false, (prev, curr) => prev || curr) || prevSelectedFilters['costs'].fold(false, (prev, curr) => prev || curr);
    /// If the current filters are not initialized, initialize them with a copy of the previously selected filters
    // if(_currSelectedFilters['types']!.isEmpty || _currSelectedFilters['ambiences']!.isEmpty || _currSelectedFilters['costs']!.isEmpty){
    //   _currSelectedFilters['types'] = List.from(prevSelectedFilters['types']); 
    //   _currSelectedFilters['ambiences'] = List.from(prevSelectedFilters['ambiences']); 
    //   _currSelectedFilters['costs'] = List.from(prevSelectedFilters['costs']);
    //   _currSelectedFilters['sorts'] = List.from(prevSelectedFilters['sorts']);
    // }
    if(_currSelectedFilters['sorts']!.isEmpty)
      _currSelectedFilters['sorts'] = List.from(prevSelectedFilters['sorts']);

    _currFiltersSelected = 
    // _currSelectedFilters['types']!.fold(false, (prev, curr) => prev || curr) 
    // || _currSelectedFilters['ambiences']!.fold(false, (prev, curr) => prev || curr) 
    // || _currSelectedFilters['costs']!.fold(false, (prev, curr) => prev || curr)
    // || 
    _currSelectedFilters['sorts']!.fold(false, (prev, curr) => prev || curr);
    print("${_currSelectedFilters['sorts']} SELECTED FILTERS");
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "filters",
        elevation: 0, 
        shape: ContinuousRectangleBorder(),
        backgroundColor: _currFiltersSelected
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.primary.withOpacity(0.6),
        onPressed: _currFiltersSelected 
        ? () {
          provider.filter(
            {
              // "types": _currSelectedFilters['types']!, 
              // "ambiences" : _currSelectedFilters['ambiences']!, 
              // "costs": _currSelectedFilters['costs']! , 
              "sorts": _currSelectedFilters['sorts']!
            }, 
            // wrapperHomePageProvider
          );
          Navigator.pop(context);
        } 
        : null,
        label: Container(
          width: MediaQuery.of(context).size.width,
          child: Text("Aplică", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4,),
        ),
      ),
      appBar: AppBar(
        //backgroundColor: Theme.of(context).canvasColor,
        toolbarHeight: 70,
        leadingWidth: 60,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Image.asset(localAsset("cancel"),),
          ),
        ),
        centerTitle: true,
        //title: Text("Filtrează", style: Theme.of(context).textTheme.headline6),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: IconButton(
              icon: Image.asset(localAsset("clear-filter"), width: 30),
              color: _currFiltersSelected ? Theme.of(context).textTheme.labelMedium!.color :  Theme.of(context).textTheme.labelMedium!.color!.withOpacity(0.4),
              onPressed: _currFiltersSelected 
              ? (){
                provider.removeFilters();
                Navigator.pop(context);
              }
              : null,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.05,),
          // Text("Specific", style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
          // SizedBox(height: MediaQuery.of(context).size.height*0.03,),
          // Container(
          //   height: (_filters['types']!.length/4 + 1) * 50,
          //   child: GridView.builder(
          //     cacheExtent: 0,
          //     shrinkWrap: true,
          //     physics: NeverScrollableScrollPhysics(),
          //     padding: EdgeInsets.symmetric(horizontal: 20),
          //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 110, mainAxisExtent: 50, crossAxisSpacing: 10), 
          //     itemCount: _filters['types']!.length,
          //     itemBuilder: (context, index){
          //       return Container(
          //         child: ChoiceChip(
          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          //           side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
          //           pressElevation: 0,
          //           selectedColor: Theme.of(context).primaryColor,
          //           backgroundColor: Theme.of(context).canvasColor,
          //           labelStyle: Theme.of(context).textTheme.overline!,
          //           label: Text(_filters['types']![index],),
          //           selected: _currSelectedFilters['types']![index],
          //           onSelected: (selected){
          //             setState(() {
          //               _currSelectedFilters['types']![index] = selected;
          //             });
          //           },
          //         ),
          //       );
          //     }
          //   ),
          // ),
          // SizedBox(height: MediaQuery.of(context).size.height*0.03,),
          // Text("Atmosferă", style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
          // SizedBox(height: MediaQuery.of(context).size.height*0.03,),
          // Container(
          //   height: (_filters['ambiences']!.length/5 + 1) * 50,
          //   child: GridView.builder(
          //     cacheExtent: 0,
          //     shrinkWrap: true,
          //     physics: NeverScrollableScrollPhysics(),
          //     padding: EdgeInsets.symmetric(horizontal: 20),
          //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 80,mainAxisExtent: 50), 
          //     itemCount: _filters['ambiences']!.length,
          //     itemBuilder: (context, index){
          //       return Container(
          //         child: ChoiceChip(
          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          //           side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
          //           pressElevation: 0,
          //           selectedColor: Theme.of(context).primaryColor,
          //           backgroundColor: Theme.of(context).canvasColor,
          //           labelStyle: Theme.of(context).textTheme.overline!,
          //           label: Text(kAmbiences[_filters['ambiences']![index]]!,),
          //           selected: _currSelectedFilters['ambiences']![index],
          //           onSelected: (selected){
          //             setState(() {
          //               _currSelectedFilters['ambiences']![index] = selected;
          //             });
          //           },
          //         ),
          //       );
          //     }
          //   ),
          // ),
          // Text("Preț", style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
          // SizedBox(height: MediaQuery.of(context).size.height*0.03,),
          // Container(
          //   height: (_filters['costs']!.length/5 + 1) * 50,
          //   child: GridView.builder(
          //     cacheExtent: 0,
          //     shrinkWrap: true,
          //     physics: NeverScrollableScrollPhysics(),
          //     padding: EdgeInsets.symmetric(horizontal: 20),
          //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 80,mainAxisExtent: 50), 
          //     itemCount: _filters['costs']!.length,
          //     itemBuilder: (context, index){
          //       return ChoiceChip(
          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          //         side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
          //         pressElevation: 0,
          //         selectedColor: Theme.of(context).primaryColor,
          //         backgroundColor: Theme.of(context).canvasColor,
          //         labelStyle: Theme.of(context).textTheme.overline!,
          //         label: Row(
          //           mainAxisSize: MainAxisSize.min,
          //           children: List.generate(int.parse(_filters['costs']![index]), (index) => 
          //           Container(
          //             child: Text('\$', textAlign: TextAlign.center),
          //           )
          //         )),
          //         selected: _currSelectedFilters['costs']![index],
          //         onSelected: (selected){
          //           setState(() {
          //             _currSelectedFilters['costs']![index] = selected;
          //           });
          //         },
          //       );
          //     }
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Sortează", 
              style: Theme.of(context).textTheme.headline3
              //style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,
            ),
          ),
          //SizedBox(height: MediaQuery.of(context).size.height*0.01,),
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              cacheExtent: 0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20),
              //itemExtent: 90,
              itemCount: 1,
              itemBuilder: (context, index){
                return ChoiceChip(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
                  pressElevation: 0,
                  selectedColor: Theme.of(context).colorScheme.secondary,
                  backgroundColor: Theme.of(context).canvasColor,
                  labelStyle: Theme.of(context).textTheme.overline!.copyWith(fontSize: 15),
                  label: Text("durată traseu"),
                  selected: _currSelectedFilters['sorts']![index],
                  onSelected: (selected){
                    setState(() {
                      _currSelectedFilters['sorts']![index] = selected;
                    });
                  },
                );
              }
            ),
          )
          // Container(
          //   height: (_filters['costs']!.length/5 + 1) * 50,
          //   child: GridView.builder(
          //     cacheExtent: 0,
          //     shrinkWrap: true,
          //     physics: NeverScrollableScrollPhysics(),
          //     padding: EdgeInsets.symmetric(horizontal: 20),
          //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 80,mainAxisExtent: 50), 
          //     itemCount: _filters['costs']!.length,
          //     itemBuilder: (context, index){
          //       return ChoiceChip(
          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          //         side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
          //         pressElevation: 0,
          //         selectedColor: Theme.of(context).primaryColor,
          //         backgroundColor: Theme.of(context).canvasColor,
          //         labelStyle: Theme.of(context).textTheme.overline!,
          //         label: Row(
          //           mainAxisSize: MainAxisSize.min,
          //           children: List.generate(int.parse(_filters['costs']![index]), (index) => 
          //           Container(
          //             child: Text('\$', textAlign: TextAlign.center),
          //           )
          //         )),
          //         selected: _currSelectedFilters['costs']![index],
          //         onSelected: (selected){
          //           setState(() {
          //             _currSelectedFilters['costs']![index] = selected;
          //           });
          //         },
          //       );
          //     }
          //   ),
          // )
        ],
      )
    );
  }
}
