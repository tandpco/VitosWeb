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


class TblordersViewController
    public

    def self.createTblorders(data)
        data['pSessionID']       = convertToInt(data['pSessionID'])
        data['pIPAddress']       = data['pIPAddress']
        data['pEmpID']           = convertToInt(data['pEmpID'])
        data['pRefID']           = convertToInt(data['pRefID'])
        data['pTransactionDate'] = data['pTransactionDate']
        data['pStoreID']         = convertToInt(data['pStoreID'])
        data['pCustomerID']      = convertToInt(data['pCustomerID'])
        data['pCustomerName']    = data['pCustomerName']
        data['pCustomerPhone']   = data['pCustomerPhone']
        data['pAddressID']       = convertToInt(data['pAddressID'])
        data['pOrderTypeID']     = convertToInt(data['pOrderTypeID'])
        data['pDeliveryCharge']  = convertToFloat(data['pDeliveryCharge'])
        data['pDriverMoney']     = convertToFloat(data['pDriverMoney'])
        data['pOrderNotes']      = data['pOrderNotes']
        
        result = Tblorders.connection.execute_procedure("AddOrder", data)


        return result.to_json
    end

    def self.updatePriceTblorders(data)
        data['pStoreID']       = convertToInt(data['pStoreID'])
        data['pOrderID']       = convertToInt(data['pOrderID'])
        data['pCouponIDs']     = data['pCouponIDs']
        data['pPromoCodes']    = data['pPromoCodes']

        result = Tblorders.connection.execute_procedure("WebRecalculateOrderPrice", data)

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

    def self.convertToFloat(value)
        if(value == 'NULL')
            value = nil
        else
            value = value.to_f
        end

        return value
    end


end
