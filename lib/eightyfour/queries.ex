defmodule Eightyfour.Query do
  @moduledoc """
  Query module for Google Analytics API

  All functions accept `duration` which must be one of:

    * `:yesterday`
    * `:last_week`
    * `:last_month`
    * `:forever`

  """
  import Eightyfour.Client, only: [api_get: 2]
  import Eightyfour.Utils

  def fetch(query, params) do
    case Eightyfour.QueryCache.get(query) do
      [] ->
        response = api_get("", params)
        Eightyfour.QueryCache.put(query, response["rows"])
        response["rows"]
      [{_, _, result}] ->
        result
    end
  end

  @doc """
  Return browsers/OS used
  """
  def browsers(duration) do
    {start_date, end_date} = parse_duration(duration)
    params = %{
      "start-date": start_date,
      "end-date": end_date,
      "dimensions": "ga:operatingSystem,ga:browser,ga:browserVersion",
      "metrics": "ga:visits",
      "sort": "-ga:visits",
      "max-results": "10000"
    }
    result = fetch({:browsers, {start_date, end_date}}, params)

    for [os, browser, version, hits] <- result, do:
      [os: os, browser: browser, version: version, hits: hits]
  end

  @doc """
  Return total pageviews since forever
  """
  def page_views(:total) do
    {start_date, end_date} = parse_duration(:forever)

    params = %{
      "start-date"  => start_date,
      "end-date"    => end_date,
      "dimensions"  => "",
      "metrics"     => "ga:pageviews",
      "max-results" => "10000"
    }

    result = fetch({:page_views, {start_date, end_date}}, params)

    if result do
      result
      |> List.flatten
      |> List.first
    else
      "0"
    end
  end

  @doc """
  Return yesterday's total pageviews
  """
  def page_views(:yesterday) do
    {start_date, end_date} = parse_duration(:yesterday)

    params = %{
      "start-date"  => start_date,
      "end-date"    => end_date,
      "dimensions"  => "",
      "metrics"     => "ga:pageviews",
      "max-results" => "10000"
    }

    result = fetch({:page_views, {start_date, end_date}}, params)

    if result do
      result
      |> List.flatten
      |> List.first
    else
      "0"
    end
  end

  @doc """
  Return total page views and visitors
  """
  def page_views(duration) do
    {start_date, end_date} = parse_duration(duration)

    dimensions =
      case duration do
        :yesterday  -> "ga:hour"
        :last_week  -> "ga:dayOfWeek"
        :last_month -> "ga:day"
        :forever    -> "ga:isoYearIsoWeek"
      end

    params = %{
      "start-date"  => start_date,
      "end-date"    => end_date,
      "dimensions"  => dimensions,
      "metrics"     => "ga:pageviews, ga:visitors",
      "max-results" => "10000"
    }

    result = fetch({:page_views, {start_date, end_date}}, params)

    unless result == nil do
      for [dimension, pageviews, visitors] <- result, do:
        [dimension: dimension, pageviews: pageviews, visitors: visitors]
    end
  end

  @doc """
  Return top referrals.

  Maximum returned results is set to 15 as default.
  """
  def referrals(duration, max_results \\ 15) do
    {start_date, end_date} = parse_duration(duration)

    params = %{
      "start-date"  => start_date,
      "end-date"    => end_date,
      "dimensions"  => "ga:source,ga:referralPath",
      "metrics"     => "ga:pageviews,ga:timeOnSite,ga:exits",
      "filters"     => "ga:medium==referral",
      "sort"        => "-ga:pageviews",
      "max-results" => max_results,
    }

    result = fetch({:referrals, {start_date, end_date}}, params)

    unless result == nil do
      for [source, referral_path, page_views, time_on_site, exits] <- result, do:
        [source: source, referral_path: referral_path,
         page_views: page_views, time_on_site: time_on_site, exits: exits]
    end
  end
end
