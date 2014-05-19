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


class TblcustomersViewController
    public

    def self.getTblcustomers(data)
        customerId = data['CustomerID']
        whereClause = "CustomerID >= " + customerId + " AND EMail IS NOT NULL"
        tblcustomers = Tblcustomers.where(whereClause)        

        Array tblcustomersJson = Array.new
        tblcustomers.each do |tblcustomers|
            tblcustomersJson.push({ :id => tblcustomers.id, :CellPhone => tblcustomers.CellPhone, :CustomerID => tblcustomers.CustomerID, :EMail => tblcustomers.EMail, :FAXPhone => tblcustomers.FAXPhone, :FirstName => tblcustomers.FirstName, :HomePhone => tblcustomers.HomePhone, :IsEMailList => tblcustomers.IsEMailList, :IsTextList => tblcustomers.IsTextList, :LastName => tblcustomers.LastName, :NoChecks => tblcustomers.NoChecks, :Password => tblcustomers.Password, :PrimaryAddressID => tblcustomers.PrimaryAddressID, :RADRAT => tblcustomers.RADRAT, :WorkPhone => tblcustomers.WorkPhone })
        end

        return tblcustomersJson.to_json
    end
end
