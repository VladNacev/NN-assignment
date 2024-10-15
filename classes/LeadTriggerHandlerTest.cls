/**
 * Created by personal on 15.10.2024.
 */
@IsTest
public with sharing class LeadTriggerHandlerTest {

    @TestSetup
    static void prepareTestData() {
        Country__c france = new Country__c(Name = 'France', Alpha2Code__c = 'FR', Alpha3Code__c = 'FRA', Capital_city__c = 'Paris', Region__c = 'Europe');
        Country__c japan = new Country__c(Name = 'Japan', Alpha2Code__c = 'JP', Alpha3Code__c = 'JPN', Capital_city__c = 'Tokyo', Region__c = 'Asia');
        Country__c brazil = new Country__c(Name = 'Brazil', Alpha2Code__c = 'BR', Alpha3Code__c = 'BRA', Capital_city__c = 'Brasilia', Region__c = 'South America');
        insert new List<Country__c> { france, japan, brazil };

        Lead leadX = new Lead(LastName = 'Dupont', Company = 'Company X', Country = 'France');
        Lead leadY = new Lead(LastName = 'Tanaka', Company = 'Company Y', Country = 'Japan');
        Lead leadZ = new Lead(LastName = 'Silva', Company = 'Company Z', Country = 'Brazil');
        insert new List<Lead> { leadX, leadY, leadZ };
    }

    @IsTest
    static void testProcessLeadAddressData_CountryChanged() {
        List<Lead> fetchedLeads = [SELECT Id, Country FROM Lead WHERE LastName IN ('Dupont', 'Tanaka')];
        Map<Id, Lead> priorLeadDataMap = new Map<Id, Lead>();

        priorLeadDataMap.put(fetchedLeads[0].Id, new Lead(Id = fetchedLeads[0].Id, Country = 'Japan')); // LeadX's country changed

        Test.startTest();
        LeadTriggerHelper leadTriggerHelper = new LeadTriggerHelper();
        leadTriggerHelper.processLeadAddressData(fetchedLeads, priorLeadDataMap);
        Test.stopTest();

        Lead leadXUpdated = [SELECT CountryAlpha2Code__c, CountryAlpha3Code__c, CapitalCity__c, Region__c FROM Lead WHERE Id = :fetchedLeads[0].Id];
        Lead leadYUpdated = [SELECT CountryAlpha2Code__c, CountryAlpha3Code__c, CapitalCity__c, Region__c FROM Lead WHERE Id = :fetchedLeads[1].Id];

        System.assertEquals('FR', leadXUpdated.CountryAlpha2Code__c, 'LeadX Country Alpha2Code__c should be updated to FR');
        System.assertEquals('FRA', leadXUpdated.CountryAlpha3Code__c, 'LeadX Country Alpha3Code__c should be updated to FRA');
        System.assertEquals('Paris', leadXUpdated.CapitalCity__c, 'LeadX CapitalCity__c should be updated to Paris');
        System.assertEquals('Europe', leadXUpdated.Region__c, 'LeadX Region__c should be updated to Europe');

        System.assertEquals('JP', leadYUpdated.CountryAlpha2Code__c, 'LeadY Country Alpha2Code__c should remain JP');
        System.assertEquals('JPN', leadYUpdated.CountryAlpha3Code__c, 'LeadY Country Alpha3Code__c should remain JPN');
        System.assertEquals('Tokyo', leadYUpdated.CapitalCity__c, 'LeadY CapitalCity__c should remain Tokyo');
        System.assertEquals('Asia', leadYUpdated.Region__c, 'LeadY Region__c should remain Asia');
    }

    @IsTest
    static void testProcessLeadAddressData_NoChange() {
        List<Lead> fetchedLeads = [SELECT Id, Country, CountryAlpha2Code__c, CountryAlpha3Code__c, CapitalCity__c, Region__c FROM Lead WHERE LastName = 'Silva'];
        Lead leadToReset = fetchedLeads[0];
        leadToReset.CountryAlpha2Code__c = null;
        leadToReset.CountryAlpha3Code__c = null;
        leadToReset.CapitalCity__c = null;
        leadToReset.Region__c = null;
        update leadToReset;

        Map<Id, Lead> priorLeadDataMap = new Map<Id, Lead>();

        priorLeadDataMap.put(fetchedLeads[0].Id, new Lead(Id = fetchedLeads[0].Id, Country = 'Brazil'));

        Test.startTest();
        LeadTriggerHelper leadTriggerHelper = new LeadTriggerHelper();
        leadTriggerHelper.processLeadAddressData(fetchedLeads, priorLeadDataMap);
        Test.stopTest();

        Lead leadUpdated = [SELECT CountryAlpha2Code__c, CountryAlpha3Code__c, CapitalCity__c, Region__c FROM Lead WHERE Id = :fetchedLeads[0].Id];

        System.assertEquals(null, leadUpdated.CountryAlpha2Code__c, 'Country Alpha2Code__c should not be set');
        System.assertEquals(null, leadUpdated.CountryAlpha3Code__c, 'Country Alpha3Code__c should not be set');
        System.assertEquals(null, leadUpdated.CapitalCity__c, 'CapitalCity__c should not be set');
        System.assertEquals(null, leadUpdated.Region__c, 'Region__c should not be set');
    }
}