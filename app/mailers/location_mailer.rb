class LocationMailer < ApplicationMailer

    def lead_for_all_email(email, s_name, s_phone, s_email, message)
      
        @s_name = s_name
        @s_email = s_email
        @s_phone = s_phone
        @s_message = message

        p @s_phone
        p s_phone
        mail(to: email, subject: "New Map Lead")
  
      end
  
  
      def lead_for_one_email(email, business_name, s_name, s_phone, s_email, message)
     
        @s_name = s_name
        @s_email = s_email
        @s_phone = s_phone
        @b_name = business_name
        @s_message = message
        mail(to: email, subject: "New Exclusive Map Lead")
  
      end

      def test_email()
       
        delivery_options = { user_name: "leads@magnawaveportal.com",
                         password: "MagnaWave1!2024",
                         address: "smtp.mailgun.org",
                        port: 587,
                      domain: "magnawaveportal.com"}
        mail(to: "alex@magnawavepemf.com", subject: "Test MW Email")
      end

end
