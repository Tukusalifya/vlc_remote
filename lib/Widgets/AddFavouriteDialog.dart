import '../boxes.dart';
import '../Constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/SettingsService.dart';
import '../Models/ConnectionSettings.dart';
import '../Providers/ConnectionProvider.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';


class AddFavouriteDialog extends StatefulWidget {
  const AddFavouriteDialog({super.key});

  @override
  State<AddFavouriteDialog> createState() => _AddFavouriteDialogState();
}

class _AddFavouriteDialogState extends State<AddFavouriteDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isDefaultChecked = false;
  bool _isPasswordVisible = false;
  String _name = "";
  String _host = '';
  String _port = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Dialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add to Favourites',
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Configure your remote connection details.',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Configuration Name Label
                  const Text(
                    'Configuration Name',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Configuration Name Input
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.outlineVariant.withOpacity(0.4),
                      ),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'e.g., Home Server',
                        hintStyle: TextStyle(
                          color: AppColors.outline,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.label_outline,
                          color: AppColors.onSurfaceVariant,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSaved: (value){
                          _name = value!;
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'You must enter a configuration name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Host and Port Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Host
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Host / IP Address',
                              style: TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.outlineVariant.withOpacity(0.4),
                                ),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: '192.168.1.5',
                                  hintStyle: TextStyle(
                                    color: AppColors.outline,
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                onSaved: (value){
                                    _host = value!;
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'You must enter a host';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Port
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Port',
                              style: TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.outlineVariant.withOpacity(0.4),
                                ),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: '8080',
                                  hintStyle: TextStyle(
                                    color: AppColors.outline,
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                onSaved: (value){
                                    _port = value!;
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Port required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Password Label
                  const Text(
                    'Password',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Password Input
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.outlineVariant.withOpacity(0.4),
                      ),
                    ),
                    child: TextFormField(
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(
                          color: AppColors.outline,
                          fontSize: 16,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.onSurfaceVariant,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.outline,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSaved: (value){
                        _password = value!;

                      },

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'You must enter a password';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Set as Default Configuration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Set as Default Configuration',
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch.adaptive(
                        value: _isDefaultChecked,
                        activeColor: AppColors.primaryContainer,
                        activeTrackColor:
                            AppColors.primaryContainer.withOpacity(0.5),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: AppColors.surfaceVariant,
                        onChanged: (val) {
                          setState(() {
                            _isDefaultChecked = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Navigator.of(context).pop();

                          ConnectionSettings settings = ConnectionSettings(
                              name: _name,
                              host: _host,
                              port: _port,
                              password: _password,
                              isDefault: _isDefaultChecked
                          );

                          if (!_isDefaultChecked){
                            await connectionSettingsBox.add(settings);
                          }else{
                            Settingsservice settingsService = Settingsservice(newSettings: settings);
                            bool status = await settingsService.addFavourite();

                            if(status){
                              context.read<Connectionprovider>()
                                  .changeConnectionSettings(
                                newHost: _host,
                                newPort: _port,
                                newPassword: _password,
                              );
                            }

                          }

                          _formKey.currentState!.reset();

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
                                'Favourite saved',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ).show(context);
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                        foregroundColor: AppColors.onPrimaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                      child: const Text(
                        'Save Favourite',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
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
        ),
      ),
    );
  }
}
