import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../Constants.dart';
import '../Providers/ConnectionProvider.dart';

class Settingsscreen extends StatefulWidget {
  const Settingsscreen({super.key});

  @override
  State<Settingsscreen> createState() => _SettingsscreenState();
}

class _SettingsscreenState extends State<Settingsscreen> {

  final _formGlobalKey = GlobalKey<FormState>();
  String _host = '';
  String _port = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Row(
            children: [
              Icon(
                Icons.cast_connected,
                color: AppColors.primary,
              ),
              SizedBox(width: 8),
              Text(
                'Settings',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Icon(
                Icons.settings_remote,
                color: AppColors.primary,
              ),
            ],
          ),

        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.router,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Connection',
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: Form(
                        key: _formGlobalKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            //Host
                            SizedBox(

                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 50,
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.onPrimary,
                                    label: const Text('Host'),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: AppColors.surfaceVariant, // color when not focused
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.blue, // color when focused
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return 'You must enter a value for the host';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){
                                    _host = value!;
                                  }
                              ),
                            ),
                            const SizedBox(height: 25),

                            //Port
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 50,
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.onPrimary,
                                    label: const Text('Port'),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: AppColors.surfaceVariant, // color when not focused
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.blue, // color when focused
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return 'You must enter a value for the port';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){
                                    _port = value!;
                                  }
                              ),
                            ),
                            const SizedBox(height: 25),

                            //Password
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 50,
                              child: TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.onPrimary,
                                    label: const Text('Password'),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: AppColors.surfaceVariant, // color when not focused
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.blue, // color when focused
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return 'You must enter a value for the password';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){
                                    _password = value!;
                                  }
                              ),
                            ),

                            //submit button
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 50,
                              child: FilledButton(
                                  onPressed: (){
                                    if(_formGlobalKey.currentState!.validate()){
                                      _formGlobalKey.currentState!.save();
                                      context.read<Connectionprovider>().changeConnectionSettings(
                                          newHost: _host,
                                          newPort: _port,
                                          newPassword: _password
                                      );
                                      DelightToastBar(
                                        autoDismiss: true,
                                        builder: (context) => const ToastCard(

                                          leading: Icon(
                                            IconlyLight.tick_square,
                                            size: 25,
                                          ),
                                          title: Text(
                                            'Configuration changed Successfully',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ).show(context);
                                      _formGlobalKey.currentState!.reset();

                                    }

                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.onPrimaryContainer,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                  ),
                                  child: const Text(
                                      'Connect'
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Favourites',
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: Text(
                            "100 Saved",
                            style: TextStyle(
                              fontSize: 12
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 20),

                    _buildFavouritesContainer(),

                    SizedBox(height: 20),

                    _helpInfo()
                  ],
                ),
          )),
        )
    );

  }

  Widget _buildFavouritesContainer(){
    return Container(
        padding: EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          color: AppColors.onPrimary,
          borderRadius: BorderRadius.circular(10.0),

        ),
        child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Home Server",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      Text(
                          "192.168.1.1",
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic
                        ),
                      )
                    ],
                  ),

                  Spacer(),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
                    decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Text(
                      "Default",
                      style: TextStyle(
                          fontSize: 12
                      ),
                    ),
                  )
                ],
              ),

              Spacer(),

              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.55,
                    height: MediaQuery.of(context).size.width * 0.12,
                    child: FilledButton(
                        onPressed: (){

                        },
                        style: FilledButton.styleFrom(

                          backgroundColor: AppColors.onPrimaryContainer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.electric_bolt_outlined
                            ),
                            SizedBox(width: 5.0),
                            const Text(
                                'Connect'
                            ),
                          ],
                        )
                    ),
                  ),

                  SizedBox(width: 5),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.12,
                    height: MediaQuery.of(context).size.width * 0.12,

                    child: IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(
                          Icons.edit,
                          size: 20.0,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.onPrimaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 5),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.12,
                    height: MediaQuery.of(context).size.width * 0.12,

                    child: IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(
                          Icons.delete,
                          size: 20.0,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.onPrimaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
        ),
    );
  }

  Widget _helpInfo(){
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20,
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: AppColors.infoContainerBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.infoContainerBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
              Icons.info_outline,
              color: AppColors.infoContainerIcon,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Need Help?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.infoContainerText,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  "Make sure VLC is running and 'Web Interface' "
                      "is enabled in Advanced preferences under "
                      "More Interfaces.",
                  softWrap: true,
                  style: TextStyle(
                    color: AppColors.infoContainerText
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
