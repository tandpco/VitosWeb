require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelspecialtyitemController
    public
    def self.create(data)
        trelspecialtyitem = Trelspecialtyitem.create( :RADRAT => data['RADRAT'], :SpecialtyID => data['SpecialtyID'], :SpecialtyItemQuantity => data['SpecialtyItemQuantity'], :Quantity => data['Quantity'] )

        trelspecialtyitemJson = { :id => trelspecialtyitem.id, :RADRAT => trelspecialtyitem.RADRAT, :SpecialtyID => trelspecialtyitem.SpecialtyID, :SpecialtyItemQuantity => trelspecialtyitem.SpecialtyItemQuantity, :Quantity => trelspecialtyitem.Quantity }

        return trelspecialtyitemJson.to_json
    end

    def self.read(data)
        trelspecialtyitem = Trelspecialtyitem.find(data['id'])

        trelspecialtyitemJson = { :id => trelspecialtyitem.id, :RADRAT => trelspecialtyitem.RADRAT, :SpecialtyID => trelspecialtyitem.SpecialtyID, :SpecialtyItemQuantity => trelspecialtyitem.SpecialtyItemQuantity, :Quantity => trelspecialtyitem.Quantity }

        return trelspecialtyitemJson.to_json

    end

    def self.update(data)
        trelspecialtyitem = Trelspecialtyitem.update( data['id'], :RADRAT => data['RADRAT'], :SpecialtyID => data['SpecialtyID'], :SpecialtyItemQuantity => data['SpecialtyItemQuantity'], :Quantity => data['Quantity'] )

        trelspecialtyitemJson = { :status => status, :id => trelspecialtyitem.id, :RADRAT => trelspecialtyitem.RADRAT, :SpecialtyID => trelspecialtyitem.SpecialtyID, :SpecialtyItemQuantity => trelspecialtyitem.SpecialtyItemQuantity, :Quantity => trelspecialtyitem.Quantity }

        return trelspecialtyitemJson.to_json

    end

    def self.delete(data)
        trelspecialtyitem = Trelspecialtyitem.find(data['id'])
        trelspecialtyitem.destroy

        trelspecialtyitemJson = { :id => trelspecialtyitem.id, :RADRAT => trelspecialtyitem.RADRAT, :SpecialtyID => trelspecialtyitem.SpecialtyID, :SpecialtyItemQuantity => trelspecialtyitem.SpecialtyItemQuantity, :Quantity => trelspecialtyitem.Quantity }

        return trelspecialtyitemJson.to_json

    end

    def self.list(data)
        trelspecialtyitems = Trelspecialtyitem.all

        Array trelspecialtyitemJson = Array.new
        trelspecialtyitems.each do |trelspecialtyitem|
            trelspecialtyitemJson.push({ :id => trelspecialtyitem.id, :RADRAT => trelspecialtyitem.RADRAT, :SpecialtyID => trelspecialtyitem.SpecialtyID, :SpecialtyItemQuantity => trelspecialtyitem.SpecialtyItemQuantity, :Quantity => trelspecialtyitem.Quantity })
        end

        return trelspecialtyitemJson.to_json

    end

    def self.filter(data)
        trelspecialtyitems = self.filterData(data)

        count = trelspecialtyitems.length

        page  = data['Trelspecialtyitem']['pagination']['page'].to_i
        limit = data['Trelspecialtyitem']['pagination']['limit'].to_i
 
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
        trelspecialtyitems = trelspecialtyitems.slice(offset, limit)

        Array trelspecialtyitemJson = Array.new
        trelspecialtyitems.each do |trelspecialtyitem|
            trelspecialtyitemJson.push({ :id => trelspecialtyitem.id, :RADRAT => trelspecialtyitem.RADRAT, :SpecialtyID => trelspecialtyitem.SpecialtyID, :SpecialtyItemQuantity => trelspecialtyitem.SpecialtyItemQuantity, :Quantity => trelspecialtyitem.Quantity })
        end

        trelspecialtyitemContainer = { :total => count, :trelspecialtyitems => trelspecialtyitemJson }

        return trelspecialtyitemContainer.to_json

    end

    def self.filterData(data)

        trelspecialtyitems = []
        if(data.key?("Trelspecialtyitem"))
            filters = data['Trelspecialtyitem']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelspecialtyitems = Trelspecialtyitem.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelspecialtyitems = trelspecialtyitems & Trelspecialtyitem.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelspecialtyitems
    end

end

