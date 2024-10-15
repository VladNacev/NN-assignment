/**
 * Created by personal on 15.10.2024.
 */

public with sharing class CountryLayerHandler {
    @Future(Callout=true)
    public static void upsertCountriesFromCountryLayer() {
        CountryLayerConnector countryLayerConnection = new CountryLayerConnector();
        HttpResponse response = countryLayerConnection.retrieveAllCountries();
        if(response != null) {
            Object deserializedResponse = JSON.deserializeUntyped(response.getBody());
            List<Country__c> countriesToUpsert = parseCountryData(deserializedResponse);
            List<Database.UpsertResult> upsertResults = Database.upsert(countriesToUpsert, Country__c.fields.CallingCode__c, false);

            System.debug(upsertResults);
            for (Database.UpsertResult upsertResult : upsertResults) {
                if (!upsertResult.isSuccess()) {
                    System.debug('Error: ' + upsertResult.getErrors().toString());
                }
            }
        }
    }

    private static List<Country__c> parseCountryData(Object response) {
        if (response instanceof List<Object>) {
            List<Object> countries = (List<Object>) response;
            List<Country__c> countryList = new List<Country__c>();

            for (Object countryObj : countries) {
                if (countryObj instanceof Map<String, Object>) {
                    Map<String, Object> countryMap = (Map<String, Object>) countryObj;
                    List<Object> callingCodesList = (List<Object>) countryMap.get('callingCodes');
                    Country__c country = new Country__c(
                            Name = (String) countryMap.get('name'),
                            Alpha2Code__c = (String) countryMap.get('alpha2Code'),
                            Alpha3Code__c = (String) countryMap.get('alpha3Code'),
                            Capital_City__c = (String) countryMap.get('capital'),
                            Region__c = (String) countryMap.get('region'),
                            CallingCode__c = (callingCodesList != null && callingCodesList.size() > 0) ? (String) callingCodesList[0] : null
                    );
                    countryList.add(country);
                } else {
                    System.debug('Unexpected country object: ' + countryObj);
                }
            }
            return countryList;
        } else {
            System.debug('Expected response to be a List, but got: ' + response);
            return new List<Country__c>();
        }
    }

}