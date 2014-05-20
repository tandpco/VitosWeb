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
        tblcustomers = self.filterData(data)

        Array tblcustomersJson = Array.new
        tblcustomers.each do |tblcustomers|

            tbladdresses = Tbladdresses.where("AddressID = #{tblcustomers.PrimaryAddressID}")

            tblcustomersJson.push({ :PostalCode => tbladdresses[0].PostalCode, :AddressLine1 => tbladdresses[0].AddressLine1, :CellPhone => tblcustomers.CellPhone, :CustomerID => tblcustomers.CustomerID, :EMail => tblcustomers.EMail, :FAXPhone => tblcustomers.FAXPhone, :FirstName => tblcustomers.FirstName, :HomePhone => tblcustomers.HomePhone, :IsEMailList => tblcustomers.IsEMailList, :IsTextList => tblcustomers.IsTextList, :LastName => tblcustomers.LastName, :NoChecks => tblcustomers.NoChecks, :Password => tblcustomers.Password, :PrimaryAddressID => tblcustomers.PrimaryAddressID, :RADRAT => tblcustomers.RADRAT, :WorkPhone => tblcustomers.WorkPhone })
        end

        return tblcustomersJson.to_json
    end

    def self.filterData(data)

        tblcustomers = []
        if(data.key?("Tblcustomers"))
            filters = data['Tblcustomers']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblcustomers = Tblcustomers.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblcustomers = tblcustomers & Tblcustomers.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblcustomers
    end

end
