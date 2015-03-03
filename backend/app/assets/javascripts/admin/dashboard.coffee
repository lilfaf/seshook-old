#= require bootstrap-select
#= require highcharts
#= require chartkick
#= require js-routes

jQuery ->
  # Bind to graph period select event
  graph_period = $('#graph_period')
  if graph_period.length
    graph_period.change ->
      new Chartkick.LineChart(
        'dashboard_chart',
        Routes.admin_dashboard_chart_data_path(days: @value)
      )
