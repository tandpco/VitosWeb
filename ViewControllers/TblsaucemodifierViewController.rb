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


class TblsaucemodifierViewController
    public

    def self.getTblsaucemodifiers(data)
        unitId   = data['UnitID']

        if(unitId == $PIZZA || unitId == $SUB)
            return getSaucemodifierFromDatabase(data)
        else
            return getSaucemodifierFromJson(data)
        end
    end
    
    def self.getSaucemodifierFromDatabase(data)
        tblsaucemodifiers = []

        storeId  = data['StoreID']
        unitId   = data['UnitID']

        tblsaucemodifiers = Tblsaucemodifier.where("IsActive <> 0").order(:SauceModifierID)

        Array tblsaucemodifierJson = Array.new

        tblsaucemodifiers.each do |tblsaucemodifier|
            tblsaucemodifierJson.push({ :id => tblsaucemodifier.id, :RADRAT => tblsaucemodifier.RADRAT, :SauceModifierDescription => tblsaucemodifier.SauceModifierDescription, :SauceModifierID => tblsaucemodifier.SauceModifierID, :SauceModifierShortDescription => tblsaucemodifier.SauceModifierShortDescription, :IsActive => tblsaucemodifier.IsActive })
        end

        return tblsaucemodifierJson.to_json

    end 

    def self.getSaucemodifierFromJson(data)
        unitId   = data['UnitID']

        unitSaucemodifier = $saucemodifier["Units"].select { |t| t['UnitID'] == unitId }
        tblsaucemodifierJson = unitSaucemodifier.first['SauceModifiers'].to_json
    end

end
