/**
   @author Original: Justyna F 
   @date Original: 11 Dec 2018
   @description Class to handle updates to Product_Brief__c object in order to grant access (Read/Write) to the creator of the Product Brief to all Custom Media Projects (Project__c) related to the same opportunity
*/

public with sharing class ProductBriefTriggerHandler{

	public static void on onAfterInsert(List<Product_Brief__c> productBriefs) {

		//for a start I assume there is one brief inserted. Probably I should work with lists and then maps, right?

		Product_Brief__c brief = productBriefs[0];
		String userId = brief.CreatedBy.Id;
		Opportunity__c opportunity = brief.Opportunity__c;
		List<Project__c> projectsToGrantAccessTo = new List<Project__c>;

		projectsToGrantAccessTo = [SELECT Id, Related_Opportunity__c FROM Project__c WHERE Related_Opportunity__c = :opportunity];

		List<Project__c__Share> projectShares = new List<Project__c__Share>;
		for(Project__c project: projectsToGrantAccessTo) {
			
			//Instantiate the sharing object
			creatorShare = new Project__c__Share();
			
			//Set the Id of record being shared
			creatorShare.ParentId = brief.Id;

			//Set the ID of user or group being granted access
			creatorShare.UserOrGroupId = userId;

			//Set the access level
			creatorShare.AccessLevel = 'All';

			//Add objects to list for insert
			projectShares.add(creatorShare);

		}

		Database.insert(projectShares, false); //Should I allow for partial processing?

		//Should I process the save results?





		/*List<User> usersToGrantAccessTo;
		List<Opportunity__c> opportunities;
		List<Project__c> projectsToGrantAccessTo;
		Map<User, Opportunity__c> usersWithOpportunities;

		for(Product_Brief__c brief: productBriefs) {
			/*usersToGrantAccessTo.add(brief.CreatedBy);
			opportunities.add(brief.Opportunity__c);*/
			/*usersWithOpportunities.put(brief.CreatedBy, brief.Opportunity__c);

		}

		Map<User, List<Project__c>> usersWithProjects;*/

	}

}
