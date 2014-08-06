require 'sinatra'
require 'json'

class SpecialtyViewController
    public

    def self.listSpecialties(data)
    
        unitId   = data['UnitID']
        result = Hash.new()

        if(unitId.to_i >= $SIDE.to_i)
            result['specialties']    = listSpecialtyFromJson(data)
        else
            result['specialties']    = listSpecialtyFromDatabase(data)
        end

        result['toppers']        = JSON.parse(TopperViewController.listToppers(data))
        result['sizes']          = JSON.parse(SizeViewController.listSizes(data))
        result['sauces']         = JSON.parse(SauceViewController.listSauces(data))
        result['styles']         = JSON.parse(StyleViewController.listStyles(data))
        result['sauceModifiers'] = JSON.parse(SauceModifierViewController.listSauceModifiers(data))
        result['toppings']       = JSON.parse(ToppingViewController.listToppings(data))

        return result.to_json
        
    end
    
    def self.listSpecialtyFromDatabase(data)
        storeId  = data['StoreID']
        unitId   = data['UnitID']

        returnData = Array.new()

        # Create Your Own (GitHub Issue #10)
        # Pizza
        if(unitId.to_i == $PIZZA.to_i)
            unitSpecialty = $specialties["Units"].select { |t| t['UnitID'] == $PIZZA }
            if(unitSpecialty.count > 0)
                returnData.push(unitSpecialty.first['Specialties'][0])
            end
        elsif(unitId.to_i == $SUB.to_i)
            unitSpecialty = $specialties["Units"].select { |t| t['UnitID'] == $SUB }
            if(unitSpecialty.count > 0)
                returnData.push(unitSpecialty.first['Specialties'][0])
            end
        elsif(unitId.to_i == $SALAD.to_i)
            unitSpecialty = $specialties["Units"].select { |t| t['UnitID'] == $SALAD }
            if(unitSpecialty.count > 0)
                returnData.push(unitSpecialty.first['Specialties'][0])
            end
        end
        
        rows = ActiveRecord::Base.connection.select_all('SELECT [tblspecialty].* FROM [tblspecialty] inner join trelStoreSpecialty on trelStoreSpecialty.SpecialtyID = tblSpecialty.SpecialtyID where StoreID = ' + storeId + ' and UnitID = ' + unitId + ' and IsActive <> 0 and IsInternet <> 0 order by tblSpecialty.SpecialtyID')

        returnData.concat(rows)

        return returnData
    end
    
    def self.listSpecialtyFromJson(data)
        unitId   = data['UnitID'].to_s

        unitSpecialty = $specialties["Units"].select { |t| t['UnitID'] == unitId }

        returnData = Array.new()

        if(unitSpecialty.count > 0)
            returnData = unitSpecialty.first['Specialties']
        end

        return returnData

    end
end

