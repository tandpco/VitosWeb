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
        if(data.has_key?("SPECIALTY_ITEMS"))
            specialtyId   = data['SpecialtyID']
            tblitems = Tblitems.joins("inner join trelSpecialtyItem as si on tblItems.ItemID = si.ItemID  AND tblItems.IsActive <> 0 inner join tblSpecialty as s on si.SpecialtyID = s.SpecialtyID inner join trelStoreSpecialty as ss on s.SpecialtyID = ss.SpecialtyID AND ss.SpecialtyID = #{specialtyId} AND ss.StoreID = #{storeId} inner join trelUnitItems as ui on tblItems.ItemID = ui.ItemID AND ui.UnitID = #{unitId} order by tblItems.ItemDescription")
        else
            tblitems = Tblitems.joins("inner join trelStoreItem on trelStoreItem.ItemID = tblItems.ItemID inner join trelUnitItems on tblItems.ItemID = trelUnitItems.ItemID inner join tblUnit on trelUnitItems.UnitID = tblUnit.UnitID where StoreID = #{storeId} and trelUnitItems.UnitID = #{unitId} and tblItems.IsActive <> 0 and tblItems.IsInternet <> 0 and IsBaseCheese = 0 order by ItemDescription")
        end


        return tblitems

    end

end
