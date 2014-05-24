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


class TblsauceViewController
    public

    def self.getTblsauces(data)
        tblsauces = self.filterData(data)

        Array tblsauceJson = Array.new
        tblsauces.each do |tblsauce|
            tblsauceJson.push({ :id => tblsauce.id, :IsInternet => tblsauce.IsInternet, :RADRAT => tblsauce.RADRAT, :SauceDescription => tblsauce.SauceDescription, :SauceID => tblsauce.SauceID, :SauceShortDescription => tblsauce.SauceShortDescription, :IsActive => tblsauce.IsActive })
        end

        return tblsauces.to_json
    end
    
    def self.filterData(data)
        tblsauces = []

        storeId  = data['StoreID']
        unitId   = data['UnitID']

        tblsauces = Tblsauce.joins("inner join trelUnitSauce on trelUnitSauce.SauceID = tblSauce.SauceID and trelUnitSauce.UnitID = #{unitId} and IsActive <> 0 and IsInternet <> 0 inner join trelStoreUnitSize on trelStoreUnitSize.UnitID = trelUnitSauce.UnitID and StoreID = #{storeId}").distinct()

        return tblsauces
    end 

end
