defmodule Eightyfour.Utils do
  @moduledoc """
  Common utilities.
  """

  def parse_duration(:yesterday) do
    date = Timex.format!(Timex.shift(Timex.now, days: -1), "%Y-%m-%d", :strftime)
    {date, date}
  end

  def parse_duration(:last_week) do
    date_now = Timex.now
    date     = Timex.format!(Timex.shift(date_now, days: -7), "%Y-%m-%d", :strftime)
    date_now = Timex.format!(date_now, "%Y-%m-%d", :strftime)

    {date, date_now}
  end

  def parse_duration(:last_month) do
    date_now = Timex.now
    date     = Timex.format!(Timex.shift(date_now, months: -1), "%Y-%m-%d", :strftime)
    date_now = Timex.format!(date_now, "%Y-%m-%d", :strftime)

    {date, date_now}
  end

  def parse_duration(:last_year) do
    date_now = Timex.now
    date     = Timex.format!(Timex.shift(date_now, years: -1), "%Y-%m-%d", :strftime)
    date_now = Timex.format!(date_now, "%Y-%m-%d", :strftime)

    {date, date_now}
  end

  def parse_duration(:forever) do
    {Application.get_env(:eightyfour, :start_date), "2100-01-01"}
  end

  def parse_duration({start_date, end_date}) do
    {start_date, end_date}
  end

  def seconds_since_epoch do
    {mega_secs, secs, _} = :os.timestamp
    (mega_secs * 1_000_000) + secs
  end

  def one_hour_from_now do
    seconds_since_epoch + 3600
  end
end
