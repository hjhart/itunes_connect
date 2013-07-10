require 'dotenv'
Dotenv.load

require 'date'

email = ENV['ITC_EMAIL']
password = ENV['ITC_PASSWORD']
vendor_id = ENV['ITC_VENDOR_ID']
prowl_api_key = ENV['PROWL_API_KEY']

date = (Date.today - 1).strftime("%Y%m%d")

command = "itc_autoingest #{email} #{password} #{vendor_id} Sales Daily Summary #{date}"
puts "Executing #{command}"
output = `#{command}`

puts last_line = output.split("\n").last

if(last_line[/no reports available/])
  message = "No units sold on #{date}. :("
else
  units_sold = last_line.split[7]
  message = "You sold #{units_sold} on #{date}"
end

prowl_command = "prowly -k #{prowl_api_key} -a 'App Store' -e 'EggWich' -d '#{message}' -p NORMAL"
puts "Executing #{prowl_command}"
`#{prowl_command}`


