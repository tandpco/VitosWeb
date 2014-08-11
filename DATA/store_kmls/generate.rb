puts('    {')
puts('        "id" : ' + ARGV[0] + ',')
puts('        "coordinates" : [')
File.readlines("store#{ARGV[0]}.kml").each do |line|
    if(line =~ /-(83|84)/)
        coords = line.split(/,0 /)
        i = 0
        coords.each do |coord|
            xyPair = coord.split(',')

            if(xyPair[0] =~ /\s+/)
                xyPair[0].gsub!(/\s+/, '')
            end
            if(xyPair[1] =~ /\s+/)
                xyPair[1].gsub!(/\s+/, '')
            end

            if(xyPair[0].length > 0)
                if(i > 0)
                    puts('            },')
                end

                puts('            {')
                puts('                "x" : ' + xyPair[0] + ',')
                puts('                "y" : ' + xyPair[1])
            end
            i += 1
        end
        puts('            }')
    end
end
puts('        ]')
puts('    },')
