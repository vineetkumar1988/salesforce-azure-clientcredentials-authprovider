public class WatermarkDemoController{
    
    public String imageUrl{get; set;}
    
    public WatermarkDemoController(){
        String recordId = ApexPages.currentPage().getParameters().get('AccountId');
        ContentDocumentLink cdlObject = new ContentDocumentLink();
        ContentVersion cvObject = new ContentVersion();
        if(String.isNotBlank(recordId)){
            for(ContentDocumentLink thisRecord : [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: recordId LIMIT 1]){
                cdlObject = thisRecord;
                break;
            }
            if(cdlObject.ContentDocumentId != null){
                for(ContentVersion thisRecord : [SELECT Id, ContentDocumentId, VersionData FROM ContentVersion WHERE ContentDocumentId =: cdlObject.ContentDocumentId LIMIT 1]){
                    cvObject = thisRecord;
                    break;
                }
                imageUrl = '/sfc/servlet.shepherd/version/download/' + cvObject.Id;
            }
        }
    }
}// End of class.