require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblorderlinetoppersController
    public
    def self.create(data)
        tblorderlinetoppers = Tblorderlinetoppers.create( :IdealTopperWeight => data['IdealTopperWeight'], :OrderLineID => data['OrderLineID'], :OrderLineTopperID => data['OrderLineTopperID'], :RADRAT => data['RADRAT'], :TopperHalfID => data['TopperHalfID'], :TopperID => data['TopperID'], :AccountID => data['AccountID'] )

        tblorderlinetoppersJson = { :id => tblorderlinetoppers.id, :IdealTopperWeight => tblorderlinetoppers.IdealTopperWeight, :OrderLineID => tblorderlinetoppers.OrderLineID, :OrderLineTopperID => tblorderlinetoppers.OrderLineTopperID, :RADRAT => tblorderlinetoppers.RADRAT, :TopperHalfID => tblorderlinetoppers.TopperHalfID, :TopperID => tblorderlinetoppers.TopperID, :AccountID => tblorderlinetoppers.AccountID }

        return tblorderlinetoppersJson.to_json
    end

    def self.read(data)
        tblorderlinetoppers = Tblorderlinetoppers.find(data['id'])

        tblorderlinetoppersJson = { :id => tblorderlinetoppers.id, :IdealTopperWeight => tblorderlinetoppers.IdealTopperWeight, :OrderLineID => tblorderlinetoppers.OrderLineID, :OrderLineTopperID => tblorderlinetoppers.OrderLineTopperID, :RADRAT => tblorderlinetoppers.RADRAT, :TopperHalfID => tblorderlinetoppers.TopperHalfID, :TopperID => tblorderlinetoppers.TopperID, :AccountID => tblorderlinetoppers.AccountID }

        return tblorderlinetoppersJson.to_json

    end

    def self.update(data)
        tblorderlinetoppers = Tblorderlinetoppers.update( data['id'], :IdealTopperWeight => data['IdealTopperWeight'], :OrderLineID => data['OrderLineID'], :OrderLineTopperID => data['OrderLineTopperID'], :RADRAT => data['RADRAT'], :TopperHalfID => data['TopperHalfID'], :TopperID => data['TopperID'], :AccountID => data['AccountID'] )

        tblorderlinetoppersJson = { :status => status, :id => tblorderlinetoppers.id, :IdealTopperWeight => tblorderlinetoppers.IdealTopperWeight, :OrderLineID => tblorderlinetoppers.OrderLineID, :OrderLineTopperID => tblorderlinetoppers.OrderLineTopperID, :RADRAT => tblorderlinetoppers.RADRAT, :TopperHalfID => tblorderlinetoppers.TopperHalfID, :TopperID => tblorderlinetoppers.TopperID, :AccountID => tblorderlinetoppers.AccountID }

        return tblorderlinetoppersJson.to_json

    end

    def self.delete(data)
        tblorderlinetoppers = Tblorderlinetoppers.find(data['id'])
        tblorderlinetoppers.destroy

        tblorderlinetoppersJson = { :id => tblorderlinetoppers.id, :IdealTopperWeight => tblorderlinetoppers.IdealTopperWeight, :OrderLineID => tblorderlinetoppers.OrderLineID, :OrderLineTopperID => tblorderlinetoppers.OrderLineTopperID, :RADRAT => tblorderlinetoppers.RADRAT, :TopperHalfID => tblorderlinetoppers.TopperHalfID, :TopperID => tblorderlinetoppers.TopperID, :AccountID => tblorderlinetoppers.AccountID }

        return tblorderlinetoppersJson.to_json

    end

    def self.list(data)
        tblorderlinetoppers = Tblorderlinetoppers.all

        Array tblorderlinetoppersJson = Array.new
        tblorderlinetoppers.each do |tblorderlinetoppers|
            tblorderlinetoppersJson.push({ :id => tblorderlinetoppers.id, :IdealTopperWeight => tblorderlinetoppers.IdealTopperWeight, :OrderLineID => tblorderlinetoppers.OrderLineID, :OrderLineTopperID => tblorderlinetoppers.OrderLineTopperID, :RADRAT => tblorderlinetoppers.RADRAT, :TopperHalfID => tblorderlinetoppers.TopperHalfID, :TopperID => tblorderlinetoppers.TopperID, :AccountID => tblorderlinetoppers.AccountID })
        end

        return tblorderlinetoppersJson.to_json

    end

    def self.filter(data)
        tblorderlinetoppers = self.filterData(data)

        count = tblorderlinetoppers.length

        page  = data['Tblorderlinetoppers']['pagination']['page'].to_i
        limit = data['Tblorderlinetoppers']['pagination']['limit'].to_i
 
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
        tblorderlinetoppers = tblorderlinetoppers.slice(offset, limit)

        Array tblorderlinetoppersJson = Array.new
        tblorderlinetoppers.each do |tblorderlinetoppers|
            tblorderlinetoppersJson.push({ :id => tblorderlinetoppers.id, :IdealTopperWeight => tblorderlinetoppers.IdealTopperWeight, :OrderLineID => tblorderlinetoppers.OrderLineID, :OrderLineTopperID => tblorderlinetoppers.OrderLineTopperID, :RADRAT => tblorderlinetoppers.RADRAT, :TopperHalfID => tblorderlinetoppers.TopperHalfID, :TopperID => tblorderlinetoppers.TopperID, :AccountID => tblorderlinetoppers.AccountID })
        end

        tblorderlinetoppersContainer = { :total => count, :tblorderlinetoppers => tblorderlinetoppersJson }

        return tblorderlinetoppersContainer.to_json

    end

    def self.filterData(data)

        tblorderlinetoppers = []
        if(data.key?("Tblorderlinetoppers"))
            filters = data['Tblorderlinetoppers']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblorderlinetoppers = Tblorderlinetoppers.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblorderlinetoppers = tblorderlinetoppers & Tblorderlinetoppers.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblorderlinetoppers
    end

end

