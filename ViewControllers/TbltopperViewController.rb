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
    @PIZZA     = "1"
    @SUB       = "17"
    @SALAD     = "3"
    @SIDE      = "8000"
    @BEVERAGE  = "8001"

    def self.getTbltoppers(data)
        unitId   = data['UnitID']

        if(unitId == @PIZZA)
            return getTopperFromDatabase(data)
        else
            return getTopperFromJson(data)
        end
    end
    
    def self.getTopperFromDatabase(data)
        tbltopper = []

        storeId  = data['StoreID']
        unitId   = data['UnitID']

        tbltoppers = Tbltopper.joins("INNER JOIN trelUnitTopper on tblTopper.TopperID = trelUnitTopper.TopperID AND tblTopper.IsActive <> 0 INNER JOIN trelStoreUnitSize ON trelUnitTopper.UnitID = trelUnitTopper.UnitID AND trelStoreUnitSize.StoreID = #{storeId} AND trelStoreUnitSize.UnitID = #{unitId} ORDER BY tblTopper.TopperID").distinct()

        Array tbltopperJson = Array.new

        tbltoppers.each do |tbltopper|
            tbltopperJson.push({ :id => tbltopper.id, :RADRAT => tbltopper.RADRAT, :TopperDescription => tbltopper.TopperDescription, :TopperID => tbltopper.TopperID, :TopperShortDescription => tbltopper.TopperShortDescription })
        end

        return tbltopperJson.to_json

    end 

    def self.getTopperFromJson(data)
        unitId   = data['UnitID']

        unitTopper = $topper["Units"].select { |t| t['UnitID'] == unitId }
        tbltopperJson = unitTopper.first['Toppers'].to_json
    end

end
