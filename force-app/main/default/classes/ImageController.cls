public with sharing class ImageController {
    public ImageController() {

    }

    @AuraEnabled
    public static string getImageBlob(){
        String blobString;
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://osbdocuments.blob.core.windows.net/sftest/a048d00000CHjgKAAT.png?sv=2019-12-12&ss=b&srt=sco&sp=r&se=2023-07-31T15:04:20Z&spr=https&sig=6xRnsHTqP5jcpiiNLm8AnO4tb%2FJ0Cg%2Fexde2%2FRnQ5g0%3D');
            req.setMethod('GET');
    
            Http http = new Http();
            HTTPResponse res = http.send(req);
            //System.debug(res.getBody());
            Blob imageblob = res.getBodyAsBlob();
            blobString = 'data:'+res.getHeader('Content-Type')+';base64,'+EncodingUtil.base64Encode(imageblob);
            // blobString = res.getBody();
            System.debug('#### blobString = '+blobString);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return blobString;
    }
}