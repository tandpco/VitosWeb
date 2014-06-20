require 'sinatra'
require 'json'

Dir["../ModelControllers/*.rb"].sort.each do |file|
    file.sub!(".rb","");
    require file
end

Dir["../Models/*.rb"].sort.each do |file|
    file.sub!(".rb","");
    require file
end


class TblsizesViewController
    public

    def self.getTblsizes(data)
        unitId   = data['UnitID']

        if(unitId =~ /^(#{$PIZZA}|#{$SUB})$/)
            return getSizesFromDatabase(data)
        else
            return getSizesFromJson(data)
        end
    end
    
    def self.getSizesFromDatabase(data)
        tblsizes = []

        storeId  = data['StoreID']
        unitId   = data['UnitID']

        tblsizes = Tblsizes.joins("inner join trelStoreUnitSize on trelStoreUnitSize.SizeID = tblSizes.SizeID and trelStoreUnitSize.StoreID = #{storeId} and trelStoreUnitSize.UnitID = #{unitId} and tblSizes.IsActive <> 0 order by tblSizes.SizeID")

        Array tblsizesJson = Array.new

        tblsizes.each do |tblsizes|
            tblsizesJson.push({ :id => tblsizes.id, :RADRAT => tblsizes.RADRAT, :SizeDescription => tblsizes.SizeDescription, :SizeID => tblsizes.SizeID, :SizeShortDescription => tblsizes.SizeShortDescription })
        end

        return tblsizesJson.to_json

    end 

    def self.getSizesFromJson(data)
        unitId   = data['UnitID'].to_s

        unitSizes = $sizes["Units"].select { |s| s['UnitID'] == unitId }

        tblsizesJson = "[]"

        if(unitSizes.count > 0)
            tblsizesJson = unitSizes.first['Sizes'].to_json
        end

        return tblsizesJson

    end

end
