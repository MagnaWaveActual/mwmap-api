class LocationSerializerAdmin < ActiveModel::Serializer
  attributes :id, :wp_user_id, :cms_id, :name, :location_type, :description, :email, :phone, :image, :web, :social_one, :social_two, :calendly,
            :service_types, :latitude, :longitude, :address_l1, :address_l2, :address_state, :address_city, :address_zip, :rank, :purchased_lead_count,
            :delivered_lead_count, :next_purchased_lead_count, :location_active, :rank
end
