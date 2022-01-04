public without sharing class stripePaymentInitiationServiceHelper {
    
    public static String PAYMENT_URL = 'https://api.stripe.com/v1/payment_intents';
    public static String API_KEY;
    
    public stripePaymentInitiationServiceHelper(String apikey){
        API_KEY=apikey;
    }
    

    public APIresponse createPaymentInitiationInStripe(decimal amount,
                                                       String currencyForPayment,
                                                       string customerID,
                                                       string description,
                                                       string paymentMethodId){
                                                           
                                                           
                                                           HttpRequest HttpRequest = new HttpRequest();
                                                           
                                                           
                                                           createPaymentInitiationRequest(amount,
                                                                                          currencyForPayment,
                                                                                          customerID,
                                                                                          paymentMethodId,
                                                                                          description,
                                                                                          HttpRequest);
                                                           
                                                           
                                                           
                                                           Http http = new Http();
                                                           HttpResponse response = http.send(HttpRequest);
                                                           
                                                           APIresponse APIresponse = validateResponse(response);
                                                           
                                                           return APIresponse;
                                                           
                                                       }
    
    private APIresponse validateResponse(HttpResponse response) {
        map<string,Object> mapOfBody;
        APIresponse APIresponse= new APIresponse();
        Integer statusCode = response.getStatusCode();
        
        if(statusCode == 200) {
            APIresponse.isSuccess = true;
            system.debug('response.getBody()  : ' + response.getBody());
            mapOfBody = (map<string,Object>)JSON.deserializeUntyped(response.getBody());
            if(mapOfBody!=null && !mapOfBody.isEmpty()) {
                APIresponse.response = string.valueOf(mapOfBody.get('id'));
                System.debug('APIresponse.response>>>>>>'+APIresponse.response);
            }
            
        } else {
            APIresponse.isSuccess = false;
            APIresponse.message = response.getBody();
        }
        
        
        system.debug('APIresponse : ' + APIresponse);
        return APIresponse;
        
    }
    
    private void createPaymentInitiationRequest(decimal amount,
                                                string currencyForPayment,
                                                string customerID,
                                                string paymentMethodId,
                                                string description,
                                                HttpRequest HttpRequest) {
                                                    
                                                    //customerId = 'cus_JJmLvaawgle9Dw';
                                                    //paymentMethodId = 'pm_1Ih8qVSJhC5U83eHC7QMnMwd';
                                                    string params;
                                                    HttpRequest.setEndpoint(PAYMENT_URL);
                                                    HttpRequest.setMethod('POST');
                                                    HttpRequest.setHeader('Authorization', 'Bearer '+API_KEY);
                                                    HttpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                                                    
                                                    
                                                    params = 'amount='+amount+'&description=description' +'&currency='+currencyForPayment+'&customer='+customerID+'&payment_method='+paymentMethodId+'&confirm=true';
                                                    
                                                    
                                                    HttpRequest.setBody(params); 
                                                }
    
    
}