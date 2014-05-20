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
        
        Array tblspecialtyJson = Array.new
        tblspecialties.each do |tblspecialty|
            tblspecialtyJson.push({ :id => tblspecialty.id, :IsActive => tblspecialty.IsActive, :IsInternet => tblspecialty.IsInternet, :NoBaseCheese => tblspecialty.NoBaseCheese, :RADRAT => tblspecialty.RADRAT, :SauceID => tblspecialty.SauceID, :SpecialtyDescription => tblspecialty.SpecialtyDescription, :InternetDescription => tblspecialty.InternetDescription, :SpecialtyID => tblspecialty.SpecialtyID, :SpecialtyShortDescription => tblspecialty.SpecialtyShortDescription, :StyleID => tblspecialty.StyleID, :UnitID => tblspecialty.UnitID })
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
    
end
