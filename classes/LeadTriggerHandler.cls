/**
 * Created by personal on 15.10.2024.
 */

public with sharing class LeadTriggerHandler implements TriggerHandler{
    private Boolean triggerIsExecuting;
    private Integer triggerSize;
    public LeadTriggerHelper helper;

    public LeadTriggerHandler(Boolean triggerIsExecuting, Integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
        this.helper = new LeadTriggerHelper();
    }
    public void beforeInsert(List<Lead> newLeads) {
        helper.processLeadAddressData(newLeads, null);
    }
    public void beforeUpdate(List<Lead> oldLeads, List<Lead> newLeads, Map<Id, SObject> oldLeadMap, Map<Id, SObject> newLeadMap) {
        helper.processLeadAddressData(newLeads, oldLeadMap);
    }
    public void beforeDelete(List<Lead> oldLeads, Map<Id, SObject> oldLeadMap) {

    }
    public void afterInsert(List<Lead> newLeads, Map<Id, SObject> newLeadMap) {

    }
    public void afterUpdate(List<Lead> oldLeads, List<Lead> newLeads, Map<Id, SObject> oldLeadMap, Map<Id, SObject> newLeadMap) {

    }
    public void afterDelete(List<Lead> oldLeads, Map<Id, SObject> oldLeadMap) {

    }
    public void afterUndelete(List<Lead> newLeads, Map<Id, SObject> newLeadMap) {

    }
}