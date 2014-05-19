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
        unitId = data['UnitID']
        whereClause = "UnitID = " + unitId
        tblspecialties = Tblspecialty.where(whereClause)
        
        Array tblspecialtyJson = Array.new
        tblspecialties.each do |tblspecialty|
            tblspecialtyJson.push({ :id => tblspecialty.id, :IsActive => tblspecialty.IsActive, :IsInternet => tblspecialty.IsInternet, :NoBaseCheese => tblspecialty.NoBaseCheese, :RADRAT => tblspecialty.RADRAT, :SauceID => tblspecialty.SauceID, :SpecialtyDescription => tblspecialty.SpecialtyDescription, :InternetDescription => tblspecialty.InternetDescription, :SpecialtyID => tblspecialty.SpecialtyID, :SpecialtyShortDescription => tblspecialty.SpecialtyShortDescription, :StyleID => tblspecialty.StyleID, :UnitID => tblspecialty.UnitID })
        end

        return tblspecialtyJson.to_json
    end
end
