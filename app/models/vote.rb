class Vote < ActiveRecord::Base
  attr_accessible :campaign_id, :choice, :validity, :voted_at
end
