import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_padding.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final ProfileController controller = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();
  
  // Image picker for avatar upload
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  
  @override
  void initState() {
    super.initState();
    // Load user profile data if not already loaded
    if (controller.userProfile.value == null) {
      controller.loadUserProfile();
    }
  }
  
  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      
      // Upload the image
      controller.uploadAvatar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                controller.updateProfile();
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.userProfile.value == null) {
          return const Center(
            child: Text('Failed to load profile data. Please try again.'),
          );
        }
        
        return SingleChildScrollView(
          padding: ResponsivePadding.standard(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar section
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _selectImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.primaryLight,
                              backgroundImage: _getAvatarImage(),
                              child: _getAvatarChild(),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (controller.userProfile.value?.avatarUrl != null)
                        TextButton(
                          onPressed: controller.removeAvatar,
                          child: const Text('Remove Avatar'),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Personal Information Section
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Full Name
                TextFormField(
                  initialValue: controller.userProfile.value?.fullName ?? '',
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    controller.fullName.value = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                
                // Email
                TextFormField(
                  initialValue: controller.userProfile.value?.email ?? '',
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    suffixIcon: controller.userProfile.value?.isEmailVerified == true
                        ? const Icon(Icons.verified, color: Colors.green)
                        : const Icon(Icons.warning, color: Colors.orange),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    controller.email.value = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                
                // Phone Number
                TextFormField(
                  initialValue: controller.userProfile.value?.phoneNumber ?? '',
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                    suffixIcon: controller.userProfile.value?.isPhoneVerified == true
                        ? const Icon(Icons.verified, color: Colors.green)
                        : null,
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && !GetUtils.isPhoneNumber(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    controller.phoneNumber.value = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                
                // Date of Birth
                TextFormField(
                  initialValue: controller.userProfile.value?.dateOfBirth ?? '',
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'Date of Birth (YYYY-MM-DD)',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      final formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      controller.dateOfBirth.value = formattedDate;
                      // Update the text field
                      setState(() {});
                    }
                  },
                  readOnly: true,
                  onSaved: (value) {
                    controller.dateOfBirth.value = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                
                // Gender
                DropdownButtonFormField<String>(
                  value: controller.userProfile.value?.gender,
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                    DropdownMenuItem(value: 'prefer_not_to_say', child: Text('Prefer not to say')),
                  ],
                  onChanged: (value) {
                    controller.gender.value = value ?? '';
                  },
                  onSaved: (value) {
                    controller.gender.value = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                
                // Nationality
                TextFormField(
                  initialValue: controller.userProfile.value?.nationality ?? '',
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'Nationality',
                    prefixIcon: Icon(Icons.flag),
                  ),
                  onSaved: (value) {
                    controller.nationality.value = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                
                // Occupation
                TextFormField(
                  initialValue: controller.userProfile.value?.occupation ?? '',
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'Occupation',
                    prefixIcon: Icon(Icons.work),
                  ),
                  onSaved: (value) {
                    controller.occupation.value = value ?? '';
                  },
                ),
                const SizedBox(height: 24),
                
                // Address Section
                const Text(
                  'Address Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // IC Number
                TextFormField(
                  initialValue: controller.userProfile.value?.icNumber ?? '',
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'IC Number / Passport',
                    prefixIcon: Icon(Icons.badge),
                  ),
                  onSaved: (value) {
                    controller.icNumber.value = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                
                // Address Line 1
                TextFormField(
                  initialValue: controller.userProfile.value?.address1 ?? '',
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'Address Line 1',
                    prefixIcon: Icon(Icons.home),
                  ),
                  onSaved: (value) {
                    controller.address1.value = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                
                // Address Line 2
                TextFormField(
                  initialValue: controller.userProfile.value?.address2 ?? '',
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'Address Line 2',
                    prefixIcon: Icon(Icons.home),
                  ),
                  onSaved: (value) {
                    controller.address2.value = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                
                // Address Line 3
                TextFormField(
                  initialValue: controller.userProfile.value?.address3 ?? '',
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'Address Line 3',
                    prefixIcon: Icon(Icons.home),
                  ),
                  onSaved: (value) {
                    controller.address3.value = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                
                // Postcode
                TextFormField(
                  initialValue: controller.userProfile.value?.postcode ?? '',
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'Postcode',
                    prefixIcon: Icon(Icons.local_post_office),
                  ),
                  onSaved: (value) {
                    controller.postcode.value = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                
                // City
                TextFormField(
                  initialValue: controller.userProfile.value?.city ?? '',
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'City',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  onSaved: (value) {
                    controller.city.value = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                
                // State
                TextFormField(
                  initialValue: controller.userProfile.value?.state ?? '',
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'State',
                    prefixIcon: Icon(Icons.map),
                  ),
                  onSaved: (value) {
                    controller.state.value = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                
                // Country
                TextFormField(
                  initialValue: controller.userProfile.value?.country ?? '',
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'Country',
                    prefixIcon: Icon(Icons.public),
                  ),
                  onSaved: (value) {
                    controller.country.value = value ?? '';
                  },
                ),
                const SizedBox(height: 32),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        controller.updateProfile();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }
  
  // Helper method to get avatar image
  ImageProvider? _getAvatarImage() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (controller.userProfile.value?.avatarUrl != null && 
               controller.userProfile.value!.avatarUrl!.isNotEmpty) {
      return NetworkImage(controller.userProfile.value!.avatarUrl!);
    }
    return null;
  }
  
  // Helper method to get avatar child widget
  Widget? _getAvatarChild() {
    if (_selectedImage != null || 
        (controller.userProfile.value?.avatarUrl != null && 
         controller.userProfile.value!.avatarUrl!.isNotEmpty)) {
      return null;
    }
    return Icon(
      Icons.person,
      size: 50,
      color: AppColors.primaryDark,
    );
  }
} 