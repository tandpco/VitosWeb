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
        pSessionId = data['pSessionId']
        pIpAddress = data['pIpAddress']
        pRefId = data['pRefId']
        pTransactionDate = data['pTransactionDate']
        pStoreId = data['pStoreId']
        pCustomerId = data['pCustomerId']
        pCustomerName = data['pCustomerName']
        pCustomerPhone = data['pCustomerPhone']
        pAddressId = data['pAddressId']
        pOrderTypeId = data['pOrderTypeId']
        pDeliveryCharge = data['pDeliveryCharge']
        pDriverMoney = data['pDriverMoney']
        pOrderNotes = data['pOrderNotes']
        
        result = Tblorders.connection.execute_procedure("AddOrder", pSessionId, pIpAddress, 1, pRefId, pTransactionDate, pStoreId, pCustomerId, pCustomerName, pCustomerPhone, pAddressId, pOrderTypeId, pDeliveryCharge, pDriverMoney, pOrderNotes)


        return result.to_json
    end

end
