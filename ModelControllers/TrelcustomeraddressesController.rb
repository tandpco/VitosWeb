require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelcustomeraddressesController
    public
    def self.create(data)
        trelcustomeraddresses = Trelcustomeraddresses.create( :CustomerAddressDescription => data['CustomerAddressDescription'], :CustomerAddressNotes => data['CustomerAddressNotes'], :CustomerID => data['CustomerID'], :RADRAT => data['RADRAT'], :WasExtraDeliveryNotified => data['WasExtraDeliveryNotified'], :IsDefault => data['IsDefault'] )

        trelcustomeraddressesJson = { :id => trelcustomeraddresses.id, :CustomerAddressDescription => trelcustomeraddresses.CustomerAddressDescription, :CustomerAddressNotes => trelcustomeraddresses.CustomerAddressNotes, :CustomerID => trelcustomeraddresses.CustomerID, :RADRAT => trelcustomeraddresses.RADRAT, :WasExtraDeliveryNotified => trelcustomeraddresses.WasExtraDeliveryNotified, :IsDefault => trelcustomeraddresses.IsDefault }

        return trelcustomeraddressesJson.to_json
    end

    def self.read(data)
        trelcustomeraddresses = Trelcustomeraddresses.find(data['id'])

        trelcustomeraddressesJson = { :id => trelcustomeraddresses.id, :CustomerAddressDescription => trelcustomeraddresses.CustomerAddressDescription, :CustomerAddressNotes => trelcustomeraddresses.CustomerAddressNotes, :CustomerID => trelcustomeraddresses.CustomerID, :RADRAT => trelcustomeraddresses.RADRAT, :WasExtraDeliveryNotified => trelcustomeraddresses.WasExtraDeliveryNotified, :IsDefault => trelcustomeraddresses.IsDefault }

        return trelcustomeraddressesJson.to_json

    end

    def self.update(data)
        trelcustomeraddresses = Trelcustomeraddresses.update( data['id'], :CustomerAddressDescription => data['CustomerAddressDescription'], :CustomerAddressNotes => data['CustomerAddressNotes'], :CustomerID => data['CustomerID'], :RADRAT => data['RADRAT'], :WasExtraDeliveryNotified => data['WasExtraDeliveryNotified'], :IsDefault => data['IsDefault'] )

        trelcustomeraddressesJson = { :status => status, :id => trelcustomeraddresses.id, :CustomerAddressDescription => trelcustomeraddresses.CustomerAddressDescription, :CustomerAddressNotes => trelcustomeraddresses.CustomerAddressNotes, :CustomerID => trelcustomeraddresses.CustomerID, :RADRAT => trelcustomeraddresses.RADRAT, :WasExtraDeliveryNotified => trelcustomeraddresses.WasExtraDeliveryNotified, :IsDefault => trelcustomeraddresses.IsDefault }

        return trelcustomeraddressesJson.to_json

    end

    def self.delete(data)
        trelcustomeraddresses = Trelcustomeraddresses.find(data['id'])
        trelcustomeraddresses.destroy

        trelcustomeraddressesJson = { :id => trelcustomeraddresses.id, :CustomerAddressDescription => trelcustomeraddresses.CustomerAddressDescription, :CustomerAddressNotes => trelcustomeraddresses.CustomerAddressNotes, :CustomerID => trelcustomeraddresses.CustomerID, :RADRAT => trelcustomeraddresses.RADRAT, :WasExtraDeliveryNotified => trelcustomeraddresses.WasExtraDeliveryNotified, :IsDefault => trelcustomeraddresses.IsDefault }

        return trelcustomeraddressesJson.to_json

    end

    def self.list(data)
        trelcustomeraddresses = Trelcustomeraddresses.all

        Array trelcustomeraddressesJson = Array.new
        trelcustomeraddresses.each do |trelcustomeraddresses|
            trelcustomeraddressesJson.push({ :id => trelcustomeraddresses.id, :CustomerAddressDescription => trelcustomeraddresses.CustomerAddressDescription, :CustomerAddressNotes => trelcustomeraddresses.CustomerAddressNotes, :CustomerID => trelcustomeraddresses.CustomerID, :RADRAT => trelcustomeraddresses.RADRAT, :WasExtraDeliveryNotified => trelcustomeraddresses.WasExtraDeliveryNotified, :IsDefault => trelcustomeraddresses.IsDefault })
        end

        return trelcustomeraddressesJson.to_json

    end

    def self.filter(data)
        trelcustomeraddresses = self.filterData(data)

        count = trelcustomeraddresses.length

        page  = data['Trelcustomeraddresses']['pagination']['page'].to_i
        limit = data['Trelcustomeraddresses']['pagination']['limit'].to_i
 
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
        trelcustomeraddresses = trelcustomeraddresses.slice(offset, limit)

        Array trelcustomeraddressesJson = Array.new
        trelcustomeraddresses.each do |trelcustomeraddresses|
            trelcustomeraddressesJson.push({ :id => trelcustomeraddresses.id, :CustomerAddressDescription => trelcustomeraddresses.CustomerAddressDescription, :CustomerAddressNotes => trelcustomeraddresses.CustomerAddressNotes, :CustomerID => trelcustomeraddresses.CustomerID, :RADRAT => trelcustomeraddresses.RADRAT, :WasExtraDeliveryNotified => trelcustomeraddresses.WasExtraDeliveryNotified, :IsDefault => trelcustomeraddresses.IsDefault })
        end

        trelcustomeraddressesContainer = { :total => count, :trelcustomeraddresses => trelcustomeraddressesJson }

        return trelcustomeraddressesContainer.to_json

    end

    def self.filterData(data)

        trelcustomeraddresses = []
        if(data.key?("Trelcustomeraddresses"))
            filters = data['Trelcustomeraddresses']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelcustomeraddresses = Trelcustomeraddresses.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelcustomeraddresses = trelcustomeraddresses & Trelcustomeraddresses.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelcustomeraddresses
    end

end

