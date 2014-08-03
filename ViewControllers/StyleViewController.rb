require 'sinatra'
require 'json'

class StyleViewController
    public

    def self.listStyles(data)
    
        unitId   = data['UnitID']

        if(unitId.to_i >= $SIDE.to_i)
            return listStyleFromJson(data)
        else
            return listStyleFromDatabase(data)
        end
    end
    
    def self.listStyleFromDatabase(data)
        storeId  = data['StoreID']
        unitId   = data['UnitID']
        sizeId   = data['SizeID']

        rows = ActiveRecord::Base.connection.select_all('SELECT [tblstyles].* FROM [tblstyles] inner join trelSizeStyle on trelSizeStyle.StyleID = tblStyles.StyleID inner join trelUnitStyles on tblStyles.StyleID = trelUnitStyles.StyleID and trelUnitStyles.UnitID = ' + unitId + ' inner join trelStoreSizeStyle on trelStoreSizeStyle.StyleID = trelSizeStyle.StyleID and trelStoreSizeStyle.SizeID = trelSizeStyle.SizeID and trelStoreSizeStyle.StoreID = ' + storeId + ' and trelStoreSizeStyle.SizeID = ' + sizeId + ' AND 1 = 1')

        return rows.to_json
    end
    
    def self.listStyleFromJson(data)
        unitId   = data['UnitID'].to_s

        unitStyle = $styles["Units"].select { |t| t['UnitID'] == unitId }

        styleJson = "[]"

        if(unitStyle.count > 0)
            styleJson = unitStyle.first['Styles'].to_json
        end

        return styleJson

    end


end

