import { LightningElement, wire} from 'lwc';
import setCustomSettings from '@salesforce/apex/CustomSettings_CTRL.setCustomSettings';
import getCustomSettings from '@salesforce/apex/CustomSettings_CTRL.getCustomSettings';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class APIConfiguration extends LightningElement {

	createKey = ''; 
	deleteKey = '';
	stopKey = '';
	updateKey = '';
	workspaceId = '';
	logsLifetime = null;

	@wire(getCustomSettings, {})
	wiredGetCustomSettings({error,data}) {
		if(data) {
			this.createKey = data["Signing_Create_Key__c"]; 
			this.deleteKey = data["Signing_Delete_Key__c"];
			this.stopKey = data["Signing_Stop_Key__c"];
			this.updateKey = data["Signing_Update_Key__c"];
			this.workspaceId = data["workspaceId__c"];
			this.logsLifetime = data["LogsLifeTime__c"];
		}else if(error) {
			console.error("error: " + error);
		}
	}

	handleChangeCreateKey(event) {
		this.createKey = event.target.value;
	}

	handleChangeDeleteKey(event) {
		this.deleteKey = event.target.value;
	}

	handleChangeStopKey(event) {
		this.stopKey = event.target.value;
	}

	handleChangeUpdateKey(event) {
		this.updateKey = event.target.value;
	}

	handleChangeWorkspaceId(event) {
		this.workspaceId = event.target.value;
	}

	handleChangeLogsLifetime(event) {
		this.logsLifetime = event.target.value;
	}

	async save() {
		await setCustomSettings({logsLifetime: this.logsLifetime, 
								workspaceId: this.workspaceId, 
								updateKey: this.updateKey,
								stopKey: this.stopKey,
								deleteKey: this.deleteKey,
								createKey: this.createKey}).then(response => {
			this.showNotification(response, 'success')
		}).catch(error => {
			this.showNotification('Error: ' + error.body.message, 'error');
		})
	}
	showNotification(response, type) {
		const evt = new ShowToastEvent({
		  title: 'Result',
		  message: response,
		  variant: type,
		  mode: 'pester'
		});
		this.dispatchEvent(evt);
	}
}