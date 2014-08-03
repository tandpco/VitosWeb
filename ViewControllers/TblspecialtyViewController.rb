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

        if(unitId.to_i >= $SIDE.to_i)
            result['specialties']    = self.getSpecialtyFromJson(data)
        else
            result['specialties']    = self.getSpecialtyFromDatabase(data)
        end

        result['toppers']        = JSON.parse(TopperViewController.listToppers(data))
        result['sizes']          = JSON.parse(SizeViewController.listSizes(data))
        result['sauces']         = JSON.parse(SauceViewController.listSauces(data))
        result['styles']         = JSON.parse(StyleViewController.listStyles(data))
        result['sauceModifiers'] = JSON.parse(TblsaucemodifierViewController.getTblsaucemodifiers(data))
        result['toppings']       = JSON.parse(ToppingViewController.listToppings(data))

        return result.to_json
    end

    def self.getSpecialtyFromDatabase(data)

        tblspecialties = []
        storeId  = data['StoreID']
        unitId   = data['UnitID']

        tblspecialties = Tblspecialty.joins("inner join trelStoreSpecialty on trelStoreSpecialty.SpecialtyID = tblSpecialty.SpecialtyID where StoreID = #{storeId}  and UnitID = #{unitId} and IsActive <> 0 and IsInternet <> 0 order by tblSpecialty.SpecialtyID")

        returnData = Array.new()

        # Create Your Own (GitHub Issue #10)
        # Pizza
        if(unitId.to_i == $PIZZA.to_i)
            returnData.push({:id=>nil,:IsActive=>true,:IsInternet=>true,:NoBaseCheese=>false,:RADRAT=>"2011-05-04T14:49=>23.000Z",:SauceID=>6,:SpecialtyDescription=>"Create Your Own Pizza",:InternetDescription=>"Choose Toppings of Your Choice",:SpecialtyID=>7,:SpecialtyShortDescription=>"Create Your Own Pizza",:StyleID=>nil,:UnitID=>1})
        elsif(unitId.to_i == $SUB.to_i)
            returnData.push({:id=>nil,:IsActive=>true,:IsInternet=>true,:NoBaseCheese=>false,:RADRAT=>"2011-07-12T11:17=>44.000Z",:SauceID=>6,:SpecialtyDescription=>"Create Your Own Sub",:InternetDescription=>"Choose 5 of your favorite toppings. Vegetables are free.",:SpecialtyID=>28,:SpecialtyShortDescription=>"Choose 5 of your favorite toppings. Vegetables are free.",:StyleID=>nil,:UnitID=>32})
        elsif(unitId.to_i == $SALAD.to_i)
            returnData.push({:id=>nil,:IsActive=>true,:IsInternet=>true,:NoBaseCheese=>false,:RADRAT=>"2011-07-12T11:20=>42.000Z",:SauceID=>nil,:SpecialtyDescription=>"Create Your Own Salad",:InternetDescription=>"Chopped Romaine Lettuce. Choose 5 of your favorite toppings. Served with Seasoned Croutons or Tortilla Chips and your choice of 2 dressings.",:SpecialtyID=>40,:SpecialtyShortDescription=>"Create Your Own Salad",:StyleID=>nil,:UnitID=>3})
        end

        tblspecialties.each do |tblspecialty|
            returnData.push({ :id => tblspecialty.id, :IsActive => tblspecialty.IsActive, :IsInternet => tblspecialty.IsInternet, :NoBaseCheese => tblspecialty.NoBaseCheese, :RADRAT => tblspecialty.RADRAT, :SauceID => tblspecialty.SauceID, :SpecialtyDescription => tblspecialty.SpecialtyDescription, :InternetDescription => tblspecialty.InternetDescription, :SpecialtyID => tblspecialty.SpecialtyID, :SpecialtyShortDescription => tblspecialty.SpecialtyShortDescription, :StyleID => tblspecialty.StyleID, :UnitID => tblspecialty.UnitID })
        end

        return returnData
    end 

    def self.getSpecialtyFromJson(data)
        unitId   = data['UnitID'].to_s

        returnData = Array.new

        unitSpecialty = $specialty["Units"].select { |s| s['UnitID'] == unitId }

        if(unitSpecialty.count > 0)
            returnData = unitSpecialty.first['Specialties']
        end

        return returnData
    end


end
