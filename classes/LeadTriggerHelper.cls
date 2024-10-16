
/**
 * Created by personal on 15.10.2024.
 */

public with sharing class LeadTriggerHelper {
    public LeadTriggerHelper() {}

    public void processLeadAddressData(List<Lead> newLeads, Map<Id, SObject> previousLeadMap) {
        Set<String> countriesToFetch = new Set<String>();
        List<Lead> leadsForUpdate = new List<Lead>();

        for (Lead currentLead : newLeads) {
            String previousCountry = previousLeadMap != null && previousLeadMap.containsKey(currentLead.Id)
                    ? ((Lead)previousLeadMap.get(currentLead.Id)).Country
                    : null;
            if (previousCountry == null || currentLead.Country != previousCountry) {
                leadsForUpdate.add(currentLead);
                countriesToFetch.add(currentLead.Country);
            }
        }

        if (!leadsForUpdate.isEmpty()) {
            Map<String, Country__c> countryInfoMap = retrieveCountryDetails(countriesToFetch);
            assignLeadCountryData(leadsForUpdate, countryInfoMap);
        }
    }

    public static Map<String, Country__c> retrieveCountryDetails(Set<String> countryNames) {
        Map<String, Country__c> countryDataMap = new Map<String, Country__c>();

        if (!countryNames.isEmpty()) {
            for (Country__c countryRecord : [
                    SELECT Name, Alpha2Code__c, Alpha3Code__c, Capital_City__c, Region__c, Regional_Blocs__c
                    FROM Country__c
                    WHERE Name IN :countryNames
            ]) {
                countryDataMap.put(countryRecord.Name, countryRecord);
            }
        }
        return countryDataMap;
    }

    public static void assignLeadCountryData(List<Lead> leadsToUpdate, Map<String, Country__c> countryInfoMap) {
        for (Lead leadRecord : leadsToUpdate) {
            Country__c matchingCountry = countryInfoMap.get(leadRecord.Country);
            if (leadRecord.Country != null && matchingCountry != null) {
                leadRecord.CountryAlpha2Code__c = matchingCountry.Alpha2Code__c;
                leadRecord.CountryAlpha3Code__c = matchingCountry.Alpha3Code__c;
                leadRecord.CapitalCity__c = matchingCountry.Capital_City__c;
                leadRecord.Region__c = matchingCountry.Region__c;
            }
        }
    }

}