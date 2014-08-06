require 'json'
row      = Hash.new()
jsonData = Array.new()

ARGF.each do |line|
    line.chomp!

    if(line =~ /^\s*$/)
        jsonRow = Hash.new()
        jsonRow['IsActive']                      = true
        jsonRow['RADRAT']                        = "2011-08-01T11:44:02Z"
        jsonRow['SauceModifierDescription']      = row['SideDescription']
        jsonRow['SauceModifierID']               = row['SideID'].to_i
        jsonRow['SauceModifierShortDescription'] = row['SideDescription']
        jsonRow['id']                            = nil

        jsonData.push(jsonRow)

        row = Hash.new()
    else
        #puts(line)
        (key, value) = line.split(/:\s+/)

        row[key] = value
    end

end

puts(jsonData.to_json)
