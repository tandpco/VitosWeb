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


class TbltopperViewController
    public

    def self.getTbltoppers(data)
        tbltoppers = self.filterData(data)

        Array tbltopperJson = Array.new
        tbltoppers.each do |tbltopper|
            tbltopperJson.push({ :id => tbltopper.id, :RADRAT => tbltopper.RADRAT, :TopperDescription => tbltopper.TopperDescription, :TopperID => tbltopper.TopperID, :TopperShortDescription => tbltopper.TopperShortDescription })
        end

        return tbltoppers.to_json
    end
    
    def self.filterData(data)
        tbltoppers = []

        storeId  = data['StoreID']
        unitId   = data['UnitID']

        tbltoppers = Tbltopper.joins("INNER JOIN trelUnitTopper on tblTopper.TopperID = trelUnitTopper.TopperID AND tblTopper.IsActive <> 0 INNER JOIN trelStoreUnitSize ON trelUnitTopper.UnitID = trelUnitTopper.UnitID AND trelStoreUnitSize.StoreID = #{storeId} AND trelStoreUnitSize.UnitID = #{unitId} ORDER BY tblTopper.TopperID").distinct()

        return tbltoppers
    end 

end
