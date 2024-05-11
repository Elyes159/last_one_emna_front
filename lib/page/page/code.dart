import 'package:flutter/material.dart';
import 'package:untitled2/page/mdp.dart';


class codePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF006583),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: ClipRRect(
          child: AppBar(
            backgroundColor: Color(0xFF006583),
            automaticallyImplyLeading: false, // This will remove the back arrow
            title: Container(
              child: Transform.translate(
                offset: Offset(-60.0, 0.0),
                child: Transform.scale(
                  scale: 0.7,
                  child: Image.asset('assets/images/logo.jpg'),
                ),
              ),
            ),
            iconTheme: IconThemeData(
              size: 52,
              color: Colors.white,
            ),
          ),
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Transform.translate(
                        offset: Offset(-23, 0.0),
                        child: Text(
                          'code ',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              
              // Champ de texte pour entrer le code
              TextField(
                decoration: InputDecoration(
                  hintText: 'Entrez le code',
                  labelText: 'Code',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Bouton pour soumettre le code
              ElevatedButton(
                onPressed: () {
                 Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MotDePassePage ()),
                        );
                },
                child: Text('Soumettre'),
              ),
            ],
          ),
        ),
      ),
      endDrawer: NavBar(), 
    );
  }
}

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}


