require 'sinatra'
require 'json'

class StoreViewController
    public

    def self.getStore(data)
        storeId   = data['storeId'].to_s

        rows = ActiveRecord::Base.connection.select_all('select distinct StoreID, StoreName, Address1, Address2, City, State, PostalCode, Phone, Fax, Hours from tblStores where storeid = ' + storeId)

        return rows.to_json
    end

    def self.listStores(data)
        email     = data['email']
        password  = data['password']

        rows = ActiveRecord::Base.connection.select_all('select distinct StoreID, StoreName, Address1, Address2, City, State, PostalCode, Phone, Fax, Hours from tblStores where storeid > 0')

        return rows.to_json
    end

end

