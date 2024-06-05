trigger caseTrigger on Case (after insert, after Delete) {
    
    Set<string> setOfEmailAddress = new Set<string>(); //stores the email address on newly created case
    
    if(trigger.isInsert && trigger.isAfter){
        if(!trigger.new.isEmpty()){
            for(Case c : trigger.new){
                if(c.SuppliedEmail != null){
                    setOfEmailAddress.add(c.SuppliedEmail);
                }
            }
            System.debug('@@setOfEmailAddress'+setOfEmailAddress);
            //@MapOfEmailAndContact: stores the email and the list of contacts associated with the supplied email from case
            Map<string,list<Contact>> MapOfEmailAndContact = new Map<string,list<Contact>>();
            for(Contact con : [Select Id , Email from Contact Where Email IN:setOfEmailAddress ]){
                if(!MapOfEmailAndContact.containsKey(con.Email)){
                    MapOfEmailAndContact.put(con.Email, new List<contact>());
                }
                MapOfEmailAndContact.get(con.Email).add(con);
            }
            System.debug('@@MapOfEmailAndContact'+MapOfEmailAndContact);
            
            List<Contact> contactsToUpdate = new List<Contact>();
            List<Contact> contactsToInsert = new List<Contact>();
            
            for(Case c: trigger.new){
                if(c.SuppliedEmail != null){
                    if(MapOfEmailAndContact.containsKey(c.SuppliedEmail)){
                       System.debug('@@checkContainsKey'+MapOfEmailAndContact.containsKey(c.SuppliedEmail));
                        contactsToUpdate = MapOfEmailAndContact.get(c.SuppliedEmail);
                        System.debug('@@contactsToUpdate'+contactsToUpdate);
                    }
                    else {
                        Contact contToInsert = new Contact (
                        	lastName ='CaseTriggerInsertContact',
                            Email = c.SuppliedEmail
                        );
                        contactsToInsert.add(contToInsert);
                        System.debug('@@contactsToInsert'+contactsToInsert);
                    }
                }
            }
	
            if(!contactsToUpdate.isEmpty()){
                Update contactsToUpdate;
            }
			if(!contactsToInsert.isEmpty()){
                insert contactsToUpdate;
            }             
        }
    }
    
    
    
}   

/* Map<string, Contact> MapOfEmailAndContact = new Map<string, Contact>();
for(Contact con : [Select Id , Email from Contact where Email IN:MapOfEmailAndCase.keyset() ]){
MapOfEmailAndContact.put(con.Email, con);
}
System.debug('@@MapOfEmailAndContact'+MapOfEmailAndContact);
if(trigger.isAfter && trigger.isInsert){
if(!trigger.new.isEmpty()){
CaseTriggerHelperClass.populateCaseOnAccount(trigger.new);
}
}
if(trigger.isAfter && trigger.isDelete){
if(!trigger.new.isEmpty()){
CaseTriggerHelperClass.populateCaseOnAccount(trigger.old);
}
}*/