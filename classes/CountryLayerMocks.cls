/**
 * Created by personal on 15.10.2024.
 */
@IsTest
public with sharing class CountryLayerMocks {

    public class MockHttpResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{"name": "United Kingdom", "alpha2Code": "GB", "alpha3Code": "GBR", "capital": "London", "region": "Europe", "callingCodes": ["44"]},'
                    + '{"name": "Australia", "alpha2Code": "AU", "alpha3Code": "AUS", "capital": "Canberra", "region": "Oceania", "callingCodes": ["61"]}]');
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockHttpFailureResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"error": "Invalid API Key"}');
            res.setStatusCode(401);
            return res;
        }
    }
}
