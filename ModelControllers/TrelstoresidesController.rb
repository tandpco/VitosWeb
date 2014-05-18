require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelstoresidesController
    public
    def self.create(data)
        trelstoresides = Trelstoresides.create( :SideID => data['SideID'], :SidePrice => data['SidePrice'], :StoreID => data['StoreID'], :RADRAT => data['RADRAT'] )

        trelstoresidesJson = { :id => trelstoresides.id, :SideID => trelstoresides.SideID, :SidePrice => trelstoresides.SidePrice, :StoreID => trelstoresides.StoreID, :RADRAT => trelstoresides.RADRAT }

        return trelstoresidesJson.to_json
    end

    def self.read(data)
        trelstoresides = Trelstoresides.find(data['id'])

        trelstoresidesJson = { :id => trelstoresides.id, :SideID => trelstoresides.SideID, :SidePrice => trelstoresides.SidePrice, :StoreID => trelstoresides.StoreID, :RADRAT => trelstoresides.RADRAT }

        return trelstoresidesJson.to_json

    end

    def self.update(data)
        trelstoresides = Trelstoresides.update( data['id'], :SideID => data['SideID'], :SidePrice => data['SidePrice'], :StoreID => data['StoreID'], :RADRAT => data['RADRAT'] )

        trelstoresidesJson = { :status => status, :id => trelstoresides.id, :SideID => trelstoresides.SideID, :SidePrice => trelstoresides.SidePrice, :StoreID => trelstoresides.StoreID, :RADRAT => trelstoresides.RADRAT }

        return trelstoresidesJson.to_json

    end

    def self.delete(data)
        trelstoresides = Trelstoresides.find(data['id'])
        trelstoresides.destroy

        trelstoresidesJson = { :id => trelstoresides.id, :SideID => trelstoresides.SideID, :SidePrice => trelstoresides.SidePrice, :StoreID => trelstoresides.StoreID, :RADRAT => trelstoresides.RADRAT }

        return trelstoresidesJson.to_json

    end

    def self.list(data)
        trelstoresides = Trelstoresides.all

        Array trelstoresidesJson = Array.new
        trelstoresides.each do |trelstoresides|
            trelstoresidesJson.push({ :id => trelstoresides.id, :SideID => trelstoresides.SideID, :SidePrice => trelstoresides.SidePrice, :StoreID => trelstoresides.StoreID, :RADRAT => trelstoresides.RADRAT })
        end

        return trelstoresidesJson.to_json

    end

    def self.filter(data)
        trelstoresides = self.filterData(data)

        count = trelstoresides.length

        page  = data['Trelstoresides']['pagination']['page'].to_i
        limit = data['Trelstoresides']['pagination']['limit'].to_i
 
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
        trelstoresides = trelstoresides.slice(offset, limit)

        Array trelstoresidesJson = Array.new
        trelstoresides.each do |trelstoresides|
            trelstoresidesJson.push({ :id => trelstoresides.id, :SideID => trelstoresides.SideID, :SidePrice => trelstoresides.SidePrice, :StoreID => trelstoresides.StoreID, :RADRAT => trelstoresides.RADRAT })
        end

        trelstoresidesContainer = { :total => count, :trelstoresides => trelstoresidesJson }

        return trelstoresidesContainer.to_json

    end

    def self.filterData(data)

        trelstoresides = []
        if(data.key?("Trelstoresides"))
            filters = data['Trelstoresides']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelstoresides = Trelstoresides.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelstoresides = trelstoresides & Trelstoresides.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelstoresides
    end

end

