import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../source.dart';

class WidgetCarousel extends StatefulWidget {
  final double widthImage;
  final double heightImage;
  final double circular;
  final double bottomDot;

  final List<String> images;
  final BoxFit fitImage;

  final Function(int index) onPageChanged;

  WidgetCarousel({
    this.widthImage,
    this.heightImage,
    this.bottomDot = 0,
    this.circular = 5,
    this.images,
    this.fitImage,
    this.onPageChanged,
  });

  @override
  _WidgetCarouselState createState() => _WidgetCarouselState();
}

class _WidgetCarouselState extends State<WidgetCarousel> {
  int _tabSelected = 0;
  List<Widget> _items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _items.addAll(
      List.generate(
        widget.images.length,
        (index) => ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(widget.circular)),
          child: Image.asset(
            widget.images[index],
            width: widget.widthImage ?? AppSize.screenWidth,
            fit: widget.fitImage ?? BoxFit.fill,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: _items,
          options: CarouselOptions(
            height: widget.heightImage ?? 300,
            viewportFraction: 1,
            enableInfiniteScroll: true,
            initialPage: 1,
            aspectRatio: 2,
            autoPlay: false,
            enlargeCenterPage: false,
            onPageChanged: (index, _) {
              if (widget.onPageChanged != null) {
                _tabSelected = index;
                widget.onPageChanged(index);
              } else {
                setState(() => _tabSelected = index);
              }
            },
          ),
        ),
        Positioned.fill(
          bottom: widget.bottomDot,
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => _buildDot(index),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDot(int index) {
    bool isChange = _tabSelected == index;
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      width: isChange ? 14 : 8,
      height: 8,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: isChange ? AppColors.primary : AppColors.white,
      ),
    );
  }
}
