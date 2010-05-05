class Category < ActiveRecord::Base
  has_many :offers

  def to_param
    "#{id}-#{CGI.escape(name)}"
  end
end
