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

    response = api_get("", params)

    rows = for [os, browser, version, hits] <- response["rows"], do:
      [os: os, browser: browser, version: version, hits: hits]

    %{
      rows: rows,
      totals: %{
        visits: response["totalsForAllResults"]["ga:visits"]}
    }
  end

  @doc """
  Return total page views and visitors
  """
  def page_views(duration) do
    {start_date, end_date} = parse_duration(duration)

    dimensions =
      case duration do
        :yesterday -> "ga:hour"
        :last_week -> "ga:day"
        :last_month -> "ga:day"
        :forever -> "ga:isoYearIsoWeek"
      end

    params = %{
      "start-date": start_date,
      "end-date": end_date,
      "dimensions": dimensions,
      "metrics": "ga:pageviews, ga:visitors",
      "max-results": "10000"
    }

    response = api_get("", params)

    rows = for [dimension, pageviews, visitors] <- response["rows"], do:
      [dimension: dimension, pageviews: pageviews, visitors: visitors]

    %{
      rows: rows,
      totals: %{
        views: response["totalsForAllResults"]["ga:pageviews"],
        visitors: response["totalsForAllResults"]["ga:visitors"]}
    }
  end

  @doc """
  Return top referrals.

  Maximum returned results is set to 15 as default.
  """
  def referrals(duration, max_results \\ 15) do
    {start_date, end_date} = parse_duration(duration)

    params = %{
      "start-date": start_date,
      "end-date": end_date,
      "dimensions": "ga:source,ga:referralPath",
      "metrics": "ga:pageviews,ga:timeOnSite,ga:exits",
      "filters": "ga:medium==referral",
      "sort": "-ga:pageviews",
      "max-results": max_results,
    }

    response = api_get("", params)

    rows = for [source, referral_path, page_views,
                time_on_site, exits] <- response["rows"], do:
      [source: source, referral_path: referral_path,
       page_views: page_views, time_on_site: time_on_site, exits: exits]

    %{rows: rows}
  end
end