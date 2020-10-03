module Spree
  class FanStatus < Spree::Base
    has_many :fans, class_name: 'Spree::User'
    has_many :vendors, class_name: 'Spree::Vendor'
  end
end