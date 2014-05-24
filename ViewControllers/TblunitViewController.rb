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


class TblunitViewController
    public

    def self.getTblunits(data)
        unitId = data['UnitID']
        whereClause = "UnitID = " + unitId
        tblunits = Tblunit.where(whereClause)
        
        count = tblunits.length
        
        Array tblunitJson = Array.new
        tblunits.each do |tblunit|
            tblunitJson.push({ :id => tblunit.id, :CustomDescription => tblunit.CustomDescription, :InternetDescription => tblunit.InternetDescription, :IsActive => tblunit.IsActive, :IsInternet => tblunit.IsInternet, :RADRAT => tblunit.RADRAT, :UnitDescription => tblunit.UnitDescription, :UnitID => tblunit.UnitID, :UnitMenuSortOrder => tblunit.UnitMenuSortOrder, :UnitShortDescription => tblunit.UnitShortDescription })
        end

        return tblunitJson.to_json


    end
end
