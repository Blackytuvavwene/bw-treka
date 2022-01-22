import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';
import 'package:bw_treka/helper/user.dart';
import 'package:bw_treka/model/user.dart';
import 'package:bw_treka/model/contact.dart';
import 'package:bw_treka/provider/auth.dart';

class ContactScan extends StatefulWidget {
  ContactScan({Key key}) : super(key: key);
  bool toogleText = true;

  @override
  _ContactScanState createState() => _ContactScanState();
}

class _ContactScanState extends State<ContactScan> {
  String _cardTitle = 'Contact Tracing not started';
  String _buttonText = 'Start tracing';
  String _cardSubtitle = 'Press on Start tracing to start contact tracing';
  Color _iconColor = Colors.red[600];

  List<Contact> contacts = [];

  void updateContactList(String uid) async {
    print('Updating contacts list');
    var documents = await UserServices(uid: uid).getContacts();
    for (var doc in documents) {
      Contact cont = Contact(
          contactUid: doc.data()['uid'],
          dateTime: doc.data()['datetime'],
          positive: doc.data()['positivo_covid']);
      if (!Contact.contains(contacts, cont)) {
        setState(() {
          contacts.add(cont);
        });
        print('Added contact to list');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    updateContactList(user.uid);

    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(width: 3.0, color: Colors.grey[200]),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Card(
              elevation: 0.0,
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.trip_origin, color: _iconColor),
                      title: Text(
                        _cardTitle,
                        style: TextStyle(color: _iconColor),
                      ),
                      subtitle: Text(_cardSubtitle),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            _buttonText,
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onPressed: () async {
                            if (widget.toogleText) {
                              setState(() {
                                _cardTitle = 'Contact Tracing on';
                                _cardSubtitle =
                                    'Press Stop tracing to stop contact tracing';
                                _buttonText = 'Stop tracing';
                                _iconColor = Colors.green;
                                widget.toogleText = false;
                              });

                              Nearby().askLocationPermission();

                              updateContactList(user.uid);

                              // START ADVERTISING and DISCOVERY
                              try {
                                bool advertising =
                                    await Nearby().startAdvertising(
                                  user.uid,
                                  Strategy.P2P_STAR,
                                  onConnectionInitiated: null,
                                  onConnectionResult: null,
                                  onDisconnected: null,
                                  serviceId: "com.example.bw_treka",
                                );

                                bool discovery = await Nearby().startDiscovery(
                                  user.uid,
                                  Strategy.P2P_STAR,
                                  onEndpointFound: (String id, String userName,
                                      String serviceId) {
                                    print('found ${userName}');

                                    UserServices(uid: user.uid)
                                        .registerContact(userName);
                                    updateContactList(user.uid);
                                  },
                                  onEndpointLost: null,
                                  serviceId:
                                      "com.example.bw_treka", // uniquely identifies your app
                                );
                              } catch (e) {
                                print(e.toString());
                              }
                            } else {
                              setState(() {
                                _cardTitle = 'Contact Tracing not started';
                                _buttonText = 'Start tracing';
                                _cardSubtitle =
                                    'Press on Start tracing to start contact tracing';
                                _iconColor = Colors.red[600];
                                widget.toogleText = true;
                              });

                              Nearby().stopAdvertising();
                              Nearby().stopDiscovery();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 50.0),
          Text(
            'The people you have come into contact with will be shown below',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ContactCard(
                  contactUid: contacts[index].contactUid,
                  dateTime: contacts[index].dateTime,
                  positive: contacts[index].positive,
                );
              },
              itemCount: contacts.length,
            ),
          ),
        ],
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final String contactUid;
  final String dateTime;
  final bool positive;

  ContactCard({this.contactUid, this.dateTime, this.positive});

  @override
  Widget build(BuildContext context) {
    String posStr = positive ? 'Positivo' : 'Non positivo';

    Color color = positive ? Colors.red : Colors.grey[700];

    return Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(width: 3.0, color: Colors.grey[200]),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Card(
          elevation: 0.0,
          color: Colors.transparent,
          child: ListTile(
            leading: Icon(Icons.person, color: color),
            title: Text(contactUid, style: TextStyle(color: color)),
            subtitle:
                Text('${dateTime} - ${posStr}', style: TextStyle(color: color)),
          ),
        ),
      ),
    );
  }
}
