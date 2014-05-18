require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelunitsauceController
    public
    def self.create(data)
        trelunitsauce = Trelunitsauce.create( :SauceID => data['SauceID'], :UnitID => data['UnitID'], :RADRAT => data['RADRAT'] )

        trelunitsauceJson = { :id => trelunitsauce.id, :SauceID => trelunitsauce.SauceID, :UnitID => trelunitsauce.UnitID, :RADRAT => trelunitsauce.RADRAT }

        return trelunitsauceJson.to_json
    end

    def self.read(data)
        trelunitsauce = Trelunitsauce.find(data['id'])

        trelunitsauceJson = { :id => trelunitsauce.id, :SauceID => trelunitsauce.SauceID, :UnitID => trelunitsauce.UnitID, :RADRAT => trelunitsauce.RADRAT }

        return trelunitsauceJson.to_json

    end

    def self.update(data)
        trelunitsauce = Trelunitsauce.update( data['id'], :SauceID => data['SauceID'], :UnitID => data['UnitID'], :RADRAT => data['RADRAT'] )

        trelunitsauceJson = { :status => status, :id => trelunitsauce.id, :SauceID => trelunitsauce.SauceID, :UnitID => trelunitsauce.UnitID, :RADRAT => trelunitsauce.RADRAT }

        return trelunitsauceJson.to_json

    end

    def self.delete(data)
        trelunitsauce = Trelunitsauce.find(data['id'])
        trelunitsauce.destroy

        trelunitsauceJson = { :id => trelunitsauce.id, :SauceID => trelunitsauce.SauceID, :UnitID => trelunitsauce.UnitID, :RADRAT => trelunitsauce.RADRAT }

        return trelunitsauceJson.to_json

    end

    def self.list(data)
        trelunitsauces = Trelunitsauce.all

        Array trelunitsauceJson = Array.new
        trelunitsauces.each do |trelunitsauce|
            trelunitsauceJson.push({ :id => trelunitsauce.id, :SauceID => trelunitsauce.SauceID, :UnitID => trelunitsauce.UnitID, :RADRAT => trelunitsauce.RADRAT })
        end

        return trelunitsauceJson.to_json

    end

    def self.filter(data)
        trelunitsauces = self.filterData(data)

        count = trelunitsauces.length

        page  = data['Trelunitsauce']['pagination']['page'].to_i
        limit = data['Trelunitsauce']['pagination']['limit'].to_i
 
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
        trelunitsauces = trelunitsauces.slice(offset, limit)

        Array trelunitsauceJson = Array.new
        trelunitsauces.each do |trelunitsauce|
            trelunitsauceJson.push({ :id => trelunitsauce.id, :SauceID => trelunitsauce.SauceID, :UnitID => trelunitsauce.UnitID, :RADRAT => trelunitsauce.RADRAT })
        end

        trelunitsauceContainer = { :total => count, :trelunitsauces => trelunitsauceJson }

        return trelunitsauceContainer.to_json

    end

    def self.filterData(data)

        trelunitsauces = []
        if(data.key?("Trelunitsauce"))
            filters = data['Trelunitsauce']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelunitsauces = Trelunitsauce.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelunitsauces = trelunitsauces & Trelunitsauce.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelunitsauces
    end

end

