import 'package:flutter/material.dart';
import 'package:northshore_nanny_flutter/app/res/constants/extensions.dart';
import 'package:northshore_nanny_flutter/app/utils/app_utils.dart';

class Validator {
  static final Validator _singleton = Validator._internal();

  factory Validator() {
    return _singleton;
  }

  Validator._internal();

  static Validator get instance => _singleton;

  var error = "";

  bool signUpValidator(
    String email,
    String password,
    String confPassword,
    bool isCheckedTermAndCondition,
  ) {
    if (email.isNullOrEmpty) {
      error = "Please enter email";
      return false;
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email.trim())) {
      error = "Please enter valid email";
      return false;
    } else if (password.isNullOrEmpty) {
      error = "Please enter password";
      return false;
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$&*~]).{8,}$')
        .hasMatch(password.trim())) {
      error =
          'Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one digit, and one special character (!@#\$&*~).';
      return false;
    } else if (confPassword.isNullOrEmpty) {
      error = "Confirm password is Required";
      return false;
    } else if (password != confPassword) {
      error = "confirm password is not matched";
      return false;
    } else if (isCheckedTermAndCondition == false) {
      error = "please accept terms & conditions";
      return false;
    } else {
      return true;
    }
  }

  //==========login===//
  bool loginValidator(String email, String password) {
    if (email.trim().isNullOrEmpty) {
      error = "Please enter email";
      return false;
    } else if (!Utils.emailValidation(email.trim())) {
      error = "Please enter a valid email";
      return false;
    } else if (password.trim().isNullOrEmpty) {
      error = "Please enter password";
      return false;
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$&*~]).{8,}$')
        .hasMatch(password.trim())) {
      error =
          'Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one digit, and one special character (!@#\$&*~).';
      return false;
    } else {
      return true;
    }
  }

  //==========forgot passcode ===//
  bool forgotPasswordValidator(
    String email,
  ) {
    if (email.isNullOrEmpty) {
      error = "Please enter email";
      return false;
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email.trim())) {
      error = "Please enter valid email";
      return false;
    } else {
      return true;
    }
  }

  //==========contact US  ===//
  bool contactUsValidator(
    String email,
    String subject,
    String message,
  ) {
    if (email.isNullOrEmpty) {
      error = "Please enter your email ";
      return false;
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email.trim())) {
      error = "Please enter valid email";
      return false;
    } else if (subject.isNullOrEmpty) {
      error = "Please enter your Subject";
      return false;
    } else if (message.isNullOrEmpty) {
      error = "Please enter your Message ";
      return false;
    } else {
      return true;
    }
  }

  bool changePasswordValidator({
    required String newPassword,
    required String confirmPassword,
  }) {
    if (newPassword.isNullOrEmpty) {
      error = "Please enter your New Password";
      return false;
    } else if (newPassword.length > 15) {
      error = "Password maximum length 15 character";
      return false;
    } else if (newPassword.trim().length < 8) {
      error = "Password must be 8 Characters long";
      return false;
    } else if (!RegExp(r'(?=.*?[A-Z])').hasMatch(newPassword.trim())) {
      error = 'Password must contain at least one uppercase letter';
      return false;
    } else if (!RegExp(r'(?=.*?[a-z])').hasMatch(newPassword.trim())) {
      error = 'Password must contain at least one lowercase letter';
      return false;
    } else if (!RegExp(r'(?=.*?\d)').hasMatch(newPassword.trim())) {
      error = 'Password must contain at least one digit';
      return false;
    } else if (!RegExp(r'(?=.*?[!@#$&*~])').hasMatch(newPassword.trim())) {
      error = 'Password must contain at least one special character (!@#\$&*~)';
      return false;
    } else if (confirmPassword.isNullOrEmpty) {
      error = "Please enter your Confirm Password ";
      return false;
    } else if (newPassword != confirmPassword) {
      error = "Confirm Password is not match";
      return false;
    } else {
      return true;
    }
  }

  //==========create nanny Profile ===//
  bool createNannyProfileValidator({
    required String image,
    required String firstname,
    required String lastName,
    required String experience,
    required String highSchoolName,
    required String phoneNumber,
    required String collegeName,
    required String age,
    required String location,
    required String aboutYourSelf,
  }) {
    if (image.isNullOrEmpty) {
      error = "Please add your image";
      return false;
    } else if (firstname.isNullOrEmpty) {
      error = "Please enter your first name ";
      return false;
    } else if (lastName.isNullOrEmpty) {
      error = "Please enter your last name";
      return false;
    } else if (age.isNullOrEmpty) {
      error = "Please enter your dob";
      return false;
    } else if (phoneNumber.isNullOrEmpty) {
      error = "Please enter your phone number";
      return false;
    } else if (location.isNullOrEmpty) {
      error = "Please select your location ";
      return false;
    } else if (experience.isNullOrEmpty) {
      error = "Please enter your experience";
      return false;
    } else if (highSchoolName.isNullOrEmpty) {
      error = "Please enter your high school name";
      return false;
    } else if (collegeName.isNullOrEmpty) {
      error = "Please enter your college name";
      return false;
    } else if (aboutYourSelf.isNullOrEmpty) {
      error = "Please tell us about yourself";
      return false;
    } else {
      return true;
    }
  }

  /// select services validator
  services({required List<dynamic> servicesList}) {
    if (servicesList.isEmpty) {
      error = 'Please choose at least one service';
      return false;
    } else {
      return true;
    }
  }

  /// bank detail validator.
  bankDetailValidator({
    required String bankName,
    required String accountHolderName,
    required String accountNumber,
    required String routingNumber,
    required String addressOne,
    required String city,
    required String state,
    required String country,
    required String postalCode,
    required String ssnNumber,
    required String frontImage,
    required String backImage,
  }) {
    if (bankName.isNullOrEmpty) {
      error = 'Please enter your bank name';
      return false;
    } else if (accountHolderName.isNullOrEmpty) {
      error = 'Please enter your account name';
      return false;
    } else if (accountNumber.isNullOrEmpty) {
      error = 'Please enter your account number';
      return false;
    } else if (routingNumber.isNullOrEmpty) {
      error = 'Please enter your routing number';
      return false;
    } else if (addressOne.isNullOrEmpty) {
      error = 'Please enter your Address ';
      return false;
    } else if (city.isNullOrEmpty) {
      error = 'Please enter your City';
      return false;
    } else if (state.isNullOrEmpty) {
      error = 'Please enter your  State';
      return false;
    } else if (country.isNullOrEmpty) {
      error = 'Please enter your  Country';
      return false;
    } else if (postalCode.isNullOrEmpty) {
      error = 'Please enter your  Postal Code ';
      return false;
    } else if (ssnNumber.isNullOrEmpty) {
      error = 'Please enter your ssn last 4 Numbers';
      return false;
    } else if (frontImage.isNullOrEmpty) {
      error = 'Please upload the front side of your document';
      return false;
    } else if (backImage.isNullOrEmpty) {
      error = 'Please upload the back side of your document';
      return false;
    } else {
      return true;
    }
  }

  /// * CREATE CUSTOMER PROFILE VALIDATORS---------------->>>>>>>>>>>>>>.
  bool customerCreateProfileValidator({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? coordinates,
  }) {
    if (firstName.isNullOrEmpty) {
      error = "Please enter First Name";
      return false;
    } else if (lastName.isNullOrEmpty) {
      error = "Please enter Last Name";
      return false;
    } else if (phoneNumber.isNullOrEmpty) {
      error = "Please enter Phone Number";
      return false;
    } else if (coordinates.isNullOrEmpty) {
      error = "Please Select Your Location";
      return false;
    } else {
      return true;
    }
  }

  /// add availability validator
  addNannyAvailabilityValidator(
      {required TimeOfDay? startTime, required TimeOfDay? endTime}) {
    if (startTime == null) {
      error = "Please Select Start Time";
      return false;
    } else if (endTime == null) {
      error = "Please Select End Time";
      return false;
    } else if (endTime.hour < startTime.hour ||
        (endTime.hour == startTime.hour &&
            endTime.minute <= startTime.minute)) {
      error = "End time should be after start time";
      return false;
    } else {
      return true;
    }
  }

  /// password change validator in settings.

  bool changeSettingPasswordValidator({
    required String newPassword,
    required String confirmPassword,
    required String oldPassword,
  }) {
    if (oldPassword.isNullOrEmpty) {
      error = "Please enter your old Password ";
      return false;
    } else if (newPassword.isNullOrEmpty) {
      error = "Please enter your New Password";
      return false;
    } else if (newPassword.length > 15) {
      error = "Password maximum length 15 character";
      return false;
    } else if (newPassword.trim().length < 8) {
      error = "Password must be 8 Characters long";
      return false;
    } else if (!RegExp(r'(?=.*?[A-Z])').hasMatch(newPassword.trim())) {
      error = 'Password must contain at least one uppercase letter';
      return false;
    } else if (!RegExp(r'(?=.*?[a-z])').hasMatch(newPassword.trim())) {
      error = 'Password must contain at least one lowercase letter';
      return false;
    } else if (!RegExp(r'(?=.*?\d)').hasMatch(newPassword.trim())) {
      error = 'Password must contain at least one digit';
      return false;
    } else if (!RegExp(r'(?=.*?[!@#$&*~])').hasMatch(newPassword.trim())) {
      error = 'Password must contain at least one special character (!@#\$&*~)';
      return false;
    } else if (confirmPassword.isNullOrEmpty) {
      error = "Please enter your Confirm Password ";
      return false;
    } else if (newPassword != confirmPassword) {
      error = "Confirm Password is not match";
      return false;
    } else if (oldPassword == newPassword) {
      error = "Please enter new password which is not match with old password";
      return false;
    } else {
      return true;
    }
  }

  /// used for review and rating validator.
  ratingAndReviewValidator({required double rating, required String message}) {
    if (rating == 0.0) {
      error = 'Please give rating';
      return false;
    } else if (message.isNullOrEmpty) {
      error = 'Please enter your review';
      return false;
    } else {
      return true;
    }
  }

  /// used for Confirm booking validator.
  confirmBookingValidator(
      {required List<String> services, required List<int> childList}) {
    if (services.isEmpty) {
      error = 'No Services added';
      return false;
    } else if (childList.isEmpty) {
      error = 'Please select at least one child';
      return false;
    } else {
      return true;
    }
  }

  /// used for venmo detail and guardian detail
  bool guardianDetailValidator(
      {required String userName,
      required String guardianName,
      required String phoneNumber}) {
    if (userName.isNullOrEmpty) {
      error = 'Please enter your venmo user name .';
      return false;
    } else if (guardianName.isNullOrEmpty) {
      error = 'Please enter your guardian user name .';
      return false;
    } else if (phoneNumber.isNullOrEmpty) {
      error = 'Please enter your phone number';
      return false;
    } else {
      return true;
    }
  }
}
