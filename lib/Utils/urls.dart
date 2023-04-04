// String baseURL = 'http://eurdp1-tpl.ddns.net:8080/api/';
String baseURL = 'http://solutionswave.com/bpro/api/';
//                http://solutionswave.com/bpro/api/


//////////////  non authenticated apis
String loginURL = '${baseURL}login';
String signUpURL = '${baseURL}register';

String searchURL = '${baseURL}search';
String resetPasswordURL = '${baseURL}resetPassword';

//////////////  authenticated apis
String findUserURL = '${baseURL}user_detail';
String changePasswordURL = '${baseURL}resetPassword';
// String changeUserStatusURL = '${baseURL}changeUserStatus';


String transactionHistoryURL = '${baseURL}transaction_history';

String getBanksNameURL = '${baseURL}get_banks_name';
String withdrawRequestURL = '${baseURL}payment';
String depositRequestURL = '${baseURL}reciept';
// String verifyTransactionURL = '${baseURL}verifyTransaction';
// String transactionRequestURL = '${baseURL}transactionRequest';
