require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblcustomersController
    public
    def self.create(data)
        tblcustomers = Tblcustomers.create( :CellPhone => data['CellPhone'], :CustomerID => data['CustomerID'], :EMail => data['EMail'], :FAXPhone => data['FAXPhone'], :FirstName => data['FirstName'], :HomePhone => data['HomePhone'], :IsEMailList => data['IsEMailList'], :IsTextList => data['IsTextList'], :LastName => data['LastName'], :NoChecks => data['NoChecks'], :Password => data['Password'], :PrimaryAddressID => data['PrimaryAddressID'], :RADRAT => data['RADRAT'], :WorkPhone => data['WorkPhone'], :IsActive => data['IsActive'] )

        tblcustomersJson = { :id => tblcustomers.id, :CellPhone => tblcustomers.CellPhone, :CustomerID => tblcustomers.CustomerID, :EMail => tblcustomers.EMail, :FAXPhone => tblcustomers.FAXPhone, :FirstName => tblcustomers.FirstName, :HomePhone => tblcustomers.HomePhone, :IsEMailList => tblcustomers.IsEMailList, :IsTextList => tblcustomers.IsTextList, :LastName => tblcustomers.LastName, :NoChecks => tblcustomers.NoChecks, :Password => tblcustomers.Password, :PrimaryAddressID => tblcustomers.PrimaryAddressID, :RADRAT => tblcustomers.RADRAT, :WorkPhone => tblcustomers.WorkPhone, :IsActive => tblcustomers.IsActive }

        return tblcustomersJson.to_json
    end

    def self.read(data)
        tblcustomers = Tblcustomers.find(data['id'])

        tblcustomersJson = { :id => tblcustomers.id, :CellPhone => tblcustomers.CellPhone, :CustomerID => tblcustomers.CustomerID, :EMail => tblcustomers.EMail, :FAXPhone => tblcustomers.FAXPhone, :FirstName => tblcustomers.FirstName, :HomePhone => tblcustomers.HomePhone, :IsEMailList => tblcustomers.IsEMailList, :IsTextList => tblcustomers.IsTextList, :LastName => tblcustomers.LastName, :NoChecks => tblcustomers.NoChecks, :Password => tblcustomers.Password, :PrimaryAddressID => tblcustomers.PrimaryAddressID, :RADRAT => tblcustomers.RADRAT, :WorkPhone => tblcustomers.WorkPhone, :IsActive => tblcustomers.IsActive }

        return tblcustomersJson.to_json

    end

    def self.update(data)
        tblcustomers = Tblcustomers.update( data['id'], :CellPhone => data['CellPhone'], :CustomerID => data['CustomerID'], :EMail => data['EMail'], :FAXPhone => data['FAXPhone'], :FirstName => data['FirstName'], :HomePhone => data['HomePhone'], :IsEMailList => data['IsEMailList'], :IsTextList => data['IsTextList'], :LastName => data['LastName'], :NoChecks => data['NoChecks'], :Password => data['Password'], :PrimaryAddressID => data['PrimaryAddressID'], :RADRAT => data['RADRAT'], :WorkPhone => data['WorkPhone'], :IsActive => data['IsActive'] )

        tblcustomersJson = { :status => status, :id => tblcustomers.id, :CellPhone => tblcustomers.CellPhone, :CustomerID => tblcustomers.CustomerID, :EMail => tblcustomers.EMail, :FAXPhone => tblcustomers.FAXPhone, :FirstName => tblcustomers.FirstName, :HomePhone => tblcustomers.HomePhone, :IsEMailList => tblcustomers.IsEMailList, :IsTextList => tblcustomers.IsTextList, :LastName => tblcustomers.LastName, :NoChecks => tblcustomers.NoChecks, :Password => tblcustomers.Password, :PrimaryAddressID => tblcustomers.PrimaryAddressID, :RADRAT => tblcustomers.RADRAT, :WorkPhone => tblcustomers.WorkPhone, :IsActive => tblcustomers.IsActive }

        return tblcustomersJson.to_json

    end

    def self.delete(data)
        tblcustomers = Tblcustomers.find(data['id'])
        tblcustomers.destroy

        tblcustomersJson = { :id => tblcustomers.id, :CellPhone => tblcustomers.CellPhone, :CustomerID => tblcustomers.CustomerID, :EMail => tblcustomers.EMail, :FAXPhone => tblcustomers.FAXPhone, :FirstName => tblcustomers.FirstName, :HomePhone => tblcustomers.HomePhone, :IsEMailList => tblcustomers.IsEMailList, :IsTextList => tblcustomers.IsTextList, :LastName => tblcustomers.LastName, :NoChecks => tblcustomers.NoChecks, :Password => tblcustomers.Password, :PrimaryAddressID => tblcustomers.PrimaryAddressID, :RADRAT => tblcustomers.RADRAT, :WorkPhone => tblcustomers.WorkPhone, :IsActive => tblcustomers.IsActive }

        return tblcustomersJson.to_json

    end

    def self.list(data)
        tblcustomers = Tblcustomers.all

        Array tblcustomersJson = Array.new
        tblcustomers.each do |tblcustomers|
            tblcustomersJson.push({ :id => tblcustomers.id, :CellPhone => tblcustomers.CellPhone, :CustomerID => tblcustomers.CustomerID, :EMail => tblcustomers.EMail, :FAXPhone => tblcustomers.FAXPhone, :FirstName => tblcustomers.FirstName, :HomePhone => tblcustomers.HomePhone, :IsEMailList => tblcustomers.IsEMailList, :IsTextList => tblcustomers.IsTextList, :LastName => tblcustomers.LastName, :NoChecks => tblcustomers.NoChecks, :Password => tblcustomers.Password, :PrimaryAddressID => tblcustomers.PrimaryAddressID, :RADRAT => tblcustomers.RADRAT, :WorkPhone => tblcustomers.WorkPhone, :IsActive => tblcustomers.IsActive })
        end

        return tblcustomersJson.to_json

    end

    def self.filter(data)
        tblcustomers = self.filterData(data)

        count = tblcustomers.length

        page  = data['Tblcustomers']['pagination']['page'].to_i
        limit = data['Tblcustomers']['pagination']['limit'].to_i
 
        # Make sure page isn't out of range
        if(page < 1)
            page = 1
        end
 
        if(((page * limit) - limit) > count)
            page = (count / limit).to_i
            if(count % limit > 0)
                page += 1
            end
        end
 
        offset = (page - 1) * limit
        tblcustomers = tblcustomers.slice(offset, limit)

        Array tblcustomersJson = Array.new
        tblcustomers.each do |tblcustomers|
            tblcustomersJson.push({ :id => tblcustomers.id, :CellPhone => tblcustomers.CellPhone, :CustomerID => tblcustomers.CustomerID, :EMail => tblcustomers.EMail, :FAXPhone => tblcustomers.FAXPhone, :FirstName => tblcustomers.FirstName, :HomePhone => tblcustomers.HomePhone, :IsEMailList => tblcustomers.IsEMailList, :IsTextList => tblcustomers.IsTextList, :LastName => tblcustomers.LastName, :NoChecks => tblcustomers.NoChecks, :Password => tblcustomers.Password, :PrimaryAddressID => tblcustomers.PrimaryAddressID, :RADRAT => tblcustomers.RADRAT, :WorkPhone => tblcustomers.WorkPhone, :IsActive => tblcustomers.IsActive })
        end

        tblcustomersContainer = { :total => count, :tblcustomers => tblcustomersJson }

        return tblcustomersContainer.to_json

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

