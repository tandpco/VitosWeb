require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelunitsizeController
    public
    def self.create(data)
        trelunitsize = Trelunitsize.create( :SizeID => data['SizeID'], :UnitID => data['UnitID'], :Quantity => data['Quantity'] )

        trelunitsizeJson = { :id => trelunitsize.id, :SizeID => trelunitsize.SizeID, :UnitID => trelunitsize.UnitID, :Quantity => trelunitsize.Quantity }

        return trelunitsizeJson.to_json
    end

    def self.read(data)
        trelunitsize = Trelunitsize.find(data['id'])

        trelunitsizeJson = { :id => trelunitsize.id, :SizeID => trelunitsize.SizeID, :UnitID => trelunitsize.UnitID, :Quantity => trelunitsize.Quantity }

        return trelunitsizeJson.to_json

    end

    def self.update(data)
        trelunitsize = Trelunitsize.update( data['id'], :SizeID => data['SizeID'], :UnitID => data['UnitID'], :Quantity => data['Quantity'] )

        trelunitsizeJson = { :status => status, :id => trelunitsize.id, :SizeID => trelunitsize.SizeID, :UnitID => trelunitsize.UnitID, :Quantity => trelunitsize.Quantity }

        return trelunitsizeJson.to_json

    end

    def self.delete(data)
        trelunitsize = Trelunitsize.find(data['id'])
        trelunitsize.destroy

        trelunitsizeJson = { :id => trelunitsize.id, :SizeID => trelunitsize.SizeID, :UnitID => trelunitsize.UnitID, :Quantity => trelunitsize.Quantity }

        return trelunitsizeJson.to_json

    end

    def self.list(data)
        trelunitsizes = Trelunitsize.all

        Array trelunitsizeJson = Array.new
        trelunitsizes.each do |trelunitsize|
            trelunitsizeJson.push({ :id => trelunitsize.id, :SizeID => trelunitsize.SizeID, :UnitID => trelunitsize.UnitID, :Quantity => trelunitsize.Quantity })
        end

        return trelunitsizeJson.to_json

    end

    def self.filter(data)
        trelunitsizes = self.filterData(data)

        count = trelunitsizes.length

        page  = data['Trelunitsize']['pagination']['page'].to_i
        limit = data['Trelunitsize']['pagination']['limit'].to_i
 
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
        trelunitsizes = trelunitsizes.slice(offset, limit)

        Array trelunitsizeJson = Array.new
        trelunitsizes.each do |trelunitsize|
            trelunitsizeJson.push({ :id => trelunitsize.id, :SizeID => trelunitsize.SizeID, :UnitID => trelunitsize.UnitID, :Quantity => trelunitsize.Quantity })
        end

        trelunitsizeContainer = { :total => count, :trelunitsizes => trelunitsizeJson }

        return trelunitsizeContainer.to_json

    end

    def self.filterData(data)

        trelunitsizes = []
        if(data.key?("Trelunitsize"))
            filters = data['Trelunitsize']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelunitsizes = Trelunitsize.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelunitsizes = trelunitsizes & Trelunitsize.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelunitsizes
    end

end

