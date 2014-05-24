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
        tblsaucemodifiers = self.filterData(data)

        Array tblsaucemodifierJson = Array.new
        tblsaucemodifiers.each do |tblsaucemodifier|
            tblsaucemodifierJson.push({ :id => tblsaucemodifier.id, :RADRAT => tblsaucemodifier.RADRAT, :SauceModifierDescription => tblsaucemodifier.SauceModifierDescription, :SauceModifierID => tblsaucemodifier.SauceModifierID, :SauceModifierShortDescription => tblsaucemodifier.SauceModifierShortDescription, :IsActive => tblsaucemodifier.IsActive })
        end

        return tblsaucemodifiers.to_json
    end
    
    def self.filterData(data)
        tblsaucemodifiers = []

        tblsaucemodifiers = Tblsaucemodifier.where("IsActive <> 0").order(:SauceModifierID)

        return tblsaucemodifiers
    end 

end
