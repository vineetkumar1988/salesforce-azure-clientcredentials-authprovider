import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import  getImageBlob from '@salesforce/apex/ImageController.getImageBlob';

export default class UserImage extends LightningElement {
    imageURL;
    
    connectedCallback() {
        getImageBlob()
        .then((result) => {
            console.log( 'Data is ' + JSON.stringify( result ) );
            this.imageURL = result;
        })
        .catch((error) => {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading Account',
                    message,
                    variant: 'error', 
                }),
            );
        });
    }
}