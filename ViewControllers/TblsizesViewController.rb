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


class TblsizesViewController
    public

    def self.getTblsizes(data)
        tblsizes = self.filterData(data)

        Array tblsizesJson = Array.new
        tblsizes.each do |tblsizes|
            tblsizesJson.push({ :id => tblsizes.id, :RADRAT => tblsizes.RADRAT, :SizeDescription => tblsizes.SizeDescription, :SizeID => tblsizes.SizeID, :SizeShortDescription => tblsizes.SizeShortDescription })
        end

        return tblsizesJson.to_json
    end
    
    def self.filterData(data)
        tblsizes = []

        storeId  = data['StoreID']
        unitId   = data['UnitID']

        tblsizes = Tblsizes.joins("inner join trelStoreUnitSize on trelStoreUnitSize.SizeID = tblSizes.SizeID and trelStoreUnitSize.StoreID = #{storeId} and trelStoreUnitSize.UnitID = #{unitId} and tblSizes.IsActive <> 0 order by tblSizes.SizeID")

        return tblsizes
    end 

end
