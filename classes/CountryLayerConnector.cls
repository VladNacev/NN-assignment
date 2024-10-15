/**
 * Created by personal on 15.10.2024.
 */

public with sharing class CountryLayerConnector {
    private String apiEndpoint;
    private String authKey;

    public CountryLayerConnector() {
        this.apiEndpoint = CountryLayerCredentials__c.getOrgDefaults().Endpoint__c;
        this.authKey = CountryLayerCredentials__c.getOrgDefaults().Key__c;
    }

    public HttpResponse retrieveAllCountries() {
        HttpRequest httpRequest = createRequest('/v2/all', 'GET');
        Http httpClient = new Http();
        HttpResponse httpResponse = httpClient.send(httpRequest);
        return httpResponse;
    }

    private HttpRequest createRequest(String apiExtension, String httpMethod) {
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod(httpMethod);
        httpRequest.setEndpoint(this.apiEndpoint + (apiExtension != null ? apiExtension : '') + '?access_key=' + this.authKey);
        return httpRequest;
    }
}