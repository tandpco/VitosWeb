require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelstoreitemController
    public
    def self.create(data)
        trelstoreitem = Trelstoreitem.create( :ItemID => data['ItemID'], :OnSidePrice => data['OnSidePrice'], :RADRAT => data['RADRAT'], :StoreID => data['StoreID'], :RADRAT => data['RADRAT'] )

        trelstoreitemJson = { :id => trelstoreitem.id, :ItemID => trelstoreitem.ItemID, :OnSidePrice => trelstoreitem.OnSidePrice, :RADRAT => trelstoreitem.RADRAT, :StoreID => trelstoreitem.StoreID, :RADRAT => trelstoreitem.RADRAT }

        return trelstoreitemJson.to_json
    end

    def self.read(data)
        trelstoreitem = Trelstoreitem.find(data['id'])

        trelstoreitemJson = { :id => trelstoreitem.id, :ItemID => trelstoreitem.ItemID, :OnSidePrice => trelstoreitem.OnSidePrice, :RADRAT => trelstoreitem.RADRAT, :StoreID => trelstoreitem.StoreID, :RADRAT => trelstoreitem.RADRAT }

        return trelstoreitemJson.to_json

    end

    def self.update(data)
        trelstoreitem = Trelstoreitem.update( data['id'], :ItemID => data['ItemID'], :OnSidePrice => data['OnSidePrice'], :RADRAT => data['RADRAT'], :StoreID => data['StoreID'], :RADRAT => data['RADRAT'] )

        trelstoreitemJson = { :id => trelstoreitem.id, :ItemID => trelstoreitem.ItemID, :OnSidePrice => trelstoreitem.OnSidePrice, :RADRAT => trelstoreitem.RADRAT, :StoreID => trelstoreitem.StoreID, :RADRAT => trelstoreitem.RADRAT }

        return trelstoreitemJson.to_json

    end

    def self.delete(data)
        trelstoreitem = Trelstoreitem.find(data['id'])
        trelstoreitem.destroy

        trelstoreitemJson = { :id => trelstoreitem.id, :ItemID => trelstoreitem.ItemID, :OnSidePrice => trelstoreitem.OnSidePrice, :RADRAT => trelstoreitem.RADRAT, :StoreID => trelstoreitem.StoreID, :RADRAT => trelstoreitem.RADRAT }

        return trelstoreitemJson.to_json

    end

    def self.list(data)
        trelstoreitems = Trelstoreitem.all

        Array trelstoreitemJson = Array.new
        trelstoreitems.each do |trelstoreitem|
            trelstoreitemJson.push({ :id => trelstoreitem.id, :ItemID => trelstoreitem.ItemID, :OnSidePrice => trelstoreitem.OnSidePrice, :RADRAT => trelstoreitem.RADRAT, :StoreID => trelstoreitem.StoreID, :RADRAT => trelstoreitem.RADRAT })
        end

        return trelstoreitemJson.to_json

    end

    def self.filter(data)
        trelstoreitems = self.filterData(data)

        count = trelstoreitems.length

        page  = data['Trelstoreitem']['pagination']['page'].to_i
        limit = data['Trelstoreitem']['pagination']['limit'].to_i
 
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
        trelstoreitems = trelstoreitems.slice(offset, limit)

        Array trelstoreitemJson = Array.new
        trelstoreitems.each do |trelstoreitem|
            trelstoreitemJson.push({ :id => trelstoreitem.id, :ItemID => trelstoreitem.ItemID, :OnSidePrice => trelstoreitem.OnSidePrice, :RADRAT => trelstoreitem.RADRAT, :StoreID => trelstoreitem.StoreID, :RADRAT => trelstoreitem.RADRAT })
        end

        trelstoreitemContainer = { :total => count, :trelstoreitems => trelstoreitemJson }

        return trelstoreitemContainer.to_json

    end

    def self.filterData(data)

        trelstoreitems = []
        if(data.key?("Trelstoreitem"))
            filters = data['Trelstoreitem']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelstoreitems = Trelstoreitem.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelstoreitems = trelstoreitems & Trelstoreitem.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelstoreitems
    end

end

