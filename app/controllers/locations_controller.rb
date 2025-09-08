class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :update, :destroy]

  # GET /locations
  def index
    @locations = Location.all

    render json: @locations, each_serializer: LocationSerializerAdmin
  end

  # GET /locations/1
  def show
    render json: @location, each_serializer: LocationSerializerAdmin
  end

  def list_inactive_locations
    locations = Location.where(location_type: params[:location_type], location_active: false)

    render json: locations, each_serializer: LocationSerializerAdmin
  end

  def find_my_map_locations
    locations = Location.where(email: params[:email])
    render json: locations
  end

  def send_test_email
    LocationMailer.test_email().deliver_now
  end

  def find_location_by_state

    state_abbreviations = {
      "Alabama" => "AL", "Alaska" => "AK", "Arizona" => "AZ", "Arkansas" => "AR", "California" => "CA",
      "Colorado" => "CO", "Connecticut" => "CT", "Delaware" => "DE", "Florida" => "FL", "Georgia" => "GA",
      "Hawaii" => "HI", "Idaho" => "ID", "Illinois" => "IL", "Indiana" => "IN", "Iowa" => "IA",
      "Kansas" => "KS", "Kentucky" => "KY", "Louisiana" => "LA", "Maine" => "ME", "Maryland" => "MD",
      "Massachusetts" => "MA", "Michigan" => "MI", "Minnesota" => "MN", "Mississippi" => "MS", "Missouri" => "MO",
      "Montana" => "MT", "Nebraska" => "NE", "Nevada" => "NV", "New Hampshire" => "NH", "New Jersey" => "NJ",
      "New Mexico" => "NM", "New York" => "NY", "North Carolina" => "NC", "North Dakota" => "ND", "Ohio" => "OH",
      "Oklahoma" => "OK", "Oregon" => "OR", "Pennsylvania" => "PA", "Rhode Island" => "RI", "South Carolina" => "SC",
      "South Dakota" => "SD", "Tennessee" => "TN", "Texas" => "TX", "Utah" => "UT", "Vermont" => "VT",
      "Virginia" => "VA", "Washington" => "WA", "West Virginia" => "WV", "Wisconsin" => "WI", "Wyoming" => "WY"
    }
    
    full_state_name = params[:address_state].strip
    abbreviation = state_abbreviations[full_state_name]

    if abbreviation.nil?
      render json: { error: "Invalid state name" }, status: :bad_request
      return
    end

    # Search for locations where address_state contains either the full state name or the abbreviation
    locations = Location.where("LOWER(address_state) LIKE ? OR LOWER(address_state) LIKE ?", 
                               "%#{full_state_name.downcase}%", "%#{abbreviation.downcase}%")
                        .where(location_active: true)
    render json: locations
  end

  def find_map_locations
    locations = Location.where(location_type: params[:location_type], location_active: true).within(params[:range], :units => :miles, :origin => [params[:search_lat], params[:search_long]])
   
    # @sorted_locations = locations.sort_by { |l| l["rank"]}.reverse
    @sorted_locations = locations.sort_by{|l| l.distance_to([params[:search_lat], params[:search_long]])}
   
    @selected = @sorted_locations.select {|location| location["rank"] > 0}

    if params[:consent]
      if @selected.empty?
        @sorted_locations.take(3).each do |l|
         # p "condition 1 no purchased leads"
        
         # new_phone = params[:s_phone].chars.drop(3).join
         # p new_phone
          LocationMailer.lead_for_all_email(l[:email], params[:s_name], params[:s_email], params[:message]).deliver_later
        end

      else
        has_purchased = @selected.select { |l| l["purchased_lead_count"] > 0 }
        owed_leads = has_purchased.select { |l| l["delivered_lead_count"] < l["purchased_lead_count"] }

        if !has_purchased.empty? && !owed_leads.empty?
          
          @prime_location = owed_leads.first
    
          owed_leads.each do |l|
            prime_ratio = @prime_location[:delivered_lead_count].to_f / @prime_location[:purchased_lead_count]
            l_ratio = l[:delivered_lead_count].to_f / l[:purchased_lead_count]
            if prime_ratio > l_ratio
              @prime_location = l
            end
          end
          p "condition 2 we owe this person leads"
        
        LocationMailer.lead_for_one_email(@prime_location[:email], @prime_location[:name], params[:s_name], params[:s_phone], params[:s_email], params[:s_message]).deliver_now
        
          @prime_location[:delivered_lead_count] = @prime_location[:delivered_lead_count] + 1

          @prime_location.save
       else
          @sorted_locations.take(3).each do |l|
           # p "condition 3 we have ranked practitioners but do not owe leads"
             # new_phone = params[:s_phone].chars.drop(3).join
              #p new_phone
             LocationMailer.lead_for_all_email(l[:email], params[:s_name], new_phone, params[:s_email], params[:message]).deliver_later
          end
       end
      end
    end
    
    
    render json: @sorted_locations
  end

  def search_again
    locations = Location.where(location_type: params[:location_type], location_active: true).within(params[:range], :units => :miles, :origin => [params[:search_lat], params[:search_long]])
   
    @sorted_locations = locations.sort_by { |l| l["rank"]}.reverse
    # take first item from array. if has rank > 0 this will be our sponcered practitioner. 
    # add this to the first of the array of locatoins. 
   
    @newLocations = locations.sort_by{|l| l.distance_to([params[:search_lat], params[:search_long]])}


    render json: @newLocations
  end

  def kill_em_all 
    # @locations = Location.all
    # @locations.each do |l|
    #   l.destroy
    # end
    # render json: @locations

  end


  # POST /locations
  def create
    @location = Location.new(location_params)

    if !params[:service_types].nil?
      params[:service_types].each do |t|
        @location[:service_types] << t
      end
    end

    if @location.save
      render json: @location, status: :created, location: @location
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end


  # PATCH/PUT /locations/1
  def update
    if !params[:service_types].nil?
      @location[:service_types] = []
        params[:service_types].each do |t|
          @location[:service_types] << t
        end
   end

    if @location.update(location_params)
      render json: @location, serializer: LocationSerializerAdmin
    else
      render json: @location.errors, status: :unprocessable_entity
    end

  end

  # DELETE /locations/1
  def destroy
    @location.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def location_params
      params.require(:location).permit(:name, :latitude, :longitude, :wp_user_id, :location_type, 
                                        :image, :web, :social_one, :social_two, :email, :phone, :calendly, 
                                        :range, :search_lat, :search_long, :service_types, :address_l1, :address_l2, 
                                        :address_state, :address_city, :address_zip, :rank, :purchased_lead_count,
                                        :delivered_lead_count, :next_purchased_lead_count, :cms_id, :location_active, 
                                        :description, :s_name, :s_email, :s_phone, :s_message, :consent)
    end
end
