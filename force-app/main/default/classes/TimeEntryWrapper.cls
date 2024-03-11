public class TimeEntryWrapper{
	public String createdAt;	
	public String name;	
	public String avatar;	
	public String id;	
	public String description;	
	public String userId;	
	public boolean billable;
	public String projectId;	
	public cls_timeInterval timeInterval;
	public String workspaceId;	
	public boolean isLocked;
	public cls_hourlyRate hourlyRate;
	public cls_costRate costRate;
	public cls_customFieldValues[] customFieldValues;
	public String type;	
	public cls_kioskId kioskId;
	public cls_projectCurrency projectCurrency;
	public boolean currentlyRunning;
	public cls_project project;
	public cls_task task;
	public cls_user user;
	public cls_tags[] tags;
	public class cls_timeInterval {
		public String start;	
		public String end_x;	
		public String duration;	
	}
	public class cls_hourlyRate {
	}
	public class cls_costRate {
	}
	public class cls_customFieldValues {
		public String customFieldId;	
		public String timeEntryId;	
		public String value;	
		public String name;	
	}
	public class cls_kioskId {
	}
	public class cls_projectCurrency {
	}
	public class cls_project {
		public String name;	
		public String clientId;	
		public String workspaceId;	
		public boolean billable;
		public cls_estimate estimate;
		public String color;	
		public boolean archived;
		public String clientName;	
		public String duration;	
		public String note;	
		public String activeEstimate;	
		public cls_timeEstimate timeEstimate;
		public cls_budgetEstimate budgetEstimate;
		public cls_estimateReset estimateReset;
		public String id;	
		public boolean public_x;
		public boolean template;
	}
	public class cls_estimate {
		public String estimate;	
		public String type;	
	}
	public class cls_timeEstimate {
		public boolean includeNonBillable;
		public Integer estimate;	
		public String type;	
		public cls_resetOption resetOption;
	}
	public class cls_resetOption {
	}
	public class cls_budgetEstimate {
	}
	public class cls_estimateReset {
	}
	public class cls_task {
		public String name;
		public String projectId;
		public String assigneeId;
		public String[] assigneeIds;
		public String[] userGroupIds;
		public String estimate;
		public String status;
		public String workspaceId;
		public Integer budgetEstimate;
		public boolean billable;
		public cls_hourlyRate hourlyRate;
		public cls_costRate costRate;
		public String id;
		public String duration;
	}
	public class cls_user {
		public String id;
		public String name;
		public String status;
	}
	public class cls_tags {
	}
	public static TimeEntryWrapper parse(String json){
        json = json.replaceAll('end', 'end_x');
        json = json.replaceAll('public', 'public_x');
		return (TimeEntryWrapper) System.JSON.deserialize(json, TimeEntryWrapper.class);
	}
}