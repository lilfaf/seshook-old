class AdminChart
  attr_reader :period, :from

  def initialize(days = 30)
    @period = days.to_i
    @from   = period.days.ago
  end

  def stats_for(models)
    models.map { |c| stats_for_model(c) }
  end

  def stats_for_model(model)
    data = case (period > 30 ? :month : :day)
           when :day   then model.created_by_day(from)
           when :month then model.created_by_month(from)
           end
    {name: model.name, data: data.count}
  end
end
