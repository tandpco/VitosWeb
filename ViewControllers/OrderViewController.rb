require 'sinatra'
require 'json'
require 'time'

class OrderViewController
    public

    def self.getOrder(data,session)
        orderId = SessionViewController.get("orderId",session)
        if !orderId
            return nil
        end

        rows = ActiveRecord::Base.connection.select_all('SELECT [tblorders].* FROM [tblorders] WHERE OrderID = ' + orderId)

        rows.each do |row|
            row.keys.each do |key|
                puts("#{key} -> #{row[key].class.to_s}, #{row[key].to_s}")
                # if(row[key].class.to_s == "String")
                    # row[key].gsub!(/'/,"\u2019")
                # end
            end
        end

        return rows.to_json
    end
    def self.getOrderNew(data,session)
        orderId = SessionViewController.get("orderId",session)
        if !orderId
            return nil
        end

        row = ActiveRecord::Base.connection.select_one('SELECT tblorders.* FROM tblorders WHERE OrderID = ' + orderId)
        return row
    end
    
    def self.createOrder(data,session)
        result = Hash.new()

        # Order
        order = data['order']
        orderItem = data['orderItem']
        orderId = SessionViewController.get("orderId",session).to_i
        storeId = SessionViewController.get("storeId",session).to_i

        puts("OrderID: " + orderId.to_s)
        if(orderId == nil || orderId < 1)

            newOrder = Hash.new()

            newOrder['pSessionID']       = 0
            newOrder['pIPAddress']       = 0
            newOrder['pEmpID']           = 0
            newOrder['pRefID']           = nil
            newOrder['pTransactionDate'] = Time.now.utc.iso8601
            newOrder['pStoreID']         = storeId

            # get from session
            newOrder['pCustomerID']      = convertToInt(order['pCustomerID'])

            newOrder['pCustomerName']    = order['pCustomerName']
            newOrder['pCustomerPhone']   = order['pCustomerPhone']
            newOrder['pAddressID']       = convertToInt(order['pAddressID'])
            newOrder['pOrderTypeID']     = convertToInt(order['pOrderTypeID'])

            # auto determine this
            newOrder['pDeliveryCharge']  = convertToFloat(order['pDeliveryCharge'])

            newOrder['pDriverMoney']     = convertToFloat(order['pDriverMoney'])
            newOrder['pOrderNotes']      = order['pOrderNotes']
            
            orderResult = ActiveRecord::Base.connection.execute_procedure("AddOrder", newOrder)
            orderId = convertToInt(orderResult[0]['newid'])
            SessionViewController.set("orderId",orderId,session)
        end

        orderItem['pOrderID']     = orderId

        # OrderItem

        # Handle side deals
        itemUnitId      = convertToInt(orderItem['pUnitID'])
        itemSpecialtyId = convertToInt(orderItem['pSpecialtyID'])

        half1SauceID         = convertToInt(orderItem['pHalf1SauceID'])
        half2SauceID         = convertToInt(orderItem['pHalf2SauceID'])
        half1SauceModifierID = convertToInt(orderItem['pHalf1SauceModifierID'])
        half2SauceModifierID = convertToInt(orderItem['pHalf2SauceModifierID'])

        # Hard coded sides as 8000 and above
        # Values originate in JSON, not the database
        # Added 8000 to original unit id (i.e. Vito's bread originally was UnitID 2, changed to 8002)
        if(itemUnitId == 8000 || itemSpecialtyId == 8001)
            itemUnitId       = itemSpecialtyId - 8000
            itemSpecialtyId  = nil

            # UnitID 2 is Vito's bread...make sure all others don't have sauce (the SPROC will not like it)
            if(itemUnitId != 2)
                half1SauceID         = nil
                half2SauceID         = nil
                half1SauceModifierID = nil
                half2SauceModifierID = nil
            end
        end

        orderItem['pUnitID']               = itemUnitId
        orderItem['pSpecialtyID']          = itemSpecialtyId
        orderItem['pSizeID']               = convertToInt(orderItem['pSizeID'])
        orderItem['pStyleID']              = convertToInt(orderItem['pStyleID'])
        orderItem['pHalf1SauceID']         = half1SauceID
        orderItem['pHalf2SauceID']         = half2SauceID
        orderItem['pHalf1SauceModifierID'] = half1SauceModifierID
        orderItem['pHalf2SauceModifierID'] = half2SauceModifierID
        orderItem['pOrderLineNotes']       = orderItem['pOrderLineNotes']
        orderItem['pInternetDescription']  = orderItem['pInternetDescription']
        orderItem['pQuantity']             = convertToInt(orderItem['pQuantity'])

        puts(JSON.pretty_generate(orderItem))

        orderItemResult = ActiveRecord::Base.connection.execute_procedure("AddOrderLine", orderItem);

        # OrderLineItem
        toppings = data['orderItemToppings']
        toppers = data['orderItemToppers']

        result['orderLineItemResults'] = Array.new
        result['orderLineToppers'] = Array.new
        orderLineItemResult            = Array.new

        if(toppings != nil && toppings.count > 0)
            toppings.each do |topping|
                orderLineItem = Hash.new
                orderLineItem['pOrderLineID'] = convertToInt(orderItemResult[0]['newid'])
                orderLineItem['pItemID'] = topping['id']
                case topping['portion']
                when 'whole' 
                    orderLineItem['pHalfID'] = '0'
                when 'left'
                    orderLineItem['pHalfID'] = '1'
                when 'right'
                    orderLineItem['pHalfID'] = '2'
                when '2x'
                    orderLineItem['pHalfID'] = '3'
                else
                    orderLineItem['pHalfID'] = '0'
                end
    
                orderLineItemResult = ActiveRecord::Base.connection.execute_procedure("AddOrderLineItem", orderLineItem);
                result['orderLineItemResults'].push(orderLineItemResult)
            end
        end
        if(toppers != nil && toppers.count > 0)
            toppers.each do |topper|
                orderLineTopper = Hash.new
                orderLineTopper['pOrderLineID'] = convertToInt(orderItemResult[0]['newid'])
                orderLineTopper['pTopperID'] = topper
                orderLineTopper['pTopperHalfID'] = 0
                # case topper['portion']
                # when 'whole' 
                #     orderLineItem['pHalfID'] = '0'
                # when 'left'
                #     orderLineItem['pHalfID'] = '1'
                # when 'right'
                #     orderLineItem['pHalfID'] = '2'
                # when '2x'
                #     orderLineItem['pHalfID'] = '3'
                # else
                #     orderLineItem['pHalfID'] = '0'
                # end
    
                orderLineToppperResult = ActiveRecord::Base.connection.execute_procedure("AddOrderLineTopper", orderLineTopper);
                result['orderLineToppers'].push(orderLineToppperResult)
            end
        end

        if(data['orderItemSides'] != nil && data['orderItemSides'].count > 0)
            data['orderItemSides'].each do |side|
                i = 0
                puts(side)
                while i < side['Quantity'] do
                    ActiveRecord::Base.connection.execute_procedure("AddOrderLineSide", {
                        :pOrderLineID => convertToInt(orderItemResult[0]['newid']),
                        :pSideID => side['SideID'],
                        :pIsFreeSide => 1
                    });
                    i += 1
                end
            end
        end

        # Update Price
        updatePrice = {
            :pOrderID => orderId,
            :pStoreID => storeId,
            :pCouponIDs => "",
            :pPromoCodes => ""
        }

        updatePriceResult = ActiveRecord::Base.connection.execute_procedure("WebRecalculateOrderPrice", updatePrice)


        result['order']             = orderResult
        result['orderItem']         = orderItemResult
        result['updatePriceResult'] = updatePriceResult

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

