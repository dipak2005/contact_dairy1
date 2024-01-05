import 'dart:io';

import 'package:contact_dairy/view/android/indexstack/chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/contact_provider.dart';
import '../../../controller/contactlist_provider.dart';
import '../../../model/contact_model.dart';
import '../add_contacts.dart';
import '../details.dart';

class Contactlist extends StatefulWidget {
  final int? index;

  const Contactlist({super.key, this.index});

  @override
  State<Contactlist> createState() => _ContactlistState();
}

class _ContactlistState extends State<Contactlist> {
  final LocalAuthentication auth = LocalAuthentication();
  String title = " Save";
  final format = DateFormat("dd -MM -yyyy");

  @override
  void initState() {
    super.initState();
    var cm = Provider.of<ContactProvider>(context, listen: false);

    if (widget.index != null) {
      var clp = Provider.of<ContactListProvider>(context, listen: false);
      var cmd = clp.contactlist[widget.index!];
      cm.phonecontroller.text = cmd.number ?? "";
      cm.namecontroller.text = cmd.name ?? "";
      cm.emailcontroller.text = cmd.email ?? "";

      title = " Add ";
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.78,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(30),
              child: Consumer<ContactProvider>(
                  builder: (context, contactprovider, child) {
                return SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.7,
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1,
                            blurRadius: 15),
                      ],
                    ),
                    child: Consumer<ContactProvider>(
                      builder: (BuildContext context, contact, Widget? child) {
                        return Form(
                          key: contact.globalKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    contact.pickImage(true);
                                  },
                                  child: CircleAvatar(
                                    minRadius: 50,
                                    backgroundImage: contact.filepath != null
                                        ? FileImage(
                                            File(
                                                contactprovider.filepath ?? ""),
                                          )
                                        : null,
                                    child: contactprovider.filepath == null
                                        ? Icon(
                                            Icons.add_a_photo_outlined,
                                            size: 30,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 20, right: 20),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return "Enter Name";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: contact.namecontroller,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    hintText: "Full Name",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 20, right: 20),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return "Enter Phone Number";
                                    } else if (value?.length != 10) {
                                      return "Invalid Phone Number";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: contact.phonecontroller,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.phone),
                                    hintText: "Phone Number",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return " Plz Enter Bio";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: contact.chatcontroller,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.wechat_sharp),
                                    hintText: "Bio",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                              Consumer<ContactProvider>(
                                builder: (BuildContext context, data,
                                    Widget? child) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 200),
                                    child: TextButton(
                                      onPressed: () async {
                                        data.Date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime(
                                            2024,
                                          ),
                                          firstDate: DateTime(
                                            1990,
                                          ),
                                          lastDate: DateTime(2050),
                                          initialDatePickerMode:
                                              DatePickerMode.day,
                                          initialEntryMode:
                                              DatePickerEntryMode.calendar,
                                        );

                                        // setState(() {});
                                        data.changedata(data.datetime!);
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                          ),
                                          data.Date == null
                                              ? Text(
                                                  "Pick Date",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                )
                                              : Text(
                                                  // format.format(data.datetime)
                                                  "${data.Date?.day}/${data.Date?.month}/${data.Date?.year}"),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Consumer<ContactProvider>(
                                builder: (BuildContext context, time,
                                    Widget? child) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 210.0),
                                    child: TextButton(
                                      onPressed: () async {
                                        time.Time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          builder: (context, child) =>
                                              MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          alwaysUse24HourFormat:
                                                              true),
                                                  child: child!),
                                        );
                                        // pTime= time;
                                        time.refresh();
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.watch_later_outlined),
                                          time.Time == null
                                              ? Text(
                                                  "Pick Time",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                )
                                              : Text(
                                                  "${time.Time?.hour}:${time.Time?.minute}")
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                        blurRadius: 15),
                                  ],
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    var cp = Provider.of<ContactProvider>(
                                        context,
                                        listen: false);
                                    if (cp.globalKey.currentState?.validate() ??
                                        false) {
                                      ContactModel cm = ContactModel(
                                          number: cp.phonecontroller.text,
                                          email: cp.emailcontroller.text,
                                          filepath: cp.filepath,
                                          name: cp.namecontroller.text,
                                          chats: cp.chatcontroller.text,
                                          date: cp.Date,
                                          time: cp.Time);

                                      if (widget.index != null) {
                                        Provider.of<ContactListProvider>(
                                                context,
                                                listen: false)
                                            .edit(widget.index!, cm);
                                        Navigator.pop(context);
                                        cp.reset();
                                      } else {
                                        Provider.of<ContactListProvider>(
                                                context,
                                                listen: false)
                                            .add(cm);
                                      }

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Chats(),
                                          ));
                                      cp.reset();
                                    }
                                  },
                                  child: Text(
                                    title,
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
