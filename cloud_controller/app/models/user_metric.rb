class UserMetric < ActiveRecord::Base
	belongs_to :app				#SAP a user metrics belongs to an application by app_id
end
