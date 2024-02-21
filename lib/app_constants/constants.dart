import 'package:coucou_v2/utils/hex_color_util.dart';
import 'package:flutter/material.dart';

class Constants {
  static Color primaryColor = HexColor('FFDE2E');
  static Color secondaryColor = HexColor('FFC944');

  static Color pageBackgroundLight = HexColor('FFFFFF');

  static Color textColor = HexColor('000000');
  static Color textWhite = HexColor('ffffff');

  static Color black = HexColor('000000');
  static Color white = HexColor('ffffff');

  static Color green1 = HexColor('6EC421');
  static Color red1 = HexColor('FA4848');
  static Color red2 = HexColor('FC0000');

  static Color shadowColor2 = HexColor('BFBFD3');

  static Color yellowGradient1 = HexColor('DEE156');
  static Color yellowGradient2 = HexColor('E19156');

  static Color postCardBackground = HexColor('E5E5E5');

  static Color primaryGrey = HexColor('989899');
  static Color primaryGrey2 = HexColor('D9D9D9');
  static Color primaryGrey3 = HexColor('CAC9C7');
  static Color primaryGreyLight = HexColor('CCCDCC');
  static Color primaryGreyExtraLight = HexColor('F3F5F9');

  static Color primaryBorderColor = HexColor('F3F0F4');

  static Color primaryInputBgColor = HexColor('F8F9F8');

  static Color primarySwitchBgColor = HexColor('F1F0F3');
  static Color primaryDarkSwitchBgColor = HexColor('EAEBEC');

  // static const TERMS_CONDITION = '${baseURL2}terms-condition';
  // static const PRIVACY_POLICY = '${baseURL2}privacy-policy';

  static const Duration placeholderFadeInDuration = Duration(milliseconds: 250);

  static const String noImage = "assets/icons/no_image.jpeg";

  static const String splashGif = "assets/lottie/splash.json";

  //devo
  static const baseURL = "http://13.127.182.122:9956/";
  // static const baseURL = "http://13.127.182.122:9955/";
  // static const baseURL = "https://6efc-103-68-187-186.in.ngrok.io/";
  static const ENVIRONMENT = 'devo';

  static const String GOOGLE_PLACES_API_KEY =
      'AIzaSyDSk_RAiKiRmiLbIgu6bHXKw0C-2UVCvq4';
  // 'AIzaSyBaa9VNnbHi5HR6EBubEIFW465BLoo42rA';

  static const String ATTACHMENT_IMAGE = "Image";
  static const String ATTACHMENT_VIDEO = "Video";

  static const String LOADING = "loading";
  static const String RECEIVE_SUCCESSS = "loading";
  static const String ERROR = "loading";

  // prod
  // static const String RAZOR_PAY_KEY = "rzp_live_dqNRpgOISWkB7L";

  // test
  static const String RAZOR_PAY_KEY = "rzp_test_SRVuJahkQVtqtW";

  static const String DUMMY_IMAGE_URL =
      "https://coucoustoragebucket152907-dev.s3.ap-south-1.amazonaws.com/public/Challenge_devo/03-08-2023/v4V";

  //endpoints
  static const String login = "mobileUser/mobileUserLogin";
  static const String logoutUser = "mobileUser/logout";
  static const String checkUser = "mobileUser/CheckUserExites";
  static const String getUserDataById = "mobileUser/getMobileUserById";
  static const String getUserDataByIdLogin =
      "mobileUser/getMobileUserByIdLogin";
  static const String updatePassword = "mobileUser/updatePassword";
  static const String signupUser = "mobileUser/addMobileUser";
  static const String updateUserProfile = "mobileUser/updateMobileUser";
  static const String addUserPost = "userPost/addUserPost";
  static const String updateUserPost = "userPost/updateUserPost";
  static const String searchUserTag = "mobileUser/searchTagUser";
  static const String searchUserPostTag = "userPost/getPostWithSearch";
  static const String getAllPostType = "userPost/getAllPost";
  static const String addLikePost = "postLike/postLike";
  static const String addQuizPost = "userPost/addPresonalOpinion";
  static const String getComments = "postComment/getAllCommentsByPostId";
  static const String postComments = "postComment/postComments";
  static const String userFollow = "userFollow/addFollow";
  static const String getAllHungryPost = "userPost/getAllPostHungery";
  static const String getAllMyProductPost = "userPost/getAllMyPostHungery";
  static const String addBookmark = "savePost/saveUserPost";
  static const String deletePost = "userPost/deleteUserPost";
  static const String addToCart = "addToCart/addToCart";
  static const String removeFromCart = "addToCart/RemoveCartItem";
  static const String checkoutRazorpayment = "payment/checkRazorPayPayment";
  static const String clearCartData = "payment/clearCart";
  static const String addRazorpayOrderDetail = "payment/addOrder";
  static const String removeFromCartServer = "addToCart/RemoveCartItem";
  static const String getAllCart = "addToCart/getAllCartProduct";
  static const String addAdresss = "mobileUser/addAddress";
  static const String getUserAdresss = "mobileUser/getUserAddress";
  static const String addReelViewCount = "postLike/postView";
  static const String updateFoodStatus = "userPost/updateFoodStatus";
  static const String loginWithGoogleOrFacebook =
      "mobileUser/mobileUserLoginEmail";

  static const String createChallenge = "challenges/addChallenge";
  static const String updateChallenge = "challenges/updateChallenge";
  static const String deleteChallenge = "challenges/deleteChallenge";

  static const String getAllChallenges = "challenges/getAllChallenges";
  static const String getTopAllChallenges = "challegeParticept/topchallenges";
  static const String createReel = "challegeParticept/addChallengeParticept";
  static const String updateReel =
      "challegeParticept/updateChallengeParticeptVideo";

  static const String deleteReel =
      "challegeParticept/deleteChallengeParticeptVideo";
  static const String getChallengeReels =
      "challegeParticept/getAllChallengesById";
  static const String getWinnerChallengeReels =
      "challegeParticept/getChallengesWinners";
  static const String getFollowersList = "userFollow/getAllFollowerByUserId";
  static const String getFollowingList = "userFollow/getAllFollowingByUserId";
  static const String getUserPosts = "userPost/getAllPostByUserId";
  static const String getSavedPosts = "savePost/getAllSaveUserPost";
  static const String addAddress = "mobileUser/addAddress";
  static const String getUserAddress = "mobileUser/getUserAddress";
  static const String getUsersById = "mobileUser/getUserDataByArrayId";
  static const String getUserActivityLog = "postLike/MyCommentActivityLogs";
  static const String getOtherUserActivityLog = "postLike/MyPostActivityLogs";
  static const String getBuyOrderData = "payment/getBuyOrders";
  static const String getSellOrderData = "payment/getSellOrders";
  static const String getPostDetailsById = "userPost/getPostDataByPostId";
  static const String getUserSearchHistory = "mobileUser/getUserSearchKeyData";
  static const String updateOrderStatus = "payment/updateOrderStatus";
  static const String getReelsStory = "story/getAllStory";
  static const String addUserStory = "story/addUserStory";
  static const String storyLike = "story/storyLike";
  static const String getStoryByStoryId = "story/getStoryByStoryId";
  static const String deleteStory = "story/deleteStory";
  static const String updateStory = "story/updateStory";
  static const String sendChatNotification = "postComment/sendChatNotification";

  // new v2 api's
  static const String homeScreenBanner = "challenges/getAllActiveChallenge";
  static const String homeScreenTopPost = "challenges/getAlllatestPost";
  static const String homeScreenMainPostList = "challenges/getMainPagePost";
  static const String allChallengeNames =
      "challenges/getAllActiveChallengeName";
  static const String getChallengeBanner =
      "challenges/getOneChallengeHomeScreen";
  static const String getAllChallenges2 = "challenges/getAllChallenges";
  static const String uploadPost = "challegeParticept/addChallengeParticept";
  static const String updatePost =
      "challegeParticept/updateChallengeParticeptVideo";
  static const String challengeTopPost =
      "challenges/getOneChallengeHomeScreenTopFive";
  static const String challengeMainPost =
      "challenges/getOneChallengeHomeScreenAllPost";
  static const String deleteSearchKey = "challenges/deleteSearchKey";
  static const String searchPost = "challenges/getMainPagePostSearch";
  static const String getUserProfile = "mobileUser/getUserProfileDetails";
  static const String getPostComments =
      "postComment/getAllCommentsByChallengePostId";
  static const String getPostData = "challenges/getPostByPostId";
  static const String postLike = "postLike/challengepostLike";
  static const String addComment = "postComment/challengeParticipateComments";
  static const String addSubComment = "postComment/subComments";
  static const String deleteComment =
      "postComment/deleteCommentByUsingCommentId";
  static const String deleteSubComment =
      "postComment/deleteSubCommentByUsingSubCommentId";
  static const String deleteUserPost = "challenges/deleteUserChallengePost";
  static const String getVideoFromImage = "media/test";
  static const String appRating = "mobileUser/apprating";
}
