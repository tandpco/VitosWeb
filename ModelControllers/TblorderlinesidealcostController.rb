require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblorderlinesidealcostController
    public
    def self.create(data)
        tblorderlinesidealcost = Tblorderlinesidealcost.create( :IdealWeight => data['IdealWeight'], :InventoryID => data['InventoryID'], :OrderLineID => data['OrderLineID'], :RADRAT => data['RADRAT'], :IdealSideCost => data['IdealSideCost'] )

        tblorderlinesidealcostJson = { :id => tblorderlinesidealcost.id, :IdealWeight => tblorderlinesidealcost.IdealWeight, :InventoryID => tblorderlinesidealcost.InventoryID, :OrderLineID => tblorderlinesidealcost.OrderLineID, :RADRAT => tblorderlinesidealcost.RADRAT, :IdealSideCost => tblorderlinesidealcost.IdealSideCost }

        return tblorderlinesidealcostJson.to_json
    end

    def self.read(data)
        tblorderlinesidealcost = Tblorderlinesidealcost.find(data['id'])

        tblorderlinesidealcostJson = { :id => tblorderlinesidealcost.id, :IdealWeight => tblorderlinesidealcost.IdealWeight, :InventoryID => tblorderlinesidealcost.InventoryID, :OrderLineID => tblorderlinesidealcost.OrderLineID, :RADRAT => tblorderlinesidealcost.RADRAT, :IdealSideCost => tblorderlinesidealcost.IdealSideCost }

        return tblorderlinesidealcostJson.to_json

    end

    def self.update(data)
        tblorderlinesidealcost = Tblorderlinesidealcost.update( data['id'], :IdealWeight => data['IdealWeight'], :InventoryID => data['InventoryID'], :OrderLineID => data['OrderLineID'], :RADRAT => data['RADRAT'], :IdealSideCost => data['IdealSideCost'] )

        tblorderlinesidealcostJson = { :id => tblorderlinesidealcost.id, :IdealWeight => tblorderlinesidealcost.IdealWeight, :InventoryID => tblorderlinesidealcost.InventoryID, :OrderLineID => tblorderlinesidealcost.OrderLineID, :RADRAT => tblorderlinesidealcost.RADRAT, :IdealSideCost => tblorderlinesidealcost.IdealSideCost }

        return tblorderlinesidealcostJson.to_json

    end

    def self.delete(data)
        tblorderlinesidealcost = Tblorderlinesidealcost.find(data['id'])
        tblorderlinesidealcost.destroy

        tblorderlinesidealcostJson = { :id => tblorderlinesidealcost.id, :IdealWeight => tblorderlinesidealcost.IdealWeight, :InventoryID => tblorderlinesidealcost.InventoryID, :OrderLineID => tblorderlinesidealcost.OrderLineID, :RADRAT => tblorderlinesidealcost.RADRAT, :IdealSideCost => tblorderlinesidealcost.IdealSideCost }

        return tblorderlinesidealcostJson.to_json

    end

    def self.list(data)
        tblorderlinesidealcosts = Tblorderlinesidealcost.all

        Array tblorderlinesidealcostJson = Array.new
        tblorderlinesidealcosts.each do |tblorderlinesidealcost|
            tblorderlinesidealcostJson.push({ :id => tblorderlinesidealcost.id, :IdealWeight => tblorderlinesidealcost.IdealWeight, :InventoryID => tblorderlinesidealcost.InventoryID, :OrderLineID => tblorderlinesidealcost.OrderLineID, :RADRAT => tblorderlinesidealcost.RADRAT, :IdealSideCost => tblorderlinesidealcost.IdealSideCost })
        end

        return tblorderlinesidealcostJson.to_json

    end

    def self.filter(data)
        tblorderlinesidealcosts = self.filterData(data)

        count = tblorderlinesidealcosts.length

        page  = data['Tblorderlinesidealcost']['pagination']['page'].to_i
        limit = data['Tblorderlinesidealcost']['pagination']['limit'].to_i
 
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
        tblorderlinesidealcosts = tblorderlinesidealcosts.slice(offset, limit)

        Array tblorderlinesidealcostJson = Array.new
        tblorderlinesidealcosts.each do |tblorderlinesidealcost|
            tblorderlinesidealcostJson.push({ :id => tblorderlinesidealcost.id, :IdealWeight => tblorderlinesidealcost.IdealWeight, :InventoryID => tblorderlinesidealcost.InventoryID, :OrderLineID => tblorderlinesidealcost.OrderLineID, :RADRAT => tblorderlinesidealcost.RADRAT, :IdealSideCost => tblorderlinesidealcost.IdealSideCost })
        end

        tblorderlinesidealcostContainer = { :total => count, :tblorderlinesidealcosts => tblorderlinesidealcostJson }

        return tblorderlinesidealcostContainer.to_json

    end

    def self.filterData(data)

        tblorderlinesidealcosts = []
        if(data.key?("Tblorderlinesidealcost"))
            filters = data['Tblorderlinesidealcost']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblorderlinesidealcosts = Tblorderlinesidealcost.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblorderlinesidealcosts = tblorderlinesidealcosts & Tblorderlinesidealcost.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblorderlinesidealcosts
    end

end

