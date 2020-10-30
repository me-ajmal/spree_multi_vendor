module Spree
  module PermittedAttributes
    ATTRIBUTES << :vendor_attributes

    mattr_reader *ATTRIBUTES

    @@vendor_attributes = [:name, :about_us, :contact_us, :notification_email, :age, :category_id, :gender, :country, :paypal_id]
    @@vendor_attributes << :image if Spree.version.to_f >= 3.6
  end
end
