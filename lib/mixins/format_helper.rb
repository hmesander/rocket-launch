# FormatHelper module provides methods for formatting numbers and times in human-readable formats.

module FormatHelper
  def format_number(number)
    number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  def format_time(time)
    Time.at(time).utc.strftime("%k:%M:%S").lstrip
  end
end