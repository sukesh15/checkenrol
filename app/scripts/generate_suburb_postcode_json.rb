# Run this script to generate a json file for use by the 'Suburb & Postcode' autocomplete
# Place the generted file in /public. You may need to rename it to bust any caches.

STATES_BY_CODE = {
"N"=>"NSW",
"V"=>"VIC",
"Q"=>"QLD",
"A"=>"ACT",
"T"=>"TAS",
"S"=>"SA",
"W"=>"WA",
"D"=>"NT"
}

 current_dir = File.expand_path(File.dirname(__FILE__))
 File.open("#{current_dir}/AEC_postcodes_and_suburbs.json", "w") do |json_file|
     json_file.puts("var suburbs = [")
     File.open("#{current_dir}/LO15_National_D130111.txt", "r") do |input_file|
       input_file.readline #discard header
       delim = " "
       input_file.each_line do |locality_line|
          locality_details = locality_line.split(";")
          state = STATES_BY_CODE[locality_details[0]]
          locality_name = locality_details[2].strip
          postcode = locality_details[3].strip
          json_file.puts "#{delim}\"#{postcode} - #{locality_name} (#{state})\""
          delim=","
       end
     end
     json_file.puts("]")
 end