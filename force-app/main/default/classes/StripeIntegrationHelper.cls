public without sharing class StripeIntegrationHelper {

    public static string customerId;
    public static string paymentMethodId;

    public static void payUsingStripe(StripePaymentForCustomerController.wrapper leadObject) { 

        
        string key = getSecretKey();
        if(String.isNotBlank(key)) {

            APIresponse customerResponse = createCustomerInStripe(key, leadObject);
            if(customerResponse.isSuccess) {
                customerId =  customerResponse.response;
                APIresponse paymentMethodResponse = createPaymentMethodInStripe(key, 
                                                                                leadObject,
                                                                                false);
                if(paymentMethodResponse.isSuccess) {
                    paymentMethodId =  paymentMethodResponse.response;
                    APIresponse paymentMethodResponseForAttach = createPaymentMethodInStripe(key, 
                                                                                            leadObject,
                                                                                            true);
                    if(paymentMethodResponseForAttach.isSuccess) {
                        APIresponse paymentInitiationResponseForAttach = createPaymentInitiateInStripe(key, 
                                                                                                    leadObject);

                       if(paymentInitiationResponseForAttach.isSuccess) {
                            // upadateLead(leadRecordId, 
                            //                 paymentInitiationResponseForAttach.response);
                       } else {
                        throw new applicationException(paymentInitiationResponseForAttach.message);    

                       }                                                                             
                        
                    } else {
                        throw new applicationException(paymentMethodResponseForAttach.message);    
                    }
                } else {
                    throw new applicationException(paymentMethodResponse.message);
                }
            } else {
                throw new applicationException(customerResponse.message);
            }

        }
    }
    private static void upadateLead(string leadId,
                                        string stripeId) {
        
         update new lead(Id=leadId,
                        stripeId__c = stripeId);
    }


    private static string getSecretKey() {
        stripe_details__mdt stripedetails = [SELECT Id, 
                                                    DeveloperName, 
                                                    QualifiedApiName, 
                                                    Stripe_secret_key__c FROM stripe_details__mdt 
                                                    WHERE developerName = 'stripe_details'];

        if(stripedetails!=null) {
            return stripedetails.Stripe_secret_key__c;
        }

        return null;
    }

    private static APIresponse createCustomerInStripe(string key, StripePaymentForCustomerController.wrapper leadObject) {

        StripeCustomerAPIServiceHelper StripeCustomerAPIServiceHelper = new StripeCustomerAPIServiceHelper(key); 
        APIresponse APIresponse = StripeCustomerAPIServiceHelper.createCustomerInStripe(leadObject.email,
                                                                                        leadObject.description,
                                                                                        leadObject.name);

        return APIresponse;
    }

    private static APIresponse createPaymentMethodInStripe(string key,
                                                            StripePaymentForCustomerController.wrapper leadObject,
                                                            Boolean isAttachCall) {

        StripePayment StripePayment = new StripePayment(key);
        APIresponse APIresponse= StripePayment.createPaymentMethodInStripe('card',
                                                                            leadObject.cardNumber,
                                                                            Integer.valueOf(leadObject.cardExpiryMonth),
                                                                            Integer.valueOf(leadObject.cardExpiryYear),
                                                                            customerID,
                                                                            paymentMethodId,
                                                                            isAttachCall);

        return APIresponse;
    }

    private static APIresponse createPaymentInitiateInStripe(string key,
                                                                StripePaymentForCustomerController.wrapper leadObject) {

        stripePaymentInitiationServiceHelper stripePaymentInitiationServiceHelper = new stripePaymentInitiationServiceHelper(key);
        APIresponse APIresponse = stripePaymentInitiationServiceHelper.createPaymentInitiationInStripe(Integer.valueOf(leadObject.Amount*100),
                                                                                                        (leadObject.CurrencyCode).toLowerCase(),
                                                                                                        customerID,
                                                                                                        leadObject.description, 
                                                                                                        paymentMethodId);

        return APIresponse;
    }

    
    public class applicationException extends Exception {}
}