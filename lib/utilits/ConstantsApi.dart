enum Environment { DEV, STAGING, PROD }

class ConstantApi {
  static Map<String, dynamic> _config = _Config.debugConstants;
  //JOB CONSTANT API
  static String jobRegistrationUrl = SERVER_ONE + "authentication/job_registration";
  static String jobLoginUrl = SERVER_ONE + "authentication/job_login";
  static String jobOtpUrl = SERVER_ONE + "authentication/job_otp_verification";
  static String jobHomeDashBoardUrl = SERVER_ONE + "job/all_jobs";
  static String jobEditProfileUrl = SERVER_ONE + "authentication/job_edit_profile";
  static String jobDetailUrl = SERVER_ONE + "job/job_details";
  static String jobCategoeryUrl = SERVER_ONE + "job/job_category_list";
  static String jobSubCategoeryUrl = SERVER_ONE + "job/job_sub_category_list";
  static String postJobUrl = SERVER_ONE + "job/post_job";
  static String openingJobUrl = SERVER_ONE + "job/opening_jobs";
  static String closedJobUrl = SERVER_ONE + "job/closed_jobs";
  static String jobUserProfile = SERVER_ONE + "job/user_details";
  static String jobPreferenceUrl = SERVER_ONE + "job/job_preference";
  static String jobLogoutUrl = SERVER_ONE + "authentication/job_logout";
  static String jobSavedListUrl = SERVER_ONE + "job/saved_jobs";

  //PRODUCT CONSTANT API
  static String productRegistrationUrl = SERVER_ONE + "authentication/product_registration";
  static String productLoginUrl = SERVER_ONE + "authentication/product_login";
  static String productOtpUrl = SERVER_ONE + "authentication/product_otp_verification";
  static String allProductUrl = SERVER_ONE + "product/all_products";
  static String productDetailUrl = SERVER_ONE + "product/product_details";
  static String myProductUrl = SERVER_ONE + "product/my_products";
  static String savedProductUrl = SERVER_ONE + "product/saved_products";
  static String postProductUrl = SERVER_ONE + "product/post_product";


  static String SOMETHING_WRONG = "Some thing wrong";
  static String NO_INTERNET = "No internet Connection";
  static String BAD_RESPONSE = "Bad Response";
  static String UNAUTHORIZED = "Un Athurized";

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.DEV:
        _config = _Config.debugConstants;
        break;
      case Environment.STAGING:
        _config = _Config.stagingConstants;
        break;
      case Environment.PROD:
        _config = _Config.prodConstants;
        break;
    }
  }

  static get SERVER_ONE {
    return _config[_Config.SERVER_ONE];
  }

  static get BUILD_VARIANTS {
    return _config[_Config.BUILD_VARIANTS];
  }
}

class _Config {
  static const SERVER_ONE = "";
  static const BUILD_VARIANTS = "Taskers-dev";

  static Map<String, dynamic> debugConstants = {
    SERVER_ONE: "https://wetaskers.in/api/",
    BUILD_VARIANTS: "Taskers-dev",
  };

  static Map<String, dynamic> stagingConstants = {
    SERVER_ONE: "https://wetaskers.spaaztech.in/api/",
    BUILD_VARIANTS: "Taskers-dev",
  };

  static Map<String, dynamic> prodConstants = {
    SERVER_ONE: "https://wetaskers.spaaztech.in/api/",
    BUILD_VARIANTS: "Taskers-dev",
  };
}
