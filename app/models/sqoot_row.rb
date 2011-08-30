class SqootRow < ActiveRecord::Base
  serialize :row_data
  serialize :row_errors

  belongs_to :import
  belongs_to :offer
end
