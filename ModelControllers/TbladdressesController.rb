require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TbladdressesController
    public
    def self.create(data)
        tbladdresses = Tbladdresses.create( :AddressID => data['AddressID'], :AddressLine1 => data['AddressLine1'], :AddressLine2 => data['AddressLine2'], :AddressNotes => data['AddressNotes'], :City => data['City'], :IsManual => data['IsManual'], :PostalCode => data['PostalCode'], :RADRAT => data['RADRAT'], :State => data['State'], :StoreID => data['StoreID'], :CASSAddressID => data['CASSAddressID'] )

        tbladdressesJson = { :id => tbladdresses.id, :AddressID => tbladdresses.AddressID, :AddressLine1 => tbladdresses.AddressLine1, :AddressLine2 => tbladdresses.AddressLine2, :AddressNotes => tbladdresses.AddressNotes, :City => tbladdresses.City, :IsManual => tbladdresses.IsManual, :PostalCode => tbladdresses.PostalCode, :RADRAT => tbladdresses.RADRAT, :State => tbladdresses.State, :StoreID => tbladdresses.StoreID, :CASSAddressID => tbladdresses.CASSAddressID }

        return tbladdressesJson.to_json
    end

    def self.read(data)
        tbladdresses = Tbladdresses.find(data['id'])

        tbladdressesJson = { :id => tbladdresses.id, :AddressID => tbladdresses.AddressID, :AddressLine1 => tbladdresses.AddressLine1, :AddressLine2 => tbladdresses.AddressLine2, :AddressNotes => tbladdresses.AddressNotes, :City => tbladdresses.City, :IsManual => tbladdresses.IsManual, :PostalCode => tbladdresses.PostalCode, :RADRAT => tbladdresses.RADRAT, :State => tbladdresses.State, :StoreID => tbladdresses.StoreID, :CASSAddressID => tbladdresses.CASSAddressID }

        return tbladdressesJson.to_json

    end

    def self.update(data)
        tbladdresses = Tbladdresses.update( data['id'], :AddressID => data['AddressID'], :AddressLine1 => data['AddressLine1'], :AddressLine2 => data['AddressLine2'], :AddressNotes => data['AddressNotes'], :City => data['City'], :IsManual => data['IsManual'], :PostalCode => data['PostalCode'], :RADRAT => data['RADRAT'], :State => data['State'], :StoreID => data['StoreID'], :CASSAddressID => data['CASSAddressID'] )

        tbladdressesJson = { :status => status, :id => tbladdresses.id, :AddressID => tbladdresses.AddressID, :AddressLine1 => tbladdresses.AddressLine1, :AddressLine2 => tbladdresses.AddressLine2, :AddressNotes => tbladdresses.AddressNotes, :City => tbladdresses.City, :IsManual => tbladdresses.IsManual, :PostalCode => tbladdresses.PostalCode, :RADRAT => tbladdresses.RADRAT, :State => tbladdresses.State, :StoreID => tbladdresses.StoreID, :CASSAddressID => tbladdresses.CASSAddressID }

        return tbladdressesJson.to_json

    end

    def self.delete(data)
        tbladdresses = Tbladdresses.find(data['id'])
        tbladdresses.destroy

        tbladdressesJson = { :id => tbladdresses.id, :AddressID => tbladdresses.AddressID, :AddressLine1 => tbladdresses.AddressLine1, :AddressLine2 => tbladdresses.AddressLine2, :AddressNotes => tbladdresses.AddressNotes, :City => tbladdresses.City, :IsManual => tbladdresses.IsManual, :PostalCode => tbladdresses.PostalCode, :RADRAT => tbladdresses.RADRAT, :State => tbladdresses.State, :StoreID => tbladdresses.StoreID, :CASSAddressID => tbladdresses.CASSAddressID }

        return tbladdressesJson.to_json

    end

    def self.list(data)
        tbladdresses = Tbladdresses.all

        Array tbladdressesJson = Array.new
        tbladdresses.each do |tbladdresses|
            tbladdressesJson.push({ :id => tbladdresses.id, :AddressID => tbladdresses.AddressID, :AddressLine1 => tbladdresses.AddressLine1, :AddressLine2 => tbladdresses.AddressLine2, :AddressNotes => tbladdresses.AddressNotes, :City => tbladdresses.City, :IsManual => tbladdresses.IsManual, :PostalCode => tbladdresses.PostalCode, :RADRAT => tbladdresses.RADRAT, :State => tbladdresses.State, :StoreID => tbladdresses.StoreID, :CASSAddressID => tbladdresses.CASSAddressID })
        end

        return tbladdressesJson.to_json

    end

    def self.filter(data)
        tbladdresses = self.filterData(data)

        count = tbladdresses.length

        page  = data['Tbladdresses']['pagination']['page'].to_i
        limit = data['Tbladdresses']['pagination']['limit'].to_i
 
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
        tbladdresses = tbladdresses.slice(offset, limit)

        Array tbladdressesJson = Array.new
        tbladdresses.each do |tbladdresses|
            tbladdressesJson.push({ :id => tbladdresses.id, :AddressID => tbladdresses.AddressID, :AddressLine1 => tbladdresses.AddressLine1, :AddressLine2 => tbladdresses.AddressLine2, :AddressNotes => tbladdresses.AddressNotes, :City => tbladdresses.City, :IsManual => tbladdresses.IsManual, :PostalCode => tbladdresses.PostalCode, :RADRAT => tbladdresses.RADRAT, :State => tbladdresses.State, :StoreID => tbladdresses.StoreID, :CASSAddressID => tbladdresses.CASSAddressID })
        end

        tbladdressesContainer = { :total => count, :tbladdresses => tbladdressesJson }

        return tbladdressesContainer.to_json

    end

    def self.filterData(data)

        tbladdresses = []
        if(data.key?("Tbladdresses"))
            filters = data['Tbladdresses']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tbladdresses = Tbladdresses.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tbladdresses = tbladdresses & Tbladdresses.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tbladdresses
    end

end

