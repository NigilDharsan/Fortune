enum Environment { DEV, STAGING, PROD }

class ConstantApi {
  static Map<String, dynamic> _config = _Config.debugConstants;
  //JOB CONSTANT API
  static String loginUrl = SERVER_ONE + "login";

  static String dashboardUrl = SERVER_ONE + "dashboard";
  static String usersLogdUrl = SERVER_ONE + "users/log";
  static String usersCheckOutUrl = SERVER_ONE + "users/checkout";

  static String servicesList = SERVER_ONE + "services/list";
  static String servicesCreate = SERVER_ONE + "services/create";
  static String servicesStore = SERVER_ONE + "services";
  static String servicesHistory = SERVER_ONE + "services/history/";

  static String marketingList = SERVER_ONE + "marketings/list";
  static String marketingCreate = SERVER_ONE + "marketings/create";
  static String marketingStore = SERVER_ONE + "marketings";
  static String marketingHistory = SERVER_ONE + "marketings/history/";

  static String activitiesList = SERVER_ONE + "activities/list";
  static String activitiesCreate = SERVER_ONE + "activities";
  static String activitiesUpdate = SERVER_ONE + "activities";

  static String stocksList = SERVER_ONE + "stocks/list";
  static String stocksCreate = SERVER_ONE + "stocks";
  static String stocksUpdate = SERVER_ONE + "stocks";

  static String itemsList = SERVER_ONE + "items/list";
  static String itemsCreate = SERVER_ONE + "items";
  static String itemsUpdate = SERVER_ONE + "items";

  static String clientList = SERVER_ONE + "clients/list";
  static String clientCreate = SERVER_ONE + "clients";
  static String clientUpdate = SERVER_ONE + "clients";

  static String logRequestSaveURL = SERVER_ONE + "log_request/save";

  static String usersLogHoursSaveUrl = SERVER_ONE + "log_hours/save";
  static String usersLogHoursUpdatedUrl = SERVER_ONE + "log_hours";

  static String usersLogListUrl = SERVER_ONE + "log_hours/list";

//Spares

  static String sparesListUrl = SERVER_ONE + "spares/ViewAllAssignedSpares";
  static String sparesItemUrl = SERVER_ONE + "spares/GetItemSpareList";
  static String addSparesItemUrl = SERVER_ONE + "spares/AddAssignSpare";
  static String editSparesItemUrl = SERVER_ONE + "spares/GetSpecificSpare";
  static String updateSparesItemUrl = SERVER_ONE + "spares/UpdateAssignSpare";
  static String getExecutiveListUrl = SERVER_ONE + "clients/GetExecutiveList";

// https://fortunepowerfastening.com/erp/api/spares/AddAssignSpare
// https://fortunepowerfastening.com/erp/api/spares/UpdateAssignSpare
// https://fortunepowerfastening.com/erp/api/spares/ViewAllAssignedSpares
// https://fortunepowerfastening.com/erp/api/spares/GetSpecificSpare
// https://fortunepowerfastening.com/erp/api/spares/GetItemSpareList
// https://fortunepowerfastening.com/erp/api/clients/GetExecutiveList

// General

  static String generalListUrl = SERVER_ONE + "general/ViewAlGeneralActivity";
  static String addGeneralUrl = SERVER_ONE + "general/AddGeneralActivity";
  static String editGeneralUrl = SERVER_ONE + "general/EditFollowUp";
  static String updateGeneralUrl = SERVER_ONE + "general/UpdateGeneralActivity";

// https://fortunepowerfastening.com/erp/api/general/AddGeneralActivity
// https://fortunepowerfastening.com/erp/api/general/UpdateGeneralActivity
// https://fortunepowerfastening.com/erp/api/general/ViewAlGeneralActivity
// https://fortunepowerfastening.com/erp/api/general/EditFollowUp
// https://fortunepowerfastening.com/erp/api/clients/GetClientList
// https://fortunepowerfastening.com/erp/api/clients/GetClientById
// https://fortunepowerfastening.com/erp/api/clients/GetExecutiveList

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
    SERVER_ONE: "https://www.fortunepowerfastening.com/erp/api/",
    BUILD_VARIANTS: "Taskers-dev",
  };

  static Map<String, dynamic> stagingConstants = {
    SERVER_ONE: "https://www.fortunepowerfastening.com/erp/api/",
    BUILD_VARIANTS: "Taskers-dev",
  };

  static Map<String, dynamic> prodConstants = {
    SERVER_ONE: "https://www.fortunepowerfastening.com/erp/api/",
    BUILD_VARIANTS: "Taskers-dev",
  };
}
