import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final String initialText, finalText;
  final ButtonStyle buttonStyle;
  final Duration animationDuartion;
  final IconData icon;
  final double iconSize;
  final Function onTap;

  const AnimatedButton({
    Key key,
    this.initialText,
    this.finalText,
    this.buttonStyle,
    this.animationDuartion,
    this.icon,
    this.iconSize,
    this.onTap,
  }) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  AnimationController _controller;
  ButtonState _currentState;
  Duration _smallDuration;
  Animation<double> _scaleFinalTextAnimation;

  @override
  void initState() {
    super.initState();
    _currentState = ButtonState.SHOW_ONLY_TEXT;
    _smallDuration = Duration(
        milliseconds: (widget.animationDuartion.inMilliseconds * 0.2).round());
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuartion,
    );
    _controller.addListener(() {
      double controllerValue = _controller.value;
      if (controllerValue < 0.2) {
        setState(() {
          _currentState = ButtonState.SHOW_ONLY_ICON;
        });
      } else if (controllerValue > 0.8) {
        setState(() {
          _currentState = ButtonState.SHOW_TEXT_ICON;
        });
      }
    });

    _controller.addStatusListener((currentStatus) {
      if (currentStatus == AnimationStatus.completed) {
        widget.onTap();
      }
    });

    _scaleFinalTextAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: widget.buttonStyle.elevation,
      borderRadius: BorderRadius.circular(widget.buttonStyle.borderRadius),
      child: InkWell(
        onTap: () {
          _controller.forward();
        },
        child: AnimatedContainer(
          duration: _smallDuration,
          height: widget.iconSize + 16.0,
          padding: EdgeInsets.symmetric(
              horizontal:
                  (_currentState == ButtonState.SHOW_ONLY_ICON) ? 16.0 : 48.0,
              vertical: 8.0),
          decoration: BoxDecoration(
            color: (_currentState == ButtonState.SHOW_ONLY_ICON ||
                    _currentState == ButtonState.SHOW_TEXT_ICON)
                ? widget.buttonStyle.secondaryColor
                : widget.buttonStyle.primaryColor,
            border: Border.all(
              color: (_currentState == ButtonState.SHOW_ONLY_ICON ||
                      _currentState == ButtonState.SHOW_TEXT_ICON)
                  ? widget.buttonStyle.primaryColor
                  : Colors.transparent,
            ),
            borderRadius:
                BorderRadius.circular(widget.buttonStyle.borderRadius),
          ),
          child: AnimatedSize(
            vsync: this,
            duration: _smallDuration,
            curve: Curves.easeIn,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (_currentState == ButtonState.SHOW_ONLY_ICON ||
                        _currentState == ButtonState.SHOW_TEXT_ICON)
                    ? Icon(
                        widget.icon,
                        size: widget.iconSize,
                        color: widget.buttonStyle.primaryColor,
                      )
                    : Container(),
                SizedBox(
                  width:
                      _currentState == ButtonState.SHOW_TEXT_ICON ? 30.0 : 0.0,
                ),
                getButtonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getButtonWidget() {
    if (_currentState == ButtonState.SHOW_ONLY_TEXT) {
      return Text(
        widget.initialText,
        style: widget.buttonStyle.initialTextStyle,
      );
    } else if (_currentState == ButtonState.SHOW_ONLY_ICON) {
      return Container();
    } else {
      return ScaleTransition(
        scale: _scaleFinalTextAnimation,
        child: Text(
          widget.finalText,
          style: widget.buttonStyle.finalTextStyle,
        ),
      );
    }
  }
}

class ButtonStyle extends StatelessWidget {
  final TextStyle initialTextStyle, finalTextStyle;
  final Color primaryColor, secondaryColor;
  final double elevation, borderRadius;

  const ButtonStyle(
      {Key key,
      this.initialTextStyle,
      this.finalTextStyle,
      this.primaryColor,
      this.secondaryColor,
      this.elevation,
      this.borderRadius})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

enum ButtonState {
  SHOW_ONLY_TEXT,
  SHOW_ONLY_ICON,
  SHOW_TEXT_ICON,
}
