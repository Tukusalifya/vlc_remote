import '../boxes.dart';
import '../Constants.dart';
import '../Services/VlcService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/adapters.dart';
import '../Widgets/AddFavouriteDialog.dart';
import '../Widgets/EditFavouriteDialog.dart';
import '../Providers/ConnectionProvider.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';



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

  void _showAddFavouriteDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Favourite',
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const AddFavouriteDialog();
      },
    );
  }

  void _showEditFavouriteDialog(String name, String host, String port, int id, String password, bool isDefault) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Edit Favourite',
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return EditFavouriteDialog(name: name, host: host, port: port, id: id, password: password, isDefault: isDefault,);
      },
    );
  }

  void _showDeleteFavouriteDialog(String name, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Favourite?',
            style: TextStyle(
              color: AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "$name" from your favourites?',
            style: const TextStyle(color: AppColors.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.outline),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await connectionSettingsBox.delete(id);

                DelightToastBar(
                  position: DelightSnackbarPosition.top,
                  autoDismiss: true,
                  builder: (context) => ToastCard(
                    leading: const Icon(
                      Icons.check_circle_outline,
                      size: 25,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      'Deleted "$name"',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ).show(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Column(
              children: [
                const Row(
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
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: AppColors.outlineVariant.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formGlobalKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 4.0, bottom: 6.0),
                          child: Text(
                            'Server IP Address',
                            style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.onPrimary,
                            hintText: 'e.g. 192.168.1.1',
                            hintStyle: TextStyle(
                                color: AppColors.onSurfaceVariant.withOpacity(0.4)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.primaryContainer,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'You must enter a value for the host';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _host = value!;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 4.0, bottom: 6.0),
                                    child: Text(
                                      'Port',
                                      style: TextStyle(
                                        color: AppColors.onSurfaceVariant,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.onPrimary,
                                      hintText: '8080',
                                      hintStyle: TextStyle(
                                          color: AppColors.onSurfaceVariant
                                              .withOpacity(0.4)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: AppColors.primaryContainer,
                                          width: 2.0,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'You must enter a value for the port';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _port = value!;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 4.0, bottom: 6.0),
                                    child: Text(
                                      'Password',
                                      style: TextStyle(
                                        color: AppColors.onSurfaceVariant,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.onPrimary,
                                      hintText: 'Required',
                                      hintStyle: TextStyle(
                                          color: AppColors.onSurfaceVariant
                                              .withOpacity(0.4)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: AppColors.primaryContainer,
                                          width: 2.0,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'You must enter a value for the password';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _password = value!;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton(
                            onPressed: () async {
                              if (_formGlobalKey.currentState!.validate()) {
                                _formGlobalKey.currentState!.save();
                                Map<String, dynamic> status = await VlcService(
                                    host: _host,
                                    port: _port,
                                    password: _password
                                ).fetchCurrentStatus();

                                if(status['status']){
                                  context
                                      .read<Connectionprovider>()
                                      .changeConnectionSettings(
                                    newHost: _host,
                                    newPort: _port,
                                    newPassword: _password,
                                  );
                                  DelightToastBar(
                                    position: DelightSnackbarPosition.top,
                                    autoDismiss: true,
                                    builder: (context) => const ToastCard(
                                      leading: Icon(
                                        Icons.check_circle_outline,
                                        size: 25,
                                        color: AppColors.primary,
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
                                }else{
                                  DelightToastBar(
                                    position: DelightSnackbarPosition.top,
                                    autoDismiss: true,
                                    builder: (context) => const ToastCard(
                                      leading: Icon(
                                        Icons.error_outline,
                                        size: 25,
                                        color: AppColors.primary,
                                      ),
                                      title: Text(
                                        'Configuration change failed',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ).show(context);
                                }

                                _formGlobalKey.currentState!.reset();
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                            child: const Text(
                              'Connect',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () async {
                              Map<String, dynamic> status = await VlcService(
                                  host: _host,
                                  port: _port,
                                  password: _password
                              ).fetchCurrentStatus();

                              if(status['success']){
                                DelightToastBar(
                                  position: DelightSnackbarPosition.top,
                                  autoDismiss: true,
                                  builder: (context) => const ToastCard(
                                    leading: Icon(
                                      Icons.check_circle_outline,
                                      size: 25,
                                      color: AppColors.primary,
                                    ),
                                    title: Text(
                                      'Success',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ).show(context);
                              }else{
                                DelightToastBar(
                                  position: DelightSnackbarPosition.top,
                                  autoDismiss: true,
                                  builder: (context) => const ToastCard(
                                    leading: Icon(
                                      Icons.error_outline,
                                      size: 25,
                                      color: AppColors.primary,
                                    ),
                                    title: Text(
                                      'Failed',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ).show(context);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: AppColors.primary, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                            child: const Text(
                              'Test Connection',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Favourites',
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: connectionSettingsBox.listenable(),
                        builder: (context, box, child) {
                          return Text(
                            "${box.length}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                _buildFavouritesList(),
                const SizedBox(height: 24),
                _helpInfo(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFavouriteDialog,
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }

  Widget _buildFavouritesList() {
    return ValueListenableBuilder(
      valueListenable: connectionSettingsBox.listenable(),
      builder: (context, box, child) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: box.length,
          itemBuilder: (BuildContext context, int index) {
            final key = box.keyAt(index);
            final favourite = connectionSettingsBox.get(key)!;

            return _buildFavouriteCard(
              context,
              id: key,
              name: favourite.name,
              host: favourite.host,
              port: favourite.port,
              password: favourite.password,
              isDefault: favourite.isDefault,
            );
          },
        );
      }
    );
  }

  Widget _buildFavouriteCard(BuildContext context, {
    required int id,
    required String name,
    required String host,
    required String port,
    required String password,
    required bool isDefault,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$host:$port',
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Default',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: AppColors.outlineVariant.withOpacity(0.1),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: FilledButton.icon(
                    onPressed: () async {
                      Map<String, dynamic> status = await VlcService(
                          host: host,
                          port: port,
                          password: password
                      ).fetchCurrentStatus();

                      if (status['success']){
                        context
                            .read<Connectionprovider>()
                            .changeConnectionSettings(
                          newHost: host,
                          newPort: port,
                          newPassword: password,
                        );

                        DelightToastBar(
                          position: DelightSnackbarPosition.top,
                          autoDismiss: true,
                          builder: (context) => const ToastCard(
                            leading: Icon(
                              Icons.check_circle_outline,
                              size: 25,
                              color: AppColors.primary,
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
                      }else{
                        DelightToastBar(
                          position: DelightSnackbarPosition.top,
                          autoDismiss: true,
                          builder: (context) => const ToastCard(
                            leading: Icon(
                              Icons.error_outline,
                              size: 25,
                              color: AppColors.primary,
                            ),
                            title: Text(
                              'Configuration change failed',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ).show(context);
                      }

                    },
                    icon: const Icon(Icons.bolt, size: 18),
                    label: const Text('Connect'),
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          AppColors.secondaryContainer.withOpacity(0.2),
                      foregroundColor: AppColors.secondary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  onPressed: () => _showEditFavouriteDialog(name, host, port, id, password, isDefault),
                  icon: const Icon(Icons.edit, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surfaceVariant.withOpacity(0.5),
                    foregroundColor: AppColors.onSurfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  onPressed: () => _showDeleteFavouriteDialog(name, id),
                  icon: const Icon(Icons.delete, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.errorContainer.withOpacity(0.2),
                    foregroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _helpInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.infoContainerBackground.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.infoContainerBorder.withOpacity(0.2),
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
              children: [
                const Text(
                  'Need Help?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.infoContainerText,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Make sure VLC is running and 'Web Interface' is enabled "
                  "in Advanced preferences under Main Interfaces.",
                  softWrap: true,
                  style: TextStyle(
                    color: AppColors.infoContainerText.withOpacity(0.8),
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
