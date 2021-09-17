import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget  {
  //const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> btnText = ['All', 'Export', 'Channels', 'Categories', 'Favorite', 'Playlist','Random'];
// TickerProviderStateMixin allows the fade out/fade in animation when changing the active button

  // this will control the button clicks and tab changing
  TabController _controller;

  // this will control the animation when a button changes from an off state to an on state
  AnimationController _animationControllerOn;

  // this will control the animation when a button changes from an on state to an off state
  AnimationController _animationControllerOff;

  // this will give the background color values of a button when it changes to an on state
  Animation _colorTweenBackgroundOn;
  Animation _colorTweenBackgroundOff;

  // this will give the foreground color values of a button when it changes to an on state
  Animation _colorTweenForegroundOn;
  Animation _colorTweenForegroundOff;

  // when swiping, the _controller.index value only changes after the animation, therefore, we need this to trigger the animations and save the current index
  int _currentIndex = 0;

  //this is needed to know the exact state of the tab to enable us display the text click as page
  int index = 0;

  // saves the previous active tab
  int _prevControllerIndex = 0;

  // saves the value of the tab animation. For example, if one is between the 1st and the 2nd tab, this value will be 0.5
  double _aniValue = 0.0;

  // saves the previous value of the tab animation. It's used to figure the direction of the animation
  double _prevAniValue = 0.0;

  // these will be our tab icons. You can use whatever you like for the content of your buttons
  // List _icons = [
  //   Icons.star,
  //   Icons.whatshot,
  //   Icons.call,
  //   Icons.contacts,
  //   Icons.email,
  //   Icons.donut_large
  // ];

  // active button's foreground color
  Color _foregroundOn = Colors.black;
  Color _foregroundOff = Colors.white;

  // active button's background color
  Color _backgroundOn = Colors.greenAccent;
  Color _backgroundOff = Color(0xff292939);

  // scroll controller for the TabBar
  ScrollController _scrollController = new ScrollController();

  // this will save the keys for each Tab in the Tab Bar, so we can retrieve their position and size for the scroll controller
  List _keys = [];

  // regist if the the button was tapped
  bool _buttonTap = false;

  @override
  void initState() {
    super.initState();

    for (int index = 0; index < btnText.length; index++) {
      // create a GlobalKey for each Tab
      _keys.add(new GlobalKey());
    }

    // this creates the controller with 7 tabs (in our case)
    _controller = TabController(vsync: this, length: btnText.length);
    // this will execute the function every time there's a swipe animation
    _controller.animation.addListener(_handleTabAnimation);
    // this will execute the function every time the _controller.index value changes
    _controller.addListener(_handleTabChange);

    _animationControllerOff =
        AnimationController(vsync: this, duration: Duration(milliseconds: 75));
    // so the inactive buttons start in their "final" state (color)
    _animationControllerOff.value = 1.0;
    _colorTweenBackgroundOff =
        ColorTween(begin: _backgroundOn, end: _backgroundOff)
            .animate(_animationControllerOff);
    _colorTweenForegroundOff =
        ColorTween(begin: _foregroundOn, end: _foregroundOff)
            .animate(_animationControllerOff);

    _animationControllerOn =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    // so the inactive buttons start in their "final" state (color)
    _animationControllerOn.value = 1.0;
    _colorTweenBackgroundOn =
        ColorTween(begin: _backgroundOff, end: _backgroundOn)
            .animate(_animationControllerOn);
    _colorTweenForegroundOn =
        ColorTween(begin: _foregroundOff, end: _foregroundOn)
            .animate(_animationControllerOn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,

      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 40.0,20.0,0.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.menu_open,
                          size: 30.0,
                          color: Colors.greenAccent,
                        ),
                      ],
                    ),
                  ),
                  new Spacer(),
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(0.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle
                          ),
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage('assets/kewa.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 7.0,
                          height: 7.0,
                          margin: EdgeInsets.fromLTRB(5.0,0.0,0.0,17.0),
                          decoration: new BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //your favorite stream section
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Favorite',
                      style: TextStyle(
                        fontFamily: 'JosefinBold',
                        fontSize: 28.0,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                    Text(
                      'Streams',
                      style: TextStyle(
                        fontFamily: 'JosefinBold',
                        fontSize: 28.0,
                        color: Colors.greenAccent,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //horizontal scroll buttons
            Container(
              height: 40.0,
              // this generates our tabs buttons
              child: ListView.builder(
                // this gives the TabBar a bounce effect when scrolling farther than it's size
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                // make the list horizontal
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context,index) {
                  return Padding(
                    // each button's key
                    key: _keys[index],
                    // padding for the buttons
                    padding: EdgeInsets.all(4.0),
                    child: ButtonTheme(
                      child: AnimatedBuilder(
                        animation: _colorTweenBackgroundOn,
                        builder: (context, child) => FlatButton(
                          // get the color of the button's background (dependent of its state)
                          color: _getBackgroundColor(index),
                          // make the button a rectangle with round corners
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          onPressed: () {
                            setState(() {
                              _buttonTap = true;
                              // trigger the controller to change between Tab Views
                              _controller.animateTo(index);
                              // set the current index
                              _setCurrentIndex(index);
                              // scroll to the tapped button (needed if we tap the active button and it's not on its position)
                              _scrollTo(index);
                            });
                          },
                          child: Text(
                            // get the text
                            btnText[index],
                            // get the color of the text (dependent of its state)
                            style: TextStyle(
                                color: _getForegroundColor(index),
                                fontFamily: 'JosefinRegular'
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                // number of tabs
                itemCount: btnText.length,
              ),

            ),
            Flexible(
              // this will host our Tab Views
              child: TabBarView(
                // and it is controlled by the controller
                controller: _controller,
                children: <Widget>[
                  // our Tab Views
                  Container(
                    margin: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                    child:  Column(
                      children: [
                        Row(
                          children: [
                            Align(
                              child: Text('Live Now',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'JosefinBold'
                                ),
                              ),
                            ),
                            new Spacer(),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               Icon(
                                   Icons.more_horiz_rounded,
                                 color: Colors.white70,
                                 size: 28.0,
                               ),
                             ],
                           ),
                          ],
                        ),

                        //this is where the carousel style begins but Imma use horizontal listview sha!!!
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20.0),
                          height: 200.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Container(
                                width: 160.0,
                                margin: EdgeInsets.only(right:10.0),
                                decoration: BoxDecoration(
                                  color: Colors.red[300],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                              ),
                              Container(
                                width: 160.0,
                                margin: EdgeInsets.only(right:10.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue[300],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                              ),
                              Container(
                                width: 160.0,
                                color: Colors.green,
                              ),
                              Container(
                                width: 160.0,
                                color: Colors.yellow,
                              ),
                              Container(
                                width: 160.0,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(btnText[1],
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'JosefinBold'
                    ),),
                  Text(btnText[2],
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'JosefinBold'
                    ),),
                  Text(btnText[3],
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'JosefinBold'
                    ),),
                  Text(btnText[4],
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'JosefinBold'
                    ),),
                  Text(btnText[5],
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'JosefinBold'
                    ),),
                  Text(btnText[6],
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'JosefinBold'
                    ),),

                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

  //styles and animations
// runs during the switching tabs animation
  _handleTabAnimation() {
    // gets the value of the animation. For example, if one is between the 1st and the 2nd tab, this value will be 0.5
    _aniValue = _controller.animation.value;

    // if the button wasn't pressed, which means the user is swiping, and the amount swipped is less than 1 (this means that we're swiping through neighbor Tab Views)
    if (!_buttonTap && ((_aniValue - _prevAniValue).abs() < 1)) {
      // set the current tab index
      _setCurrentIndex(_aniValue.round());
    }

    // save the previous Animation Value
    _prevAniValue = _aniValue;
  }

  // runs when the displayed tab changes
  _handleTabChange() {
    // if a button was tapped, change the current index
    if (_buttonTap) _setCurrentIndex(_controller.index);

    // this resets the button tap
    if ((_controller.index == _prevControllerIndex) ||
        (_controller.index == _aniValue.round())) _buttonTap = false;

    // save the previous controller index
    _prevControllerIndex = _controller.index;
  }

  _setCurrentIndex(int index) {
    // if we're actually changing the index
    if (index != _currentIndex) {
      setState(() {
        // change the index
        _currentIndex = index;
      });

      // trigger the button animation
      _triggerAnimation();
      // scroll the TabBar to the correct position (if we have a scrollable bar)
      _scrollTo(index);
    }
  }

  _triggerAnimation() {
    // reset the animations so they're ready to go
    _animationControllerOn.reset();
    _animationControllerOff.reset();

    // run the animations!
    _animationControllerOn.forward();
    _animationControllerOff.forward();
  }

  _scrollTo(int index) {
    // get the screen width. This is used to check if we have an element off screen
    double screenWidth = MediaQuery.of(context).size.width;

    // get the button we want to scroll to
    RenderBox renderBox = _keys[index].currentContext.findRenderObject();
    // get its size
    double size = renderBox.size.width;
    // and position
    double position = renderBox.localToGlobal(Offset.zero).dx;

    // this is how much the button is away from the center of the screen and how much we must scroll to get it into place
    double offset = (position + size / 2) - screenWidth / 2;

    // if the button is to the left of the middle
    if (offset < 0) {
      // get the first button
      renderBox = _keys[0].currentContext.findRenderObject();
      // get the position of the first button of the TabBar
      position = renderBox.localToGlobal(Offset.zero).dx;

      // if the offset pulls the first button away from the left side, we limit that movement so the first button is stuck to the left side
      if (position > offset) offset = position;
    } else {
      // if the button is to the right of the middle

      // get the last button
      renderBox = _keys[btnText.length - 1].currentContext.findRenderObject();
      // get its position
      position = renderBox.localToGlobal(Offset.zero).dx;
      // and size
      size = renderBox.size.width;

      // if the last button doesn't reach the right side, use it's right side as the limit of the screen for the TabBar
      if (position + size < screenWidth) screenWidth = position + size;

      // if the offset pulls the last button away from the right side limit, we reduce that movement so the last button is stuck to the right side limit
      if (position + size - offset < screenWidth) {
        offset = position + size - screenWidth;
      }
    }

    // scroll the calculated amount
    _scrollController.animateTo(offset + _scrollController.offset,
        duration: new Duration(milliseconds: 150), curve: Curves.easeInOut);
  }

  _getBackgroundColor(int index) {
    if (index == _currentIndex) {
      // if it's active button
      return _colorTweenBackgroundOn.value;
    } else if (index == _prevControllerIndex) {
      // if it's the previous active button
      return _colorTweenBackgroundOff.value;
    } else {
      // if the button is inactive
      return _backgroundOff;
    }
  }

  _getForegroundColor(int index) {
    // the same as the above
    if (index == _currentIndex) {
      return _colorTweenForegroundOn.value;
    } else if (index == _prevControllerIndex) {
      return _colorTweenForegroundOff.value;
    } else {
      return _foregroundOff;
    }
  }
}