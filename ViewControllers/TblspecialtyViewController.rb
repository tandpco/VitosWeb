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

        if(unitId =~ /^(#{$PIZZA}|#{$SUB}|#{$SALAD})$/)
            result['specialties']    = self.getSpecialtyFromDatabase(data)
        else
            result['specialties']    = self.getSpecialtyFromJson(data)
        end

        result['toppers']        = JSON.parse(TbltopperViewController.getTbltoppers(data))
        result['sizes']          = JSON.parse(TblsizesViewController.getTblsizes(data))
        result['sauces']         = JSON.parse(TblsauceViewController.getTblsauces(data))
        result['styles']         = JSON.parse(TblstylesViewController.getTblstyles(data))
        result['sauceModifiers'] = JSON.parse(TblsaucemodifierViewController.getTblsaucemodifiers(data))
        result['toppings']       = JSON.parse(TblitemsViewController.getTblitems(data))

        return result.to_json
    end

    def self.getSpecialtyFromDatabase(data)

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

    def self.getSpecialtyFromJson(data)
        unitId   = data['UnitID'].to_s
        File.open("log", 'w') { |file| file.puts("UnitID: #{unitId}") }

        returnData = Array.new

        unitSpecialty = $specialty["Units"].select { |s| s['UnitID'] == unitId }

        if(unitSpecialty.count > 0)
            returnData = unitSpecialty.first['Specialties']
        end

        return returnData
    end


end
