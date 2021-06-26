import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grpc_client/business_logic/providers/auth_provider.dart';
import 'package:grpc_client/business_logic/providers/posts_provider.dart';
import 'package:grpc_client/models/post.dart';
import 'package:grpc_client/ui/auth_screen.dart';
import 'package:grpc_client/utils/strings.dart';
import 'package:provider/provider.dart';
import 'make_post_screen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PostsProvider postsProvider = PostsProvider();
  int initialPage = 1;
  ScrollController _scrollController = ScrollController();
  bool _isEnd = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    postsProvider = Provider.of<PostsProvider>(context, listen: true);
    if (!postsProvider.requestDone) postsProvider.fetchPostsByPage(initialPage).then((value) {});

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
    //     initialPage = initialPage + 1;
    //     print("at the end of the list");
    //     postsProvider.fetchPostsByPage(initialPage).then((value) {});
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildSliverAppBar(),
            _buildList(screenHeight, screenWidth),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PostBottomSheet())).then((value) async{
            print("hello hi2");
            await postsProvider.fetchPostsByPage(1);
          });
        },
      ),
    );
  }

  //widgets
  Widget _buildSinglePostWidget(Post? post, double height, double width) {
    double cardHeight = 0.4 * height;


    return Container(
      height: cardHeight,
      width: double.infinity,
      margin: EdgeInsets.only(top: 10),
      child: Card(
          elevation: 10,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: Image.memory(
                  Uint8List.fromList(post!.pictureBlob!),
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 10.0),
                    child: Text(
                      post.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )),
              Expanded(flex: 1, child: Container(margin: EdgeInsets.only(left: 10.0), child: Text(post.content))),
              Divider(),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.thumb_up_alt_outlined)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.comment)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined)),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _buildHeaderWidget() {
    return Consumer<AuthProvider>(builder: (context,  auth, child) {
      return Column(
        children: [
          Divider(
            color: Colors.black45,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Container(
               margin: EdgeInsets.only(left: 10),
               child: InkWell(
                 onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen())).then((value) async{
                     print("hello hi1");
                     await postsProvider.fetchPostsByPage(1);
                   });
                 },
                 child: CircleAvatar(
                   radius: 20,
                   backgroundImage: NetworkImage(auth.imgUrl),
                 ),
               ),
             ),
              Container(
                margin: EdgeInsets.only(left: 10),
                  child: Text(
                    auth.fullName,
                    style: TextStyle(fontSize: 18),
                  ))
            ],
          ),
          Divider(
            color: Colors.black45,
          ),
        ],
      );
    });
  }

  Widget _buildList(double screenHeight, double screenWidth) => SliverToBoxAdapter(
        child: ListView.builder(
            itemCount: postsProvider.posts.length + 1,
            primary: false,
            shrinkWrap: true,
            itemBuilder: (BuildContext ctx, index) {
              if (index == 0) {
                return _buildHeaderWidget();
              } else if (index == postsProvider.posts.length+1) {
                return _buildCustomLoadingWidget();
              } else {
                index = index - 1;
                return _buildSinglePostWidget(postsProvider.posts[index], screenHeight, screenWidth);
              }
            }),
      );

  Widget _buildCustomLoadingWidget() {
    if (!_isEnd)
      return const SpinKitThreeBounce(
        color: Colors.blue,
        size: 50.0,
      );
    else
      return Center(
        child: Container(
            margin: EdgeInsets.all(10),
            child: Text(
              "No more results:(",
              style: TextStyle(fontSize: 18),
            )),
      );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      title: Text(
        appName,
        style: TextStyle(fontSize: 23, color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              size: 30,
              color: Colors.black54,
            )),
      ],
    );
  }
}
