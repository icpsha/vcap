class SystemMetric < ActiveRecord::Base
	belongs_to :app				#SAP a system metrics belongs to an application by app_id
end
