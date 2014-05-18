require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelstoreunitsizeController
    public
    def self.create(data)
        trelstoreunitsize = Trelstoreunitsize.create( :PerAdditionalItemPrice => data['PerAdditionalItemPrice'], :PercentSpecialtyItemVariance => data['PercentSpecialtyItemVariance'], :RADRAT => data['RADRAT'], :SizeID => data['SizeID'], :SpecialtyBasePrice => data['SpecialtyBasePrice'], :SpecialtyNumberIncludedItems => data['SpecialtyNumberIncludedItems'], :StandardBasePrice => data['StandardBasePrice'], :StandardNumberIncludedItems => data['StandardNumberIncludedItems'], :StoreID => data['StoreID'], :UnitID => data['UnitID'], :FreeItemFlag => data['FreeItemFlag'] )

        trelstoreunitsizeJson = { :id => trelstoreunitsize.id, :PerAdditionalItemPrice => trelstoreunitsize.PerAdditionalItemPrice, :PercentSpecialtyItemVariance => trelstoreunitsize.PercentSpecialtyItemVariance, :RADRAT => trelstoreunitsize.RADRAT, :SizeID => trelstoreunitsize.SizeID, :SpecialtyBasePrice => trelstoreunitsize.SpecialtyBasePrice, :SpecialtyNumberIncludedItems => trelstoreunitsize.SpecialtyNumberIncludedItems, :StandardBasePrice => trelstoreunitsize.StandardBasePrice, :StandardNumberIncludedItems => trelstoreunitsize.StandardNumberIncludedItems, :StoreID => trelstoreunitsize.StoreID, :UnitID => trelstoreunitsize.UnitID, :FreeItemFlag => trelstoreunitsize.FreeItemFlag }

        return trelstoreunitsizeJson.to_json
    end

    def self.read(data)
        trelstoreunitsize = Trelstoreunitsize.find(data['id'])

        trelstoreunitsizeJson = { :id => trelstoreunitsize.id, :PerAdditionalItemPrice => trelstoreunitsize.PerAdditionalItemPrice, :PercentSpecialtyItemVariance => trelstoreunitsize.PercentSpecialtyItemVariance, :RADRAT => trelstoreunitsize.RADRAT, :SizeID => trelstoreunitsize.SizeID, :SpecialtyBasePrice => trelstoreunitsize.SpecialtyBasePrice, :SpecialtyNumberIncludedItems => trelstoreunitsize.SpecialtyNumberIncludedItems, :StandardBasePrice => trelstoreunitsize.StandardBasePrice, :StandardNumberIncludedItems => trelstoreunitsize.StandardNumberIncludedItems, :StoreID => trelstoreunitsize.StoreID, :UnitID => trelstoreunitsize.UnitID, :FreeItemFlag => trelstoreunitsize.FreeItemFlag }

        return trelstoreunitsizeJson.to_json

    end

    def self.update(data)
        trelstoreunitsize = Trelstoreunitsize.update( data['id'], :PerAdditionalItemPrice => data['PerAdditionalItemPrice'], :PercentSpecialtyItemVariance => data['PercentSpecialtyItemVariance'], :RADRAT => data['RADRAT'], :SizeID => data['SizeID'], :SpecialtyBasePrice => data['SpecialtyBasePrice'], :SpecialtyNumberIncludedItems => data['SpecialtyNumberIncludedItems'], :StandardBasePrice => data['StandardBasePrice'], :StandardNumberIncludedItems => data['StandardNumberIncludedItems'], :StoreID => data['StoreID'], :UnitID => data['UnitID'], :FreeItemFlag => data['FreeItemFlag'] )

        trelstoreunitsizeJson = { :status => status, :id => trelstoreunitsize.id, :PerAdditionalItemPrice => trelstoreunitsize.PerAdditionalItemPrice, :PercentSpecialtyItemVariance => trelstoreunitsize.PercentSpecialtyItemVariance, :RADRAT => trelstoreunitsize.RADRAT, :SizeID => trelstoreunitsize.SizeID, :SpecialtyBasePrice => trelstoreunitsize.SpecialtyBasePrice, :SpecialtyNumberIncludedItems => trelstoreunitsize.SpecialtyNumberIncludedItems, :StandardBasePrice => trelstoreunitsize.StandardBasePrice, :StandardNumberIncludedItems => trelstoreunitsize.StandardNumberIncludedItems, :StoreID => trelstoreunitsize.StoreID, :UnitID => trelstoreunitsize.UnitID, :FreeItemFlag => trelstoreunitsize.FreeItemFlag }

        return trelstoreunitsizeJson.to_json

    end

    def self.delete(data)
        trelstoreunitsize = Trelstoreunitsize.find(data['id'])
        trelstoreunitsize.destroy

        trelstoreunitsizeJson = { :id => trelstoreunitsize.id, :PerAdditionalItemPrice => trelstoreunitsize.PerAdditionalItemPrice, :PercentSpecialtyItemVariance => trelstoreunitsize.PercentSpecialtyItemVariance, :RADRAT => trelstoreunitsize.RADRAT, :SizeID => trelstoreunitsize.SizeID, :SpecialtyBasePrice => trelstoreunitsize.SpecialtyBasePrice, :SpecialtyNumberIncludedItems => trelstoreunitsize.SpecialtyNumberIncludedItems, :StandardBasePrice => trelstoreunitsize.StandardBasePrice, :StandardNumberIncludedItems => trelstoreunitsize.StandardNumberIncludedItems, :StoreID => trelstoreunitsize.StoreID, :UnitID => trelstoreunitsize.UnitID, :FreeItemFlag => trelstoreunitsize.FreeItemFlag }

        return trelstoreunitsizeJson.to_json

    end

    def self.list(data)
        trelstoreunitsizes = Trelstoreunitsize.all

        Array trelstoreunitsizeJson = Array.new
        trelstoreunitsizes.each do |trelstoreunitsize|
            trelstoreunitsizeJson.push({ :id => trelstoreunitsize.id, :PerAdditionalItemPrice => trelstoreunitsize.PerAdditionalItemPrice, :PercentSpecialtyItemVariance => trelstoreunitsize.PercentSpecialtyItemVariance, :RADRAT => trelstoreunitsize.RADRAT, :SizeID => trelstoreunitsize.SizeID, :SpecialtyBasePrice => trelstoreunitsize.SpecialtyBasePrice, :SpecialtyNumberIncludedItems => trelstoreunitsize.SpecialtyNumberIncludedItems, :StandardBasePrice => trelstoreunitsize.StandardBasePrice, :StandardNumberIncludedItems => trelstoreunitsize.StandardNumberIncludedItems, :StoreID => trelstoreunitsize.StoreID, :UnitID => trelstoreunitsize.UnitID, :FreeItemFlag => trelstoreunitsize.FreeItemFlag })
        end

        return trelstoreunitsizeJson.to_json

    end

    def self.filter(data)
        trelstoreunitsizes = self.filterData(data)

        count = trelstoreunitsizes.length

        page  = data['Trelstoreunitsize']['pagination']['page'].to_i
        limit = data['Trelstoreunitsize']['pagination']['limit'].to_i
 
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
        trelstoreunitsizes = trelstoreunitsizes.slice(offset, limit)

        Array trelstoreunitsizeJson = Array.new
        trelstoreunitsizes.each do |trelstoreunitsize|
            trelstoreunitsizeJson.push({ :id => trelstoreunitsize.id, :PerAdditionalItemPrice => trelstoreunitsize.PerAdditionalItemPrice, :PercentSpecialtyItemVariance => trelstoreunitsize.PercentSpecialtyItemVariance, :RADRAT => trelstoreunitsize.RADRAT, :SizeID => trelstoreunitsize.SizeID, :SpecialtyBasePrice => trelstoreunitsize.SpecialtyBasePrice, :SpecialtyNumberIncludedItems => trelstoreunitsize.SpecialtyNumberIncludedItems, :StandardBasePrice => trelstoreunitsize.StandardBasePrice, :StandardNumberIncludedItems => trelstoreunitsize.StandardNumberIncludedItems, :StoreID => trelstoreunitsize.StoreID, :UnitID => trelstoreunitsize.UnitID, :FreeItemFlag => trelstoreunitsize.FreeItemFlag })
        end

        trelstoreunitsizeContainer = { :total => count, :trelstoreunitsizes => trelstoreunitsizeJson }

        return trelstoreunitsizeContainer.to_json

    end

    def self.filterData(data)

        trelstoreunitsizes = []
        if(data.key?("Trelstoreunitsize"))
            filters = data['Trelstoreunitsize']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelstoreunitsizes = Trelstoreunitsize.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelstoreunitsizes = trelstoreunitsizes & Trelstoreunitsize.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelstoreunitsizes
    end

end

