class ApiUrls{

  // static final String baseUrl = "http://15.206.93.215/sweeper/api/";
  static final String baseUrl = "http://18.191.133.67/api/";

  // static final kGoogleApiKey = 'AIzaSyDfYy9JovU1we00qR3PZQt3dx_imneouds';
  static final kGoogleApiKey = 'AIzaSyBAfu2wya6a5chTSJJdxHyOAXzQRPFUGWw';

  static final String secretKey = "sk_test_51EgyRrItQT8ZzyO1I06TwbGRQh8DTchlm51IBEGXL1AJWftWcuQqRG33A1q4BB8fipdPA398bM9NzU2flKii2NBf00L14WjNyA";
  static final String publicKey = "pk_test_xIudhR1N8ZnqHogumhfmpskw00NJg6zqor";


  //********** User Part Api ************//
  static final String loginApi = "login";
  static final String signUpApi = "register";
  static final String forgotPassUpApi = "forgot-password";
  static final String twoStepVerifyApi = "v1/verify-user-email-otp";
  static final String resendOtpApi = "resend-email-verification-otp";
  static final String forgotSendCodeApi = "send-forgot-password-otp-mail";
  static final String changePasswordApi = "change-forget-password";
  static final String logoutApi = "logout";
  static final String profileApi = "v1/update-user-data";
  static final String privacyPolicyApi = "privacy-policy";
  static final String termsConditionsApi = "terms-conditions";
  static final String cityListApi = "city-list";


  static final String nearDriverListApi = "v1/near-drivers-list";
  static final String saveRoute = "v1/create-driver-route";
  static final String getRoutes = "v1/single-driver-routes";
  static final String getDriverList = "v1/near-drivers-list";
  static final String getRouteNotification = "v1/driver-routes-notifications";
  static final String updateNotificationStatus = "v1/update-notifications";
  static final String updateRouteNotifyStatus = "v1/update-requested-route";


  //********** Driver Part Api ************//
  static final String getDriverListForDriver = "v1/near-drivers-list-drivers";
  static final String sendFriendRequestApi = "v1/send-driver-friend-request";
  static final String acceptFriendRequestApi = "v1/accept-driver-friend-request";
  static final String driverFriendsListApi = "v1/drivers-friend-list";
  static final String driverFriendsRequestListApi = "v1/driver-friend-request-list";
  static final String shareRouteApi = "v1/share-route";
  static final String subscriptionPlanApi = "v1/subscription-list";
  static final String addCardApi = "v1/add-card";
  static final String allCardListApi = "v1/all-cards";
  static final String cardDeleteApi = "v1/delete-card";
  static final String paymentApi = "v1/subscription-payment";
  static final String routeActiveApi = "v1/start-following-route";
  static final String routeInActiveApi = "v1/end-following-route";
  static final String adsApi = "v1/advertisement-list";


}