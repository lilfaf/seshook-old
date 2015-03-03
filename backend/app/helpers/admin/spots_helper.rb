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

    def options_for_graph_period_select
      options_for_select([
        ['3 days',   3],
        ['1 week',   7],
        ['1 month',  30],
        ['6 months', 180],
        ['1 year',   365],
      ], 30)
    end
  end
end
