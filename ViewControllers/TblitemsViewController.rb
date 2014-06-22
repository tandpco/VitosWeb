require 'sinatra'
require 'json'

Dir["../ModelControllers/*.rb"].sort.each do |file|
    file.sub!(".rb","");
    require file
end

Dir["../Models/*.rb"].sort.each do |file|
    file.sub!(".rb","");
    require file
end


class TblitemsViewController
    public

    def self.getTblitems(data)
        unitId   = data['UnitID']

        if(unitId == $SIDE)
            return getItemsFromJson(data)
        else
            return getItemsFromDatabase(data)
        end
    end

    def self.getItemsFromDatabase(data)

        tblitems = []

        storeId  = data['StoreID']
        unitId   = data['UnitID']
        tblitems = Tblitems.joins("inner join trelStoreItem on trelStoreItem.ItemID = tblItems.ItemID inner join trelUnitItems on tblItems.ItemID = trelUnitItems.ItemID inner join tblUnit on trelUnitItems.UnitID = tblUnit.UnitID where StoreID = #{storeId} and trelUnitItems.UnitID = #{unitId} and tblItems.IsActive <> 0 and tblItems.IsInternet <> 0 and IsBaseCheese = 0 order by ItemDescription")

        Array tblitemsJson = Array.new
        tblitems.each do |tblitems|
            tblitemsJson.push({ :IsInternet => tblitems.IsInternet, :ItemDescription => tblitems.ItemDescription, :ItemID => tblitems.ItemID, :ItemShortDescription => tblitems.ItemShortDescription, :ItemSortOrder => tblitems.ItemSortOrder, :RADRAT => tblitems.RADRAT })
        end
        
        return tblitems.to_json

    end
    
    def self.getItemsFromJson(data)
        unitId   = data['UnitID'].to_s

        unitItems = $items["Units"].select { |s| s['UnitID'] == unitId }

        tblitemsJson = "[]"

        if(unitItems.count > 0)
            tblitemsJson = unitItems.first['Items'].to_json
        end

        return tblitemsJson

    end

end
