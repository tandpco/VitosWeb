require 'sinatra'
require 'json'
require 'data_mapper'

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
        tblitems = self.filterData(data)

        Array tblitemsJson = Array.new
        tblitems.each do |tblitems|
            tblitemsJson.push({ :IsInternet => tblitems.IsInternet, :ItemDescription => tblitems.ItemDescription, :ItemID => tblitems.ItemID, :ItemShortDescription => tblitems.ItemShortDescription, :ItemSortOrder => tblitems.ItemSortOrder, :RADRAT => tblitems.RADRAT })
        end

        return tblitems.to_json
    end

    def self.filterData(data)

        tblitems = []

        storeId  = data['StoreID']
        unitId   = data['UnitID']

        tblitems = Tblitems.joins("inner join trelStoreItem on trelStoreItem.ItemID = tblItems.ItemID inner join trelUnitItems on tblItems.ItemID = trelUnitItems.ItemID inner join tblUnit on trelUnitItems.UnitID = tblUnit.UnitID where StoreID = #{storeId} and trelUnitItems.UnitID = #{unitId} and tblItems.IsActive <> 0 and tblItems.IsInternet <> 0 and IsBaseCheese = 0 order by ItemDescription")

        return tblitems


        return tblcustomers
    end

end