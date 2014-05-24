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


class TblspecialtyViewController
    public

    def self.getTblspecialties(data)
        unitId   = data['UnitID']
        result = Hash.new()

        Array tblspecialtyData = Array.new
        if(unitId == "0")
            tblspecialtyData = self.getSides(data)
        else
            tblspecialtyData = self.getSpecialties(data)
        end

        result['specialties']    = tblspecialtyData
        result['toppers']        = JSON.parse(TbltopperViewController.getTbltoppers(data))
        result['sizes']          = JSON.parse(TblsizesViewController.getTblsizes(data))
        result['sauces']         = JSON.parse(TblsauceViewController.getTblsauces(data))
        result['styles']         = JSON.parse(TblstylesViewController.getTblstyles(data))
        result['sauceModifiers'] = JSON.parse(TblsaucemodifierViewController.getTblsaucemodifiers(data))
        result['toppings']       = JSON.parse(TblitemsViewController.getTblitems(data))

        return result.to_json
    end
    
    def self.getSpecialties(data)
        tblspecialties = []
        storeId  = data['StoreID']
        unitId   = data['UnitID']

        tblspecialties = Tblspecialty.joins("inner join trelStoreSpecialty on trelStoreSpecialty.SpecialtyID = tblSpecialty.SpecialtyID where StoreID = #{storeId}  and UnitID = #{unitId} and IsActive <> 0 and IsInternet <> 0 order by tblSpecialty.SpecialtyID")

        returnData = Array.new()
        tblspecialties.each do |tblspecialty|
            returnData.push({ :id => tblspecialty.id, :IsActive => tblspecialty.IsActive, :IsInternet => tblspecialty.IsInternet, :NoBaseCheese => tblspecialty.NoBaseCheese, :RADRAT => tblspecialty.RADRAT, :SauceID => tblspecialty.SauceID, :SpecialtyDescription => tblspecialty.SpecialtyDescription, :InternetDescription => tblspecialty.InternetDescription, :SpecialtyID => tblspecialty.SpecialtyID, :SpecialtyShortDescription => tblspecialty.SpecialtyShortDescription, :StyleID => tblspecialty.StyleID, :UnitID => tblspecialty.UnitID })
        end

        return returnData
    end 

    def self.getSides(data)
        storeId  = data['StoreID']

        tblunits = Tblunit.joins("inner join trelUnitSize on tblUnit.UnitID = trelUnitSize.UnitID inner join trelStoreUnitSize on trelUnitSize.UnitID = trelStoreUnitSize.UnitID and trelUnitSize.SizeID = trelStoreUnitSize.SizeID where StoreID = #{storeId} and tblUnit.IsActive <> 0 and tblUnit.IsInternet <> 0 order by UnitMenuSortOrder").distinct()

        returnData = Array.new()
        tblunits.each do |tblunit|
            next if tblunit.UnitID.to_s =~ /^(1|32|3|14)$/
            returnData.push({ :id => "", :IsActive => "", :IsInternet => "", :NoBaseCheese => "", :RADRAT => "", :SauceID => "", :SpecialtyDescription => tblunit.UnitDescription, :InternetDescription => tblunit.CustomDescription, :SpecialtyID => "800" + tblunit.UnitID.to_s, :SpecialtyShortDescription => tblunit.UnitDescription, :StyleID => "", :UnitID => "SIDES" })
        end

        return returnData

    end 

end
