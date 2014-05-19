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


class TrelstorespecialtyViewController
    public

    def self.getTrelstorespecialties(data)
        joinClause = "inner join tblSpecialty on trelStoreSpecialty.SpecialtyID = tblSpecialty.SpecialtyID inner join trelSpecialtyItem on tblSpecialty.SpecialtyID = trelSpecialtyItem.SpecialtyID inner join tblItems on trelSpecialtyItem.ItemID = tblItems.ItemID inner join trelStoreItem on trelStoreSpecialty.StoreID = trelStoreItem.StoreID and tblItems.ItemID = trelStoreItem.ItemID inner join trelUnitItems on tblSpecialty.UnitID = trelUnitItems.UnitID and tblItems.ItemID = trelUnitItems.ItemID where tblItems.IsActive <> 0 order by ItemDescription"
        trelstorespecialties = Trelstorespecialty.select("Tblitems.*, Trelstorespecialty.*").joins(joinClause)

        Array trelstorespecialtyJson = Array.new
        trelstorespecialties.each do |trelstorespecialty|
            trelstorespecialtyJson.push({ :ItemID => trelstorespecialty.ItemID, :ItemDescription => trelstorespecialty.ItemDescription, :SpecialtyID => trelstorespecialty.SpecialtyID, :StoreID => trelstorespecialty.StoreID, })
        end

        return trelstorespecialtyJson.to_json
        
    end
end
