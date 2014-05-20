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


class TblspecialtyViewController
    public

    def self.getTblspecialties(data)
        tblspecialties = self.filterData(data)
        unitId   = data['UnitID']

        Array tblspecialtyJson = Array.new
        if(unitId == "0")
            tblspecialtyJson = self.getSides(data)
        else
            tblspecialties = self.filterData(data)

            tblspecialties.each do |tblspecialty|
                tblspecialtyJson.push({ :id => tblspecialty.id, :IsActive => tblspecialty.IsActive, :IsInternet => tblspecialty.IsInternet, :NoBaseCheese => tblspecialty.NoBaseCheese, :RADRAT => tblspecialty.RADRAT, :SauceID => tblspecialty.SauceID, :SpecialtyDescription => tblspecialty.SpecialtyDescription, :InternetDescription => tblspecialty.InternetDescription, :SpecialtyID => tblspecialty.SpecialtyID, :SpecialtyShortDescription => tblspecialty.SpecialtyShortDescription, :StyleID => tblspecialty.StyleID, :UnitID => tblspecialty.UnitID })
            end
        end
        

        return tblspecialtyJson.to_json
    end
    
    def self.filterData(data)

        tblspecialties = []
        storeId  = data['StoreID']
        unitId   = data['UnitID']

        tblspecialties = Tblspecialty.joins("inner join trelStoreSpecialty on trelStoreSpecialty.SpecialtyID = tblSpecialty.SpecialtyID where StoreID = #{storeId}  and UnitID = #{unitId} and IsActive <> 0 and IsInternet <> 0 order by tblSpecialty.SpecialtyID")

        return tblspecialties
    end 

    def self.getSides(data)
        storeId  = data['StoreID']

        returnArray = Array.new()
        tblunits = Tblunit.joins("inner join trelUnitSize on tblUnit.UnitID = trelUnitSize.UnitID inner join trelStoreUnitSize on trelUnitSize.UnitID = trelStoreUnitSize.UnitID and trelUnitSize.SizeID = trelStoreUnitSize.SizeID where StoreID = #{storeId} and tblUnit.IsActive <> 0 and tblUnit.IsInternet <> 0 order by UnitMenuSortOrder").distinct()

        tblunits.each do |tblunit|
            next if tblunit.UnitID.to_s =~ /^(1|32|3|14)$/
            returnArray.push({ :id => "", :IsActive => "", :IsInternet => "", :NoBaseCheese => "", :RADRAT => "", :SauceID => "", :SpecialtyDescription => tblunit.UnitDescription, :InternetDescription => tblunit.CustomDescription, :SpecialtyID => "800" + tblunit.UnitID.to_s, :SpecialtyShortDescription => tblunit.UnitDescription, :StyleID => "", :UnitID => "SIDES" })
        end

        return returnArray

    end 
    
end
