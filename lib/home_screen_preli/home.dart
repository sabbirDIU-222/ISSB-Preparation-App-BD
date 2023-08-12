import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quizapplication/app_side_drawer/side_drawer.dart';
import 'package:quizapplication/widget/BMI/check_bmi.dart';
import 'package:quizapplication/widget/Faq/faq_screen.dart';
import 'package:quizapplication/widget/PdfQuestion/pdfListScreen.dart';
import 'package:quizapplication/widget/preli_medical/colorblindtest.dart';
import 'package:quizapplication/widget/preli_vaiva/quesitionlist.dart';
import 'circuler_page.dart';
import 'cardwidget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'TRD',
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FAQScreen(),
                    ));
              },
              icon: Icon(Icons.lightbulb))
        ],
      ),
      drawer: SideDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              CarouselSlider(
                  items: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://issb-bd.org/data1/images/020817170444_3in1_2.jpg'),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://issb-bd.org/data1/images/020817170743_parade.jpg'),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                              image: NetworkImage(
                                'https://infotrainingbd.com/assets/img/school/BA/1.bma/2.jpeg',
                              ),
                              fit: BoxFit.cover)),
                    ),
                  ],
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    height: 180,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    autoPlayAnimationDuration: Duration(
                      microseconds: 1000,
                    ),
                    viewportFraction: 0.8,
                  )),
              SizedBox(
                height: 30,
              ),
              Text(
                'Current Circular',
                style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 2,
                    color: Color(0xFF454B1B),
                    fontWeight: FontWeight.w600),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: 5.0, left: 7.0, right: 7.0, bottom: 10.0),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          onTap: () => openWebView(
                              'https://joinbangladesharmy.army.mil.bd/home/page/become-an-officer'),
                          child: Card(
                            color: Colors.white,
                            elevation: 2,
                            child: Container(
                              height: 80,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, bottom: 5.0),
                                child: Image.network(
                                  "https://www.nogorsolutions.com/images/clients/clients/bangladesh_army_logo.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          onTap: () => openWebView(
                              'https://joinnavy.navy.mil.bd/BeAOfficer/'),
                          child: Card(
                            color: Colors.white,
                            elevation: 2,
                            child: Container(
                              height: 80,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, bottom: 5.0),
                                child: Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/%E0%A6%AC%E0%A6%BE%E0%A6%82%E0%A6%B2%E0%A6%BE%E0%A6%A6%E0%A7%87%E0%A6%B6_%E0%A6%A8%E0%A7%8C%E0%A6%AC%E0%A6%BE%E0%A6%B9%E0%A6%BF%E0%A6%A8%E0%A7%80%E0%A6%B0_%E0%A6%AE%E0%A6%A8%E0%A7%8B%E0%A6%97%E0%A7%8D%E0%A6%B0%E0%A6%BE%E0%A6%AE.svg/376px-%E0%A6%AC%E0%A6%BE%E0%A6%82%E0%A6%B2%E0%A6%BE%E0%A6%A6%E0%A7%87%E0%A6%B6_%E0%A6%A8%E0%A7%8C%E0%A6%AC%E0%A6%BE%E0%A6%B9%E0%A6%BF%E0%A6%A8%E0%A7%80%E0%A6%B0_%E0%A6%AE%E0%A6%A8%E0%A7%8B%E0%A6%97%E0%A7%8D%E0%A6%B0%E0%A6%BE%E0%A6%AE.svg.png?20220822122657",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          onTap: () =>
                              openWebView('https://joinairforce.baf.mil.bd/'),
                          child: Card(
                            color: Colors.white,
                            elevation: 2,
                            child: Container(
                              height: 80,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, bottom: 5.0),
                                child: Image.network(
                                  "https://baf.mil.bd/fsi/img/BAF.gif",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                      color: Color(0xFF33691e),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Text(
                        'Preliminary Section',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontFamily: 'Sirin'),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ColorBlindTestScreen(),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.medical_information,
                                    color: Colors.green[900],
                                    size: 30,
                                  ),
                                  Text('Medical'),
                                ],
                              ),
                            ),
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: GestureDetector(
                            child: Card(
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calculate,
                                    color: Colors.green[900],
                                    size: 30,
                                  ),
                                  Text('Check BMI')
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BMICalculatorScreen(),
                                  ));
                            },
                          )),
                        ],
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuestionListScreen(),
                                  ));
                            },
                            child: Card(
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.manage_accounts,
                                    color: Colors.green[900],
                                    size: 30,
                                  ),
                                  Text('Viva')
                                ],
                              ),
                            ),
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PdfListScreen(),
                                  ));
                            },
                            child: Card(
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.book_online,
                                    color: Colors.green[900],
                                    size: 30,
                                  ),
                                  Text('Written'),
                                ],
                              ),
                            ),
                          )),
                        ],
                      )),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void openWebView(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => WebViewPage(
          url: url,
        ),
      ),
    );
  }
}
