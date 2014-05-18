require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelcouponstoreController
    public
    def self.create(data)
        trelcouponstore = Trelcouponstore.create( :RADRAT => data['RADRAT'], :StoreID => data['StoreID'], :AddressID => data['AddressID'] )

        trelcouponstoreJson = { :id => trelcouponstore.id, :RADRAT => trelcouponstore.RADRAT, :StoreID => trelcouponstore.StoreID, :AddressID => trelcouponstore.AddressID }

        return trelcouponstoreJson.to_json
    end

    def self.read(data)
        trelcouponstore = Trelcouponstore.find(data['id'])

        trelcouponstoreJson = { :id => trelcouponstore.id, :RADRAT => trelcouponstore.RADRAT, :StoreID => trelcouponstore.StoreID, :AddressID => trelcouponstore.AddressID }

        return trelcouponstoreJson.to_json

    end

    def self.update(data)
        trelcouponstore = Trelcouponstore.update( data['id'], :RADRAT => data['RADRAT'], :StoreID => data['StoreID'], :AddressID => data['AddressID'] )

        trelcouponstoreJson = { :status => status, :id => trelcouponstore.id, :RADRAT => trelcouponstore.RADRAT, :StoreID => trelcouponstore.StoreID, :AddressID => trelcouponstore.AddressID }

        return trelcouponstoreJson.to_json

    end

    def self.delete(data)
        trelcouponstore = Trelcouponstore.find(data['id'])
        trelcouponstore.destroy

        trelcouponstoreJson = { :id => trelcouponstore.id, :RADRAT => trelcouponstore.RADRAT, :StoreID => trelcouponstore.StoreID, :AddressID => trelcouponstore.AddressID }

        return trelcouponstoreJson.to_json

    end

    def self.list(data)
        trelcouponstores = Trelcouponstore.all

        Array trelcouponstoreJson = Array.new
        trelcouponstores.each do |trelcouponstore|
            trelcouponstoreJson.push({ :id => trelcouponstore.id, :RADRAT => trelcouponstore.RADRAT, :StoreID => trelcouponstore.StoreID, :AddressID => trelcouponstore.AddressID })
        end

        return trelcouponstoreJson.to_json

    end

    def self.filter(data)
        trelcouponstores = self.filterData(data)

        count = trelcouponstores.length

        page  = data['Trelcouponstore']['pagination']['page'].to_i
        limit = data['Trelcouponstore']['pagination']['limit'].to_i
 
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
        trelcouponstores = trelcouponstores.slice(offset, limit)

        Array trelcouponstoreJson = Array.new
        trelcouponstores.each do |trelcouponstore|
            trelcouponstoreJson.push({ :id => trelcouponstore.id, :RADRAT => trelcouponstore.RADRAT, :StoreID => trelcouponstore.StoreID, :AddressID => trelcouponstore.AddressID })
        end

        trelcouponstoreContainer = { :total => count, :trelcouponstores => trelcouponstoreJson }

        return trelcouponstoreContainer.to_json

    end

    def self.filterData(data)

        trelcouponstores = []
        if(data.key?("Trelcouponstore"))
            filters = data['Trelcouponstore']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelcouponstores = Trelcouponstore.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelcouponstores = trelcouponstores & Trelcouponstore.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelcouponstores
    end

end

