module Admin
  module SpotsHelper
    def status_label(spot)
      class_name = case spot.status
                   when 'approved' then 'success'
                   when 'rejected' then 'danger'
                   else 'default'
                   end
      content_tag(:span, class: "label label-#{class_name}") do
        spot.status.capitalize
      end
    end
  end
end

