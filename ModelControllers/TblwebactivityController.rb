require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblwebactivityController
    public
    def self.create(data)
        tblwebactivity = Tblwebactivity.create( :Address2 => data['Address2'], :City => data['City'], :Created => data['Created'], :EMail => data['EMail'], :IPAddress => data['IPAddress'], :OrderID => data['OrderID'], :OrderTypeID => data['OrderTypeID'], :PostalCode => data['PostalCode'], :RADRAT => data['RADRAT'], :RefID => data['RefID'], :SessionID => data['SessionID'], :State => data['State'], :StoreID => data['StoreID'], :WebActivityID => data['WebActivityID'], :CouponID => data['CouponID'] )

        tblwebactivityJson = { :id => tblwebactivity.id, :Address2 => tblwebactivity.Address2, :City => tblwebactivity.City, :Created => tblwebactivity.Created, :EMail => tblwebactivity.EMail, :IPAddress => tblwebactivity.IPAddress, :OrderID => tblwebactivity.OrderID, :OrderTypeID => tblwebactivity.OrderTypeID, :PostalCode => tblwebactivity.PostalCode, :RADRAT => tblwebactivity.RADRAT, :RefID => tblwebactivity.RefID, :SessionID => tblwebactivity.SessionID, :State => tblwebactivity.State, :StoreID => tblwebactivity.StoreID, :WebActivityID => tblwebactivity.WebActivityID, :CouponID => tblwebactivity.CouponID }

        return tblwebactivityJson.to_json
    end

    def self.read(data)
        tblwebactivity = Tblwebactivity.find(data['id'])

        tblwebactivityJson = { :id => tblwebactivity.id, :Address2 => tblwebactivity.Address2, :City => tblwebactivity.City, :Created => tblwebactivity.Created, :EMail => tblwebactivity.EMail, :IPAddress => tblwebactivity.IPAddress, :OrderID => tblwebactivity.OrderID, :OrderTypeID => tblwebactivity.OrderTypeID, :PostalCode => tblwebactivity.PostalCode, :RADRAT => tblwebactivity.RADRAT, :RefID => tblwebactivity.RefID, :SessionID => tblwebactivity.SessionID, :State => tblwebactivity.State, :StoreID => tblwebactivity.StoreID, :WebActivityID => tblwebactivity.WebActivityID, :CouponID => tblwebactivity.CouponID }

        return tblwebactivityJson.to_json

    end

    def self.update(data)
        tblwebactivity = Tblwebactivity.update( data['id'], :Address2 => data['Address2'], :City => data['City'], :Created => data['Created'], :EMail => data['EMail'], :IPAddress => data['IPAddress'], :OrderID => data['OrderID'], :OrderTypeID => data['OrderTypeID'], :PostalCode => data['PostalCode'], :RADRAT => data['RADRAT'], :RefID => data['RefID'], :SessionID => data['SessionID'], :State => data['State'], :StoreID => data['StoreID'], :WebActivityID => data['WebActivityID'], :CouponID => data['CouponID'] )

        tblwebactivityJson = { :id => tblwebactivity.id, :Address2 => tblwebactivity.Address2, :City => tblwebactivity.City, :Created => tblwebactivity.Created, :EMail => tblwebactivity.EMail, :IPAddress => tblwebactivity.IPAddress, :OrderID => tblwebactivity.OrderID, :OrderTypeID => tblwebactivity.OrderTypeID, :PostalCode => tblwebactivity.PostalCode, :RADRAT => tblwebactivity.RADRAT, :RefID => tblwebactivity.RefID, :SessionID => tblwebactivity.SessionID, :State => tblwebactivity.State, :StoreID => tblwebactivity.StoreID, :WebActivityID => tblwebactivity.WebActivityID, :CouponID => tblwebactivity.CouponID }

        return tblwebactivityJson.to_json

    end

    def self.delete(data)
        tblwebactivity = Tblwebactivity.find(data['id'])
        tblwebactivity.destroy

        tblwebactivityJson = { :id => tblwebactivity.id, :Address2 => tblwebactivity.Address2, :City => tblwebactivity.City, :Created => tblwebactivity.Created, :EMail => tblwebactivity.EMail, :IPAddress => tblwebactivity.IPAddress, :OrderID => tblwebactivity.OrderID, :OrderTypeID => tblwebactivity.OrderTypeID, :PostalCode => tblwebactivity.PostalCode, :RADRAT => tblwebactivity.RADRAT, :RefID => tblwebactivity.RefID, :SessionID => tblwebactivity.SessionID, :State => tblwebactivity.State, :StoreID => tblwebactivity.StoreID, :WebActivityID => tblwebactivity.WebActivityID, :CouponID => tblwebactivity.CouponID }

        return tblwebactivityJson.to_json

    end

    def self.list(data)
        tblwebactivities = Tblwebactivity.all

        Array tblwebactivityJson = Array.new
        tblwebactivities.each do |tblwebactivity|
            tblwebactivityJson.push({ :id => tblwebactivity.id, :Address2 => tblwebactivity.Address2, :City => tblwebactivity.City, :Created => tblwebactivity.Created, :EMail => tblwebactivity.EMail, :IPAddress => tblwebactivity.IPAddress, :OrderID => tblwebactivity.OrderID, :OrderTypeID => tblwebactivity.OrderTypeID, :PostalCode => tblwebactivity.PostalCode, :RADRAT => tblwebactivity.RADRAT, :RefID => tblwebactivity.RefID, :SessionID => tblwebactivity.SessionID, :State => tblwebactivity.State, :StoreID => tblwebactivity.StoreID, :WebActivityID => tblwebactivity.WebActivityID, :CouponID => tblwebactivity.CouponID })
        end

        return tblwebactivityJson.to_json

    end

    def self.filter(data)
        tblwebactivities = self.filterData(data)

        count = tblwebactivities.length

        page  = data['Tblwebactivity']['pagination']['page'].to_i
        limit = data['Tblwebactivity']['pagination']['limit'].to_i
 
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
        tblwebactivities = tblwebactivities.slice(offset, limit)

        Array tblwebactivityJson = Array.new
        tblwebactivities.each do |tblwebactivity|
            tblwebactivityJson.push({ :id => tblwebactivity.id, :Address2 => tblwebactivity.Address2, :City => tblwebactivity.City, :Created => tblwebactivity.Created, :EMail => tblwebactivity.EMail, :IPAddress => tblwebactivity.IPAddress, :OrderID => tblwebactivity.OrderID, :OrderTypeID => tblwebactivity.OrderTypeID, :PostalCode => tblwebactivity.PostalCode, :RADRAT => tblwebactivity.RADRAT, :RefID => tblwebactivity.RefID, :SessionID => tblwebactivity.SessionID, :State => tblwebactivity.State, :StoreID => tblwebactivity.StoreID, :WebActivityID => tblwebactivity.WebActivityID, :CouponID => tblwebactivity.CouponID })
        end

        tblwebactivityContainer = { :total => count, :tblwebactivities => tblwebactivityJson }

        return tblwebactivityContainer.to_json

    end

    def self.filterData(data)

        tblwebactivities = []
        if(data.key?("Tblwebactivity"))
            filters = data['Tblwebactivity']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblwebactivities = Tblwebactivity.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblwebactivities = tblwebactivities & Tblwebactivity.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblwebactivities
    end

end

