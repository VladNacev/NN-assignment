trigger LeadTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if (Org_Settings__mdt.getInstance('Run_Triggers')?.Value__c == true) {
        TriggerHandler handler = new LeadTriggerHandler(Trigger.isExecuting, Trigger.size);
        switch on Trigger.operationType {
            when BEFORE_INSERT {
                handler.beforeInsert(Trigger.new);
            }
            when BEFORE_UPDATE {
                handler.beforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
            }
            when BEFORE_DELETE {
            }
            when AFTER_INSERT {
            }
            when AFTER_UPDATE {
            }
            when AFTER_DELETE {
            }
            when AFTER_UNDELETE {
            }
        }
    }
}