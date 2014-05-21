require 'sinatra'
require 'json'
require 'active_record'

Dir["../ModelControllers/*.rb"].sort.each do |file|
    file.sub!(".rb","");
    require file
end

Dir["../Models/*.rb"].sort.each do |file|
    file.sub!(".rb","");
    require file
end


class TblorderlinesViewController
    public

    def self.createTblorderlines(data)
        data['pOrderID']              = convertToInt(data['pOrderID'])
        data['pUnitID']               = convertToInt(data['pUnitID'])
        data['pSpecialtyID']          = convertToInt(data['pSpecialtyID'])
        data['pSizeID']               = convertToInt(data['pSizeID'])
        data['pStyleID']              = convertToInt(data['pStyleID'])
        data['pHalf1SauceID']         = convertToInt(data['pHalf1SauceID'])
        data['pHalf2SauceID']         = convertToInt(data['pHalf2SauceID'])
        data['pHalf1SauceModifierID'] = convertToInt(data['pHalf1SauceModifierID'])
        data['pHalf2SauceModifierID'] = convertToInt(data['pHalf2SauceModifierID'])
        data['pOrderLineNotes']       = data['pOrderLineNotes']
        data['pInternetDescription']  = data['pInternetDescription']
        data['pQuantity']             = convertToInt(data['pQuantity'])

        puts(JSON.pretty_generate(data))
        
        result = Tblorderlines.connection.execute_procedure("AddOrderLine", data);

        return result.to_json
    end

    def self.convertToInt(value)
        if(value == 'NULL' || value.to_i == 0)
            value = nil
        else
            value = value.to_i 
        end 

        return value
    end

end
