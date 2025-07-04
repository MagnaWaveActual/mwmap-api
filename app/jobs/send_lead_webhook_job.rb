class SendLeadWebhookJob < ApplicationJob
  queue_as :default

  # Do not retry on any StandardError
  discard_on StandardError

  def perform(user_data, practitioners)
    uri = URI.parse("https://infuly.com/newkeapapi/addmapleadtoapp.php")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")

    # Ensure we always have 3 practitioners
    while practitioners.size < 3
      practitioners << "none"
    end

    request = Net::HTTP::Post.new(uri.path)
    request.set_form_data(
      "AppName" => "gn179",
      "APIKey" => "KeapAK-0482b5739b2910688d181c875d14da43acab7a130ccc66d2c3",
      "UserFirstName" => user_data["first_name"],
      "UserLastName"  => user_data["last_name"],
      "UserEmail"     => user_data["email"],
      "UserPhone"     => user_data["phone"],
      "UserZip"       => user_data["zip"],
      "Practitioner1" => practitioners[0],
      "Practitioner2" => practitioners[1],
      "Practitioner3" => practitioners[2]
    )

    response = http.request(request)
    Rails.logger.info "Webhook response: #{response.code} #{response.body}"
  rescue => e
    Rails.logger.error "Webhook failed: #{e.message}"
    # discard_on ensures no retries
  end
end
