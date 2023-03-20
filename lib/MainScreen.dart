import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';

import 'FileDbProvider.dart';
import 'FileModel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FileDbProvider memoDb = FileDbProvider();
  List<FileModel>  listFile=[];
  @override
  void initState() {
    super.initState();
    fetchALL();



  }

   Future<int> update(FileModel item)
   async {

      int x = await memoDb.updateMemo(item.id!, item);
     return x;
   }


  fetchALL() {
    getAllList().then((value) {
      setState(() {

        listFile= value;
        print(">>>>>>>>>>>>>>>>"+listFile.length.toString());
      });
    });
  }

  Future<List<FileModel>> getAllList() async {



    var listFile1 = await memoDb.fetchMemos();

    print("List of Files "+listFile1.length.toString());

    return await memoDb.fetchMemos();
  }


  Future<int> addItems(FileModel model)
  async {
    int x = await memoDb.addItem(model);

    print("addItems >>>>>>>>>>>>>>>>>>"+x.toString());

    return x;
  }

  Future<int> deleteID(int id) async
  {
     int x = await memoDb.deleteMemo(id);
     return x;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
     

      body: Container(
        color: Colors.black12,
        child: Container(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: listFile.length,
              shrinkWrap: true,
              itemBuilder: (context, index)
              {

                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  margin: EdgeInsets.all(0.5),
                  child: Card(

                    elevation: 0,

                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(listFile[index].title!,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),

                              SizedBox(height: 10.0,),
                              Text(listFile[index].content!,style: TextStyle(color: Colors.black38),),

                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: InkWell(
                                  child: Icon(Icons.edit),

                                  onTap: (){
                                    showAlertAddDialog(context,setState,listFile[index],true);
                                  },
                                ),
                              ),
                              Container(
                                child: InkWell(
                                  child: Icon(Icons.delete),

                                  onTap: (){
                                    showAlertDialogConfirmDelete(context,listFile[index].id!,setState,index);
                                  },
                                ),
                              ),
                            ],
                          ),


                        ],
                      ),
                    ),

                  ),
                );

              }
          ),
        ),

      ),
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {
            showAlertAddDialog(context,setState,FileModel(),false);
          });
        },
      ),

    );
  }

  showAlertAddDialog(BuildContext context,StateSetter updateState_Dialog,FileModel fileModel, bool isUpdate) {




    showDialog(
        context: context,

        builder: (BuildContext context) {
          final formKey = GlobalKey<FormState>();
          String title="";
          String descripton="";
          FileModel model;
          TextEditingController titleController = TextEditingController(text: fileModel.title);
          TextEditingController descriptionController  = TextEditingController(text: fileModel.content);




          return StatefulBuilder(
              builder: (BuildContext context, setState)
              {

                // if(isUpdate)
                //   {
                //     titleController.text = fileModel.title!;
                //     descriptionController.text = fileModel.content!;
                //   }
                return
                  Container(
                    child:
                    AlertDialog(

                      insetPadding: EdgeInsets.zero,

                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)), //this right here
                      content: Container(
                        // height: 360,
                          color: Colors.white,
                          //backgroundSearchProductForm
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                              child: Form(
                                key: formKey,
                                child: Column(


                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(child: Text("Add Notes",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),),
                                          InkWell(
                                            child: Text("Close"),
                                            onTap: (){
                                              Navigator.pop(context, false);
                                            },
                                          ),

                                        ]

                                    ),






                                    SizedBox(height: 2,),

                                    //Name
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      autofocus: false,
                                      controller: titleController,
                                      textCapitalization: TextCapitalization.words,
                                      style: TextStyle(color: Colors.blue,  fontSize: 15),
                                      decoration: InputDecoration(
                                        filled: true,
                                        //errorText: isemailvalidate?"*Required":null,


                                        // fillColor: sh_editText_background,
                                        // focusColor: sh_editText_background_active,
                                        hintText: "Title",
                                        hintStyle: TextStyle(color: Colors.black12,  fontSize: 15),
                                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.blue, width: 0.5)),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.black, style: BorderStyle.none, width: 0),),


                                      ),

                                      onChanged: (value){
                                        setState(() {
                                           title=value;


                                        });

                                        print("New  Title 1 is $title");

                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      autofocus: false,
                                      minLines: 4,
                                      maxLines: 5,
                                      controller: descriptionController,
                                      textCapitalization: TextCapitalization.words,
                                      style: TextStyle(color: Colors.blue,  fontSize: 15),
                                      decoration: InputDecoration(
                                        filled: true,

                                        //errorText: isemailvalidate?"*Required":null,


                                        // fillColor: Colors.black,
                                        // focusColor: sh_editText_background_active,
                                        hintText: "Description",
                                        hintStyle: TextStyle(color: Colors.black12,  fontSize: 15),
                                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.blue, width: 0.5)),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.black, style: BorderStyle.none, width: 0),),


                                      ),

                                      onChanged: (value){
                                        setState(() {
                                          descripton=value;

                                        });

                                        print("New  Add 1 is $descripton");

                                      },
                                    ),



                                    Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [

                                          isUpdate?
                                                  Container(
                                                    // margin:  EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),

                                                    child: MaterialButton(

                                                      padding:  EdgeInsets.fromLTRB(18.0, 7.0, 18.0, 7.0),
                                                      child: Text("Update", style: TextStyle(color: Colors.black),),
                                                      textColor: Colors.white,
                                                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
                                                      color: Colors.blue,
                                                      onPressed: () => {


                                                        model=  FileModel(title: titleController.text,content: descriptionController.text, id: fileModel.id!),
                                                        update(model).then((value) {
                                                          setState((){
                                                            listFile.clear();
                                                          });

                                                          fetchALL();
                                                          Navigator.pop(context, false);
                                                        })




                                                      },
                                                      elevation: 0,
                                                    ),

                                                  ): Container(
                                  // margin:  EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),

                                  child: MaterialButton(

                                  padding:  EdgeInsets.fromLTRB(18.0, 7.0, 18.0, 7.0),
                                child: Text("SAVE", style: TextStyle(color: Colors.black),),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
                                color: Colors.blue,
                                onPressed: () => {

                                  model=  FileModel(title: title,content: descripton),
                                  addItems(model).then((value) {

                                    setState((){
                                      listFile.clear();
                                    });

                                    fetchALL();
                            Navigator.pop(context, false);
                          })



                        },
                        elevation: 0,
                      ),

                    ),

                                        ],
                                      ),
                                    ),

                                  ],
                                ) ,
                              )

                          )


                      ),
                    ),);
              }
          );


        });
  }

  showAlertDialogConfirmDelete(BuildContext contex,int id ,StateSetter updateState,int index) {
    // set up the button


    showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          title: Text("Delete"),
          content: Text(" Are you sure you want to delete the selected item?"),
          actions: [

            InkWell(
              child: Text("yes", style:TextStyle(fontSize: 15, color: Colors.green),),

              onTap: () {
                //Navigator.pop(contex, true);

                deleteID(id).then((value){

                  setState(() {
                    listFile.removeAt(index);
                  });
                  Navigator.pop(context1, true);
                });



              },

            ),


            InkWell(
              child: Text("No",style:TextStyle(fontSize: 15, color: Colors.red),),

              onTap: () {
                //Navigator.pop(contex, true);
                Navigator.pop(context1, true);


              },

            ),

          ],
        );;
      },
    );
  }
}
