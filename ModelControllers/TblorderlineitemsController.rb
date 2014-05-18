require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblorderlineitemsController
    public
    def self.create(data)
        tblorderlineitems = Tblorderlineitems.create( :IdealItemCost => data['IdealItemCost'], :IdealItemWeight => data['IdealItemWeight'], :ItemID => data['ItemID'], :OrderLineID => data['OrderLineID'], :OrderLineItemID => data['OrderLineItemID'], :RADRAT => data['RADRAT'], :Cost => data['Cost'] )

        tblorderlineitemsJson = { :id => tblorderlineitems.id, :IdealItemCost => tblorderlineitems.IdealItemCost, :IdealItemWeight => tblorderlineitems.IdealItemWeight, :ItemID => tblorderlineitems.ItemID, :OrderLineID => tblorderlineitems.OrderLineID, :OrderLineItemID => tblorderlineitems.OrderLineItemID, :RADRAT => tblorderlineitems.RADRAT, :Cost => tblorderlineitems.Cost }

        return tblorderlineitemsJson.to_json
    end

    def self.read(data)
        tblorderlineitems = Tblorderlineitems.find(data['id'])

        tblorderlineitemsJson = { :id => tblorderlineitems.id, :IdealItemCost => tblorderlineitems.IdealItemCost, :IdealItemWeight => tblorderlineitems.IdealItemWeight, :ItemID => tblorderlineitems.ItemID, :OrderLineID => tblorderlineitems.OrderLineID, :OrderLineItemID => tblorderlineitems.OrderLineItemID, :RADRAT => tblorderlineitems.RADRAT, :Cost => tblorderlineitems.Cost }

        return tblorderlineitemsJson.to_json

    end

    def self.update(data)
        tblorderlineitems = Tblorderlineitems.update( data['id'], :IdealItemCost => data['IdealItemCost'], :IdealItemWeight => data['IdealItemWeight'], :ItemID => data['ItemID'], :OrderLineID => data['OrderLineID'], :OrderLineItemID => data['OrderLineItemID'], :RADRAT => data['RADRAT'], :Cost => data['Cost'] )

        tblorderlineitemsJson = { :status => status, :id => tblorderlineitems.id, :IdealItemCost => tblorderlineitems.IdealItemCost, :IdealItemWeight => tblorderlineitems.IdealItemWeight, :ItemID => tblorderlineitems.ItemID, :OrderLineID => tblorderlineitems.OrderLineID, :OrderLineItemID => tblorderlineitems.OrderLineItemID, :RADRAT => tblorderlineitems.RADRAT, :Cost => tblorderlineitems.Cost }

        return tblorderlineitemsJson.to_json

    end

    def self.delete(data)
        tblorderlineitems = Tblorderlineitems.find(data['id'])
        tblorderlineitems.destroy

        tblorderlineitemsJson = { :id => tblorderlineitems.id, :IdealItemCost => tblorderlineitems.IdealItemCost, :IdealItemWeight => tblorderlineitems.IdealItemWeight, :ItemID => tblorderlineitems.ItemID, :OrderLineID => tblorderlineitems.OrderLineID, :OrderLineItemID => tblorderlineitems.OrderLineItemID, :RADRAT => tblorderlineitems.RADRAT, :Cost => tblorderlineitems.Cost }

        return tblorderlineitemsJson.to_json

    end

    def self.list(data)
        tblorderlineitems = Tblorderlineitems.all

        Array tblorderlineitemsJson = Array.new
        tblorderlineitems.each do |tblorderlineitems|
            tblorderlineitemsJson.push({ :id => tblorderlineitems.id, :IdealItemCost => tblorderlineitems.IdealItemCost, :IdealItemWeight => tblorderlineitems.IdealItemWeight, :ItemID => tblorderlineitems.ItemID, :OrderLineID => tblorderlineitems.OrderLineID, :OrderLineItemID => tblorderlineitems.OrderLineItemID, :RADRAT => tblorderlineitems.RADRAT, :Cost => tblorderlineitems.Cost })
        end

        return tblorderlineitemsJson.to_json

    end

    def self.filter(data)
        tblorderlineitems = self.filterData(data)

        count = tblorderlineitems.length

        page  = data['Tblorderlineitems']['pagination']['page'].to_i
        limit = data['Tblorderlineitems']['pagination']['limit'].to_i
 
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
        tblorderlineitems = tblorderlineitems.slice(offset, limit)

        Array tblorderlineitemsJson = Array.new
        tblorderlineitems.each do |tblorderlineitems|
            tblorderlineitemsJson.push({ :id => tblorderlineitems.id, :IdealItemCost => tblorderlineitems.IdealItemCost, :IdealItemWeight => tblorderlineitems.IdealItemWeight, :ItemID => tblorderlineitems.ItemID, :OrderLineID => tblorderlineitems.OrderLineID, :OrderLineItemID => tblorderlineitems.OrderLineItemID, :RADRAT => tblorderlineitems.RADRAT, :Cost => tblorderlineitems.Cost })
        end

        tblorderlineitemsContainer = { :total => count, :tblorderlineitems => tblorderlineitemsJson }

        return tblorderlineitemsContainer.to_json

    end

    def self.filterData(data)

        tblorderlineitems = []
        if(data.key?("Tblorderlineitems"))
            filters = data['Tblorderlineitems']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblorderlineitems = Tblorderlineitems.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblorderlineitems = tblorderlineitems & Tblorderlineitems.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblorderlineitems
    end

end

