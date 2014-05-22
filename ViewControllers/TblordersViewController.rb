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
        # Order
        order = data['order']

        order['pSessionID']       = convertToInt(order['pSessionID'])
        order['pIPAddress']       = order['pIPAddress']
        order['pEmpID']           = convertToInt(order['pEmpID'])
        order['pRefID']           = convertToInt(order['pRefID'])
        order['pTransactionDate'] = order['pTransactionDate']
        order['pStoreID']         = convertToInt(order['pStoreID'])
        order['pCustomerID']      = convertToInt(order['pCustomerID'])
        order['pCustomerName']    = order['pCustomerName']
        order['pCustomerPhone']   = order['pCustomerPhone']
        order['pAddressID']       = convertToInt(order['pAddressID'])
        order['pOrderTypeID']     = convertToInt(order['pOrderTypeID'])
        order['pDeliveryCharge']  = convertToFloat(order['pDeliveryCharge'])
        order['pDriverMoney']     = convertToFloat(order['pDriverMoney'])
        order['pOrderNotes']      = order['pOrderNotes']
        
        orderResult = Tblorders.connection.execute_procedure("AddOrder", order)


        # OrderItem
        orderItem = data['orderItem']
        orderItem['pOrderID']              = convertToInt(orderResult[0]['newid'])

        orderItem['pUnitID']               = convertToInt(orderItem['pUnitID'])
        orderItem['pSpecialtyID']          = convertToInt(orderItem['pSpecialtyID'])
        orderItem['pSizeID']               = convertToInt(orderItem['pSizeID'])
        orderItem['pStyleID']              = convertToInt(orderItem['pStyleID'])
        orderItem['pHalf1SauceID']         = convertToInt(orderItem['pHalf1SauceID'])
        orderItem['pHalf2SauceID']         = convertToInt(orderItem['pHalf2SauceID'])
        orderItem['pHalf1SauceModifierID'] = convertToInt(orderItem['pHalf1SauceModifierID'])
        orderItem['pHalf2SauceModifierID'] = convertToInt(orderItem['pHalf2SauceModifierID'])
        orderItem['pOrderLineNotes']       = orderItem['pOrderLineNotes']
        orderItem['pInternetDescription']  = orderItem['pInternetDescription']
        orderItem['pQuantity']             = convertToInt(orderItem['pQuantity'])

        puts(JSON.pretty_generate(orderItem))

        orderItemResult = Tblorderlines.connection.execute_procedure("AddOrderLine", orderItem);

        # Update Price
        updatePrice = data['updatePrice']
        updatePrice['pOrderID']  = convertToInt(orderResult[0]['newid'])
        updatePrice['pStoreID']         = convertToInt(updatePrice['pStoreID'])
        updatePrice['pCouponIDs']       = updatePrice['pCouponIDs']
        updatePrice['pPromoCodes']      = updatePrice['pPromoCodes']

        updatePriceResult = Tblorders.connection.execute_procedure("WebRecalculateOrderPrice", updatePrice)

        result = Hash.new()

        result['order'] = orderResult
        result['orderItem'] = orderItemResult

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
