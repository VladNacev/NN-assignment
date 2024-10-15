/**
 * Created by personal on 15.10.2024.
 */
@IsTest
public with sharing class CountryLayerHandlerTest {
    @IsTest
    static void testUpsertCountriesFromCountryLayer_Success() {
        Test.setMock(HttpCalloutMock.class, new CountryLayerMocks.MockHttpResponse());

        Test.startTest();
        CountryLayerHandler.upsertCountriesFromCountryLayer();
        Test.stopTest();

        List<Country__c> countries = [SELECT Name, Alpha2Code__c, Alpha3Code__c, Capital_City__c, Region__c, CallingCode__c FROM Country__c];
        System.assertEquals(2, countries.size(), 'There should be two countries upserted');

        Country__c uk = countries[0];
        System.assertEquals('United Kingdom', uk.Name);
        System.assertEquals('GB', uk.Alpha2Code__c);
        System.assertEquals('GBR', uk.Alpha3Code__c);
        System.assertEquals('London', uk.Capital_City__c);
        System.assertEquals('Europe', uk.Region__c);
        System.assertEquals('44', uk.CallingCode__c);

        Country__c australia = countries[1];
        System.assertEquals('Australia', australia.Name);
        System.assertEquals('AU', australia.Alpha2Code__c);
        System.assertEquals('AUS', australia.Alpha3Code__c);
        System.assertEquals('Canberra', australia.Capital_City__c);
        System.assertEquals('Oceania', australia.Region__c);
        System.assertEquals('61', australia.CallingCode__c);
    }

    @IsTest
    static void testUpsertCountriesFromCountryLayer_Failure() {
        Test.setMock(HttpCalloutMock.class, new CountryLayerMocks.MockHttpFailureResponse());

        Test.startTest();
        CountryLayerHandler.upsertCountriesFromCountryLayer();
        Test.stopTest();

        List<Country__c> countries = [SELECT Name FROM Country__c];
        System.assertEquals(0, countries.size(), 'No countries should be upserted due to failed callout');
    }
}