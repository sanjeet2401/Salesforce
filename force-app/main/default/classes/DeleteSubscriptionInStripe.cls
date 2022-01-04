public class DeleteSubscriptionInStripe { 
    
    
    public static List<subscription__c> lstSubscriptionDelete = new List<Subscription__c>();
    public static String SUBSCRIPTION_URL = 'https://api.stripe.com/v1/subscription_schedules';
    
    public static void getScription(Id subscriptionId, String API_KEY, String scheudSubscriptionId){
        System.debug('API_KEY --'+API_KEY);
        Http http = new Http();
        HttpRequest HttpRequest = new HttpRequest();
        HttpRequest.setEndpoint(SUBSCRIPTION_URL+'/'+scheudSubscriptionId+'/cancel');
        HttpRequest.setMethod('POST');
        HttpRequest.setHeader('Authorization', 'Bearer '+API_KEY);
        HttpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
       
        HttpResponse response = http.send(HttpRequest);
        System.debug('response -- '+response);
        validateResponse(response, subscriptionId);
        
        
    }
    
    private static APIresponse validateResponse(HttpResponse response, Id subscriptionId) {
		map<string,Object> mapOfBody;
		APIresponse APIresponse= new APIresponse();
		Integer statusCode = response.getStatusCode();

		if(statusCode == 200) {
			APIresponse.isSuccess = true;
			
            
            
                lstSubscriptionDelete.add(new Subscription__c(response__c = null,
                                                              Id = subscriptionId,
                                                             Stripe_Subscription_Id__c = null,
                                                             Stripe_Sub_Scheduled_Id__c = null));
            
			
			
		} else {
			APIresponse.isSuccess = false;
			APIresponse.message = response.getBody();
            lstSubscriptionDelete.add(new Subscription__c(response__c = APIresponse.message, Id = subscriptionId));
		}
		
		return APIresponse;
	}
    
}