//21-11-2024
trigger LeadTrigger on Lead (before insert) {

    if(trigger.isBefore && trigger.isInsert){
        if(!trigger.new.isEmpty()){
            for(Lead ld : trigger.new){
                if(ld.leadSource == 'Other'){
                    ld.rating = 'cold';
                } 
                else{
                    ld.rating = 'Hot';
                }
            }
        }
    }
}
