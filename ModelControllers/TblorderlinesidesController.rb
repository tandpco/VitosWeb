require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblorderlinesidesController
    public
    def self.create(data)
        tblorderlinesides = Tblorderlinesides.create( :IdealSideWeight => data['IdealSideWeight'], :IsFreeSide => data['IsFreeSide'], :OrderLineID => data['OrderLineID'], :OrderLineSideID => data['OrderLineSideID'], :RADRAT => data['RADRAT'], :SideID => data['SideID'], :IdealTopperCost => data['IdealTopperCost'] )

        tblorderlinesidesJson = { :id => tblorderlinesides.id, :IdealSideWeight => tblorderlinesides.IdealSideWeight, :IsFreeSide => tblorderlinesides.IsFreeSide, :OrderLineID => tblorderlinesides.OrderLineID, :OrderLineSideID => tblorderlinesides.OrderLineSideID, :RADRAT => tblorderlinesides.RADRAT, :SideID => tblorderlinesides.SideID, :IdealTopperCost => tblorderlinesides.IdealTopperCost }

        return tblorderlinesidesJson.to_json
    end

    def self.read(data)
        tblorderlinesides = Tblorderlinesides.find(data['id'])

        tblorderlinesidesJson = { :id => tblorderlinesides.id, :IdealSideWeight => tblorderlinesides.IdealSideWeight, :IsFreeSide => tblorderlinesides.IsFreeSide, :OrderLineID => tblorderlinesides.OrderLineID, :OrderLineSideID => tblorderlinesides.OrderLineSideID, :RADRAT => tblorderlinesides.RADRAT, :SideID => tblorderlinesides.SideID, :IdealTopperCost => tblorderlinesides.IdealTopperCost }

        return tblorderlinesidesJson.to_json

    end

    def self.update(data)
        tblorderlinesides = Tblorderlinesides.update( data['id'], :IdealSideWeight => data['IdealSideWeight'], :IsFreeSide => data['IsFreeSide'], :OrderLineID => data['OrderLineID'], :OrderLineSideID => data['OrderLineSideID'], :RADRAT => data['RADRAT'], :SideID => data['SideID'], :IdealTopperCost => data['IdealTopperCost'] )

        tblorderlinesidesJson = { :status => status, :id => tblorderlinesides.id, :IdealSideWeight => tblorderlinesides.IdealSideWeight, :IsFreeSide => tblorderlinesides.IsFreeSide, :OrderLineID => tblorderlinesides.OrderLineID, :OrderLineSideID => tblorderlinesides.OrderLineSideID, :RADRAT => tblorderlinesides.RADRAT, :SideID => tblorderlinesides.SideID, :IdealTopperCost => tblorderlinesides.IdealTopperCost }

        return tblorderlinesidesJson.to_json

    end

    def self.delete(data)
        tblorderlinesides = Tblorderlinesides.find(data['id'])
        tblorderlinesides.destroy

        tblorderlinesidesJson = { :id => tblorderlinesides.id, :IdealSideWeight => tblorderlinesides.IdealSideWeight, :IsFreeSide => tblorderlinesides.IsFreeSide, :OrderLineID => tblorderlinesides.OrderLineID, :OrderLineSideID => tblorderlinesides.OrderLineSideID, :RADRAT => tblorderlinesides.RADRAT, :SideID => tblorderlinesides.SideID, :IdealTopperCost => tblorderlinesides.IdealTopperCost }

        return tblorderlinesidesJson.to_json

    end

    def self.list(data)
        tblorderlinesides = Tblorderlinesides.all

        Array tblorderlinesidesJson = Array.new
        tblorderlinesides.each do |tblorderlinesides|
            tblorderlinesidesJson.push({ :id => tblorderlinesides.id, :IdealSideWeight => tblorderlinesides.IdealSideWeight, :IsFreeSide => tblorderlinesides.IsFreeSide, :OrderLineID => tblorderlinesides.OrderLineID, :OrderLineSideID => tblorderlinesides.OrderLineSideID, :RADRAT => tblorderlinesides.RADRAT, :SideID => tblorderlinesides.SideID, :IdealTopperCost => tblorderlinesides.IdealTopperCost })
        end

        return tblorderlinesidesJson.to_json

    end

    def self.filter(data)
        tblorderlinesides = self.filterData(data)

        count = tblorderlinesides.length

        page  = data['Tblorderlinesides']['pagination']['page'].to_i
        limit = data['Tblorderlinesides']['pagination']['limit'].to_i
 
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
        tblorderlinesides = tblorderlinesides.slice(offset, limit)

        Array tblorderlinesidesJson = Array.new
        tblorderlinesides.each do |tblorderlinesides|
            tblorderlinesidesJson.push({ :id => tblorderlinesides.id, :IdealSideWeight => tblorderlinesides.IdealSideWeight, :IsFreeSide => tblorderlinesides.IsFreeSide, :OrderLineID => tblorderlinesides.OrderLineID, :OrderLineSideID => tblorderlinesides.OrderLineSideID, :RADRAT => tblorderlinesides.RADRAT, :SideID => tblorderlinesides.SideID, :IdealTopperCost => tblorderlinesides.IdealTopperCost })
        end

        tblorderlinesidesContainer = { :total => count, :tblorderlinesides => tblorderlinesidesJson }

        return tblorderlinesidesContainer.to_json

    end

    def self.filterData(data)

        tblorderlinesides = []
        if(data.key?("Tblorderlinesides"))
            filters = data['Tblorderlinesides']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblorderlinesides = Tblorderlinesides.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblorderlinesides = tblorderlinesides & Tblorderlinesides.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblorderlinesides
    end

end

