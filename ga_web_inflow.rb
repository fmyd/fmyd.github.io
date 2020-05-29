require 'pp'
require 'google/apis/analyticsreporting_v4'

#view_id = '218814541'
 view_id = '219066058'
scope = ['https://www.googleapis.com/auth/analytics.readonly']
analytics =Google::Apis::AnalyticsreportingV4

client = analytics::AnalyticsReportingService.new
client.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: File.open('atomic-quasar-277621-62f1fe800d95.json'),
  scope: scope
)

date_range = analytics::DateRange.new(start_date: '7DaysAgo', end_date: 'today')

dimension1 = analytics::Dimension.new(name: 'ga:date')
dimension2 = analytics::Dimension.new(name: 'ga:hour')
dimension3 = analytics::Dimension.new(name: 'ga:minute')
dimension4 = analytics::Dimension.new(name: 'ga:channelGrouping')
dimension5 = analytics::Dimension.new(name: 'ga:keyword')
dimension6 = analytics::Dimension.new(name: 'ga:landingPagePath') 
dimension7 = analytics::Dimension.new(name: 'ga:clientId')
metric = analytics::Metric.new(expression: 'ga:sessions')

request = analytics::GetReportsRequest.new(
  report_requests: [analytics::ReportRequest.new(
    view_id: view_id,
    metrics: [metric],
    dimensions: [dimension1,dimension2,dimension3,dimension4,dimension5,dimension6,dimension7],
    date_ranges: [date_range]
  )]
)
 response = client.batch_get_reports(request)
 data = response.reports.first.data

puts "timestamp | channel | keyword} | lp | client_id | inflow"
data.rows.each do |row|
  timestamp = "#{row.dimensions[0]}:#{row.dimensions[1]}:#{row.dimensions[2]}"
  channel = "#{row.dimensions[3]}"
  keyword = "#{row.dimensions[4]}"
  lp = "#{row.dimensions[5]}"
  client_id = "#{row.dimensions[6]}"
  inflow = "#{row.metrics.first.values.first}"
  
  puts "#{timestamp} | #{channel} | #{keyword} | #{lp} | #{client_id} | #{inflow} "
end
