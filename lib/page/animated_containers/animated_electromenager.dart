import 'package:flutter/material.dart';

class AnimatedContainerFromRight extends StatefulWidget {
  final Future<List<dynamic>> futureProducts;

  AnimatedContainerFromRight({required this.futureProducts});

  @override
  _AnimatedContainerFromRightState createState() =>
      _AnimatedContainerFromRightState();
}

class _AnimatedContainerFromRightState extends State<AnimatedContainerFromRight>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isAnimatedContainerVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Durée de l'animation
    );
    _animation = Tween<Offset>(
      begin: Offset(1.0, 0.0), // Déplacement de la droite vers la gauche
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
    _scrollController.addListener(_onScroll);
// Déclenche l'animation au démarrage
  }

  void _onScroll() {
    if (_isAnimatedContainerVisible) return;

    final double stackPosition = _getStackPosition();

    // Change 200 to the threshold where you want the animation to start
    if (stackPosition < 200) {
      setState(() {
        _isAnimatedContainerVisible = true;
      });
    }
  }

  double _getStackPosition() {
    final RenderBox stackRenderBox = context.findRenderObject() as RenderBox;
    final stackPosition = stackRenderBox.localToGlobal(Offset.zero).dy;
    return stackPosition;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        margin: EdgeInsets.only(left: 14.0),
        decoration: const BoxDecoration(
          color: Color(0xFF00A3FF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            bottomLeft: Radius.circular(50.0),
          ),
        ),
        height: 430,
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 15.0),
        child: FutureBuilder<List<dynamic>>(
          future: widget.futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final List<dynamic> nouveautes = snapshot.data!;
              final List<dynamic> filteredNouveautes = nouveautes
                  .where((item) => item['type'] == 'electromenager')
                  .toList();

              if (filteredNouveautes.isEmpty) {
                return Container();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Électroménager",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -4),
                    child: const Text(
                      "Découvrez notre gamme d'électroménagers intelligents",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Transform.translate(
                    offset: Offset(0, -14),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        filteredNouveautes[0]['Image'],
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(-0.5, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
