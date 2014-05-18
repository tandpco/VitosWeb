require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblmarqueeController
    public
    def self.create(data)
        tblmarquee = Tblmarquee.create( :MarqueeID => data['MarqueeID'], :MarqueeMain => data['MarqueeMain'], :MarqueeSub => data['MarqueeSub'], :RADRAT => data['RADRAT'], :StartDate => data['StartDate'], :HalfID => data['HalfID'] )

        tblmarqueeJson = { :id => tblmarquee.id, :MarqueeID => tblmarquee.MarqueeID, :MarqueeMain => tblmarquee.MarqueeMain, :MarqueeSub => tblmarquee.MarqueeSub, :RADRAT => tblmarquee.RADRAT, :StartDate => tblmarquee.StartDate, :HalfID => tblmarquee.HalfID }

        return tblmarqueeJson.to_json
    end

    def self.read(data)
        tblmarquee = Tblmarquee.find(data['id'])

        tblmarqueeJson = { :id => tblmarquee.id, :MarqueeID => tblmarquee.MarqueeID, :MarqueeMain => tblmarquee.MarqueeMain, :MarqueeSub => tblmarquee.MarqueeSub, :RADRAT => tblmarquee.RADRAT, :StartDate => tblmarquee.StartDate, :HalfID => tblmarquee.HalfID }

        return tblmarqueeJson.to_json

    end

    def self.update(data)
        tblmarquee = Tblmarquee.update( data['id'], :MarqueeID => data['MarqueeID'], :MarqueeMain => data['MarqueeMain'], :MarqueeSub => data['MarqueeSub'], :RADRAT => data['RADRAT'], :StartDate => data['StartDate'], :HalfID => data['HalfID'] )

        tblmarqueeJson = { :status => status, :id => tblmarquee.id, :MarqueeID => tblmarquee.MarqueeID, :MarqueeMain => tblmarquee.MarqueeMain, :MarqueeSub => tblmarquee.MarqueeSub, :RADRAT => tblmarquee.RADRAT, :StartDate => tblmarquee.StartDate, :HalfID => tblmarquee.HalfID }

        return tblmarqueeJson.to_json

    end

    def self.delete(data)
        tblmarquee = Tblmarquee.find(data['id'])
        tblmarquee.destroy

        tblmarqueeJson = { :id => tblmarquee.id, :MarqueeID => tblmarquee.MarqueeID, :MarqueeMain => tblmarquee.MarqueeMain, :MarqueeSub => tblmarquee.MarqueeSub, :RADRAT => tblmarquee.RADRAT, :StartDate => tblmarquee.StartDate, :HalfID => tblmarquee.HalfID }

        return tblmarqueeJson.to_json

    end

    def self.list(data)
        tblmarquees = Tblmarquee.all

        Array tblmarqueeJson = Array.new
        tblmarquees.each do |tblmarquee|
            tblmarqueeJson.push({ :id => tblmarquee.id, :MarqueeID => tblmarquee.MarqueeID, :MarqueeMain => tblmarquee.MarqueeMain, :MarqueeSub => tblmarquee.MarqueeSub, :RADRAT => tblmarquee.RADRAT, :StartDate => tblmarquee.StartDate, :HalfID => tblmarquee.HalfID })
        end

        return tblmarqueeJson.to_json

    end

    def self.filter(data)
        tblmarquees = self.filterData(data)

        count = tblmarquees.length

        page  = data['Tblmarquee']['pagination']['page'].to_i
        limit = data['Tblmarquee']['pagination']['limit'].to_i
 
        # Make sure page isn't out of range
        if(page < 1)
            page = 1
        end
 
        if(((page * limit) - limit) > count)
            page = (count / limit).to_i
            if(count % limit > 0)
                page += 1
            end
        end
 
        offset = (page - 1) * limit
        tblmarquees = tblmarquees.slice(offset, limit)

        Array tblmarqueeJson = Array.new
        tblmarquees.each do |tblmarquee|
            tblmarqueeJson.push({ :id => tblmarquee.id, :MarqueeID => tblmarquee.MarqueeID, :MarqueeMain => tblmarquee.MarqueeMain, :MarqueeSub => tblmarquee.MarqueeSub, :RADRAT => tblmarquee.RADRAT, :StartDate => tblmarquee.StartDate, :HalfID => tblmarquee.HalfID })
        end

        tblmarqueeContainer = { :total => count, :tblmarquees => tblmarqueeJson }

        return tblmarqueeContainer.to_json

    end

    def self.filterData(data)

        tblmarquees = []
        if(data.key?("Tblmarquee"))
            filters = data['Tblmarquee']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblmarquees = Tblmarquee.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblmarquees = tblmarquees & Tblmarquee.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblmarquees
    end

end

