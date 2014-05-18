require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelunitsidesController
    public
    def self.create(data)
        trelunitsides = Trelunitsides.create( :SideID => data['SideID'], :UnitID => data['UnitID'], :RADRAT => data['RADRAT'] )

        trelunitsidesJson = { :id => trelunitsides.id, :SideID => trelunitsides.SideID, :UnitID => trelunitsides.UnitID, :RADRAT => trelunitsides.RADRAT }

        return trelunitsidesJson.to_json
    end

    def self.read(data)
        trelunitsides = Trelunitsides.find(data['id'])

        trelunitsidesJson = { :id => trelunitsides.id, :SideID => trelunitsides.SideID, :UnitID => trelunitsides.UnitID, :RADRAT => trelunitsides.RADRAT }

        return trelunitsidesJson.to_json

    end

    def self.update(data)
        trelunitsides = Trelunitsides.update( data['id'], :SideID => data['SideID'], :UnitID => data['UnitID'], :RADRAT => data['RADRAT'] )

        trelunitsidesJson = { :id => trelunitsides.id, :SideID => trelunitsides.SideID, :UnitID => trelunitsides.UnitID, :RADRAT => trelunitsides.RADRAT }

        return trelunitsidesJson.to_json

    end

    def self.delete(data)
        trelunitsides = Trelunitsides.find(data['id'])
        trelunitsides.destroy

        trelunitsidesJson = { :id => trelunitsides.id, :SideID => trelunitsides.SideID, :UnitID => trelunitsides.UnitID, :RADRAT => trelunitsides.RADRAT }

        return trelunitsidesJson.to_json

    end

    def self.list(data)
        trelunitsides = Trelunitsides.all

        Array trelunitsidesJson = Array.new
        trelunitsides.each do |trelunitsides|
            trelunitsidesJson.push({ :id => trelunitsides.id, :SideID => trelunitsides.SideID, :UnitID => trelunitsides.UnitID, :RADRAT => trelunitsides.RADRAT })
        end

        return trelunitsidesJson.to_json

    end

    def self.filter(data)
        trelunitsides = self.filterData(data)

        count = trelunitsides.length

        page  = data['Trelunitsides']['pagination']['page'].to_i
        limit = data['Trelunitsides']['pagination']['limit'].to_i
 
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
        trelunitsides = trelunitsides.slice(offset, limit)

        Array trelunitsidesJson = Array.new
        trelunitsides.each do |trelunitsides|
            trelunitsidesJson.push({ :id => trelunitsides.id, :SideID => trelunitsides.SideID, :UnitID => trelunitsides.UnitID, :RADRAT => trelunitsides.RADRAT })
        end

        trelunitsidesContainer = { :total => count, :trelunitsides => trelunitsidesJson }

        return trelunitsidesContainer.to_json

    end

    def self.filterData(data)

        trelunitsides = []
        if(data.key?("Trelunitsides"))
            filters = data['Trelunitsides']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelunitsides = Trelunitsides.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelunitsides = trelunitsides & Trelunitsides.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelunitsides
    end

end

