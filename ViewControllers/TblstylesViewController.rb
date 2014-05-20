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


class TblstylesViewController
    public

    def self.getTblstyles(data)
        tblstyles = self.filterData(data)

        Array tblstylesJson = Array.new
        tblstyles.each do |tblstyles|
            tblstylesJson.push({ :id => tblstyles.id, :RADRAT => tblstyles.RADRAT, :StyleDescription => tblstyles.StyleDescription, :StyleID => tblstyles.StyleID, :StyleShortDescription => tblstyles.StyleShortDescription, :StyleSpecialMessage => tblstyles.StyleSpecialMessage, :IsActive => tblstyles.IsActive })
        end

        return tblstylesJson.to_json
    end
    
    def self.filterData(data)
        tblstyles = []

        storeId  = data['StoreID']
        unitId   = data['UnitID']
        sizeId   = data['SizeID']

        tblstyles = Tblstyles.joins("inner join trelSizeStyle on trelSizeStyle.StyleID = tblStyles.StyleID inner join trelUnitStyles on tblStyles.StyleID = trelUnitStyles.StyleID and trelUnitStyles.UnitID = #{unitId} inner join trelStoreSizeStyle on trelStoreSizeStyle.StyleID = trelSizeStyle.StyleID and trelStoreSizeStyle.SizeID = trelSizeStyle.SizeID and trelStoreSizeStyle.StoreID = #{storeId} and trelStoreSizeStyle.SizeID = #{sizeId}")

        return tblstyles
    end 

end
