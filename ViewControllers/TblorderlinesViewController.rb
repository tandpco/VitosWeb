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

    def self.getTblorderlines(data)
        tblorderlines = self.filterData(data)

        Array tblorderlinesJson = Array.new
        tblorderlines.each do |tblorderlines|
            tblorderlinesJson.push({ :id => tblorderlines.id, :CouponID => tblorderlines.CouponID, :Discount => tblorderlines.Discount, :Half1SauceID => tblorderlines.Half1SauceID, :Half1SauceModifierID => tblorderlines.Half1SauceModifierID, :Half2SauceID => tblorderlines.Half2SauceID, :Half2SauceModifierID => tblorderlines.Half2SauceModifierID, :IdealCost => tblorderlines.IdealCost, :IdealHalf1SauceCost => tblorderlines.IdealHalf1SauceCost, :IdealHalf1SauceWeight => tblorderlines.IdealHalf1SauceWeight, :IdealHalf2SauceCost => tblorderlines.IdealHalf2SauceCost, :IdealHalf2SauceWeight => tblorderlines.IdealHalf2SauceWeight, :IdealStandardCost => tblorderlines.IdealStandardCost, :IdealStyleCost => tblorderlines.IdealStyleCost, :IdealStyleWeight => tblorderlines.IdealStyleWeight, :InternetDescription => tblorderlines.InternetDescription, :MPOReason => tblorderlines.MPOReason, :OrderID => tblorderlines.OrderID, :OrderLineID => tblorderlines.OrderLineID, :OrderLineNotes => tblorderlines.OrderLineNotes, :Quantity => tblorderlines.Quantity, :RADRAT => tblorderlines.RADRAT, :SizeID => tblorderlines.SizeID, :SpecialtyID => tblorderlines.SpecialtyID, :StyleID => tblorderlines.StyleID, :UnitID => tblorderlines.UnitID, :IdealCost => tblorderlines.IdealCost, :Cost => tblorderlines.Cost })

        end

        return tblorderlinesJson.to_json

    end

    def self.filterData(data)
        orderId = data['OrderID']

        tblorderlines = []
        tblorderlines = Tblorderlines.where("OrderID = #{orderId}").order("OrderLineID ASC")

        return tblorderlines
    end

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
