require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblcassaddressesController
    public
    def self.create(data)
        tblcassaddresses = Tblcassaddresses.create( :City => data['City'], :DeliveryCharge => data['DeliveryCharge'], :DriverMoney => data['DriverMoney'], :EOCode => data['EOCode'], :HighNumber => data['HighNumber'], :LowNumber => data['LowNumber'], :PostalCode => data['PostalCode'], :RADRAT => data['RADRAT'], :State => data['State'], :StoreID => data['StoreID'], :Street => data['Street'], :AddForSpecialty => data['AddForSpecialty'] )

        tblcassaddressesJson = { :id => tblcassaddresses.id, :City => tblcassaddresses.City, :DeliveryCharge => tblcassaddresses.DeliveryCharge, :DriverMoney => tblcassaddresses.DriverMoney, :EOCode => tblcassaddresses.EOCode, :HighNumber => tblcassaddresses.HighNumber, :LowNumber => tblcassaddresses.LowNumber, :PostalCode => tblcassaddresses.PostalCode, :RADRAT => tblcassaddresses.RADRAT, :State => tblcassaddresses.State, :StoreID => tblcassaddresses.StoreID, :Street => tblcassaddresses.Street, :AddForSpecialty => tblcassaddresses.AddForSpecialty }

        return tblcassaddressesJson.to_json
    end

    def self.read(data)
        tblcassaddresses = Tblcassaddresses.find(data['id'])

        tblcassaddressesJson = { :id => tblcassaddresses.id, :City => tblcassaddresses.City, :DeliveryCharge => tblcassaddresses.DeliveryCharge, :DriverMoney => tblcassaddresses.DriverMoney, :EOCode => tblcassaddresses.EOCode, :HighNumber => tblcassaddresses.HighNumber, :LowNumber => tblcassaddresses.LowNumber, :PostalCode => tblcassaddresses.PostalCode, :RADRAT => tblcassaddresses.RADRAT, :State => tblcassaddresses.State, :StoreID => tblcassaddresses.StoreID, :Street => tblcassaddresses.Street, :AddForSpecialty => tblcassaddresses.AddForSpecialty }

        return tblcassaddressesJson.to_json

    end

    def self.update(data)
        tblcassaddresses = Tblcassaddresses.update( data['id'], :City => data['City'], :DeliveryCharge => data['DeliveryCharge'], :DriverMoney => data['DriverMoney'], :EOCode => data['EOCode'], :HighNumber => data['HighNumber'], :LowNumber => data['LowNumber'], :PostalCode => data['PostalCode'], :RADRAT => data['RADRAT'], :State => data['State'], :StoreID => data['StoreID'], :Street => data['Street'], :AddForSpecialty => data['AddForSpecialty'] )

        tblcassaddressesJson = { :status => status, :id => tblcassaddresses.id, :City => tblcassaddresses.City, :DeliveryCharge => tblcassaddresses.DeliveryCharge, :DriverMoney => tblcassaddresses.DriverMoney, :EOCode => tblcassaddresses.EOCode, :HighNumber => tblcassaddresses.HighNumber, :LowNumber => tblcassaddresses.LowNumber, :PostalCode => tblcassaddresses.PostalCode, :RADRAT => tblcassaddresses.RADRAT, :State => tblcassaddresses.State, :StoreID => tblcassaddresses.StoreID, :Street => tblcassaddresses.Street, :AddForSpecialty => tblcassaddresses.AddForSpecialty }

        return tblcassaddressesJson.to_json

    end

    def self.delete(data)
        tblcassaddresses = Tblcassaddresses.find(data['id'])
        tblcassaddresses.destroy

        tblcassaddressesJson = { :id => tblcassaddresses.id, :City => tblcassaddresses.City, :DeliveryCharge => tblcassaddresses.DeliveryCharge, :DriverMoney => tblcassaddresses.DriverMoney, :EOCode => tblcassaddresses.EOCode, :HighNumber => tblcassaddresses.HighNumber, :LowNumber => tblcassaddresses.LowNumber, :PostalCode => tblcassaddresses.PostalCode, :RADRAT => tblcassaddresses.RADRAT, :State => tblcassaddresses.State, :StoreID => tblcassaddresses.StoreID, :Street => tblcassaddresses.Street, :AddForSpecialty => tblcassaddresses.AddForSpecialty }

        return tblcassaddressesJson.to_json

    end

    def self.list(data)
        tblcassaddresses = Tblcassaddresses.all

        Array tblcassaddressesJson = Array.new
        tblcassaddresses.each do |tblcassaddresses|
            tblcassaddressesJson.push({ :id => tblcassaddresses.id, :City => tblcassaddresses.City, :DeliveryCharge => tblcassaddresses.DeliveryCharge, :DriverMoney => tblcassaddresses.DriverMoney, :EOCode => tblcassaddresses.EOCode, :HighNumber => tblcassaddresses.HighNumber, :LowNumber => tblcassaddresses.LowNumber, :PostalCode => tblcassaddresses.PostalCode, :RADRAT => tblcassaddresses.RADRAT, :State => tblcassaddresses.State, :StoreID => tblcassaddresses.StoreID, :Street => tblcassaddresses.Street, :AddForSpecialty => tblcassaddresses.AddForSpecialty })
        end

        return tblcassaddressesJson.to_json

    end

    def self.filter(data)
        tblcassaddresses = self.filterData(data)

        count = tblcassaddresses.length

        page  = data['Tblcassaddresses']['pagination']['page'].to_i
        limit = data['Tblcassaddresses']['pagination']['limit'].to_i
 
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
        tblcassaddresses = tblcassaddresses.slice(offset, limit)

        Array tblcassaddressesJson = Array.new
        tblcassaddresses.each do |tblcassaddresses|
            tblcassaddressesJson.push({ :id => tblcassaddresses.id, :City => tblcassaddresses.City, :DeliveryCharge => tblcassaddresses.DeliveryCharge, :DriverMoney => tblcassaddresses.DriverMoney, :EOCode => tblcassaddresses.EOCode, :HighNumber => tblcassaddresses.HighNumber, :LowNumber => tblcassaddresses.LowNumber, :PostalCode => tblcassaddresses.PostalCode, :RADRAT => tblcassaddresses.RADRAT, :State => tblcassaddresses.State, :StoreID => tblcassaddresses.StoreID, :Street => tblcassaddresses.Street, :AddForSpecialty => tblcassaddresses.AddForSpecialty })
        end

        tblcassaddressesContainer = { :total => count, :tblcassaddresses => tblcassaddressesJson }

        return tblcassaddressesContainer.to_json

    end

    def self.filterData(data)

        tblcassaddresses = []
        if(data.key?("Tblcassaddresses"))
            filters = data['Tblcassaddresses']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblcassaddresses = Tblcassaddresses.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblcassaddresses = tblcassaddresses & Tblcassaddresses.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblcassaddresses
    end

end

