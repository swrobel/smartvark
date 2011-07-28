class YipitRow < ActiveRecord::Base
  serialize :data
  serialize :errors

  belongs_to :import
  belongs_to :offer
end
