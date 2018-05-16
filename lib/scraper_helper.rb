module ScraperHelper
  def parse_short_datetime(datetime_string)
    DateTime.strptime(datetime_string + ' EST', '%m/%d/%Y %I:%M:%S %p %z').utc
  end

  def parse_long_datetime(datetime_string)
    DateTime.parse(datetime_string + ' EST').utc
  end
end
