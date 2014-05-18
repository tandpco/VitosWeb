require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblcouponappliestoController
    public
    def self.create(data)
        tblcouponappliesto = Tblcouponappliesto.create( :ComboChoice => data['ComboChoice'], :ComboQuantity => data['ComboQuantity'], :CouponAppliesToID => data['CouponAppliesToID'], :CouponID => data['CouponID'], :DollarOff => data['DollarOff'], :FixedPrice => data['FixedPrice'], :MinimumPrice => data['MinimumPrice'], :RADRAT => data['RADRAT'], :SizeID => data['SizeID'], :SpecialtyID => data['SpecialtyID'], :StyleID => data['StyleID'], :UnitID => data['UnitID'], :CouponDateRangeID => data['CouponDateRangeID'] )

        tblcouponappliestoJson = { :id => tblcouponappliesto.id, :ComboChoice => tblcouponappliesto.ComboChoice, :ComboQuantity => tblcouponappliesto.ComboQuantity, :CouponAppliesToID => tblcouponappliesto.CouponAppliesToID, :CouponID => tblcouponappliesto.CouponID, :DollarOff => tblcouponappliesto.DollarOff, :FixedPrice => tblcouponappliesto.FixedPrice, :MinimumPrice => tblcouponappliesto.MinimumPrice, :RADRAT => tblcouponappliesto.RADRAT, :SizeID => tblcouponappliesto.SizeID, :SpecialtyID => tblcouponappliesto.SpecialtyID, :StyleID => tblcouponappliesto.StyleID, :UnitID => tblcouponappliesto.UnitID, :CouponDateRangeID => tblcouponappliesto.CouponDateRangeID }

        return tblcouponappliestoJson.to_json
    end

    def self.read(data)
        tblcouponappliesto = Tblcouponappliesto.find(data['id'])

        tblcouponappliestoJson = { :id => tblcouponappliesto.id, :ComboChoice => tblcouponappliesto.ComboChoice, :ComboQuantity => tblcouponappliesto.ComboQuantity, :CouponAppliesToID => tblcouponappliesto.CouponAppliesToID, :CouponID => tblcouponappliesto.CouponID, :DollarOff => tblcouponappliesto.DollarOff, :FixedPrice => tblcouponappliesto.FixedPrice, :MinimumPrice => tblcouponappliesto.MinimumPrice, :RADRAT => tblcouponappliesto.RADRAT, :SizeID => tblcouponappliesto.SizeID, :SpecialtyID => tblcouponappliesto.SpecialtyID, :StyleID => tblcouponappliesto.StyleID, :UnitID => tblcouponappliesto.UnitID, :CouponDateRangeID => tblcouponappliesto.CouponDateRangeID }

        return tblcouponappliestoJson.to_json

    end

    def self.update(data)
        tblcouponappliesto = Tblcouponappliesto.update( data['id'], :ComboChoice => data['ComboChoice'], :ComboQuantity => data['ComboQuantity'], :CouponAppliesToID => data['CouponAppliesToID'], :CouponID => data['CouponID'], :DollarOff => data['DollarOff'], :FixedPrice => data['FixedPrice'], :MinimumPrice => data['MinimumPrice'], :RADRAT => data['RADRAT'], :SizeID => data['SizeID'], :SpecialtyID => data['SpecialtyID'], :StyleID => data['StyleID'], :UnitID => data['UnitID'], :CouponDateRangeID => data['CouponDateRangeID'] )

        tblcouponappliestoJson = { :status => status, :id => tblcouponappliesto.id, :ComboChoice => tblcouponappliesto.ComboChoice, :ComboQuantity => tblcouponappliesto.ComboQuantity, :CouponAppliesToID => tblcouponappliesto.CouponAppliesToID, :CouponID => tblcouponappliesto.CouponID, :DollarOff => tblcouponappliesto.DollarOff, :FixedPrice => tblcouponappliesto.FixedPrice, :MinimumPrice => tblcouponappliesto.MinimumPrice, :RADRAT => tblcouponappliesto.RADRAT, :SizeID => tblcouponappliesto.SizeID, :SpecialtyID => tblcouponappliesto.SpecialtyID, :StyleID => tblcouponappliesto.StyleID, :UnitID => tblcouponappliesto.UnitID, :CouponDateRangeID => tblcouponappliesto.CouponDateRangeID }

        return tblcouponappliestoJson.to_json

    end

    def self.delete(data)
        tblcouponappliesto = Tblcouponappliesto.find(data['id'])
        tblcouponappliesto.destroy

        tblcouponappliestoJson = { :id => tblcouponappliesto.id, :ComboChoice => tblcouponappliesto.ComboChoice, :ComboQuantity => tblcouponappliesto.ComboQuantity, :CouponAppliesToID => tblcouponappliesto.CouponAppliesToID, :CouponID => tblcouponappliesto.CouponID, :DollarOff => tblcouponappliesto.DollarOff, :FixedPrice => tblcouponappliesto.FixedPrice, :MinimumPrice => tblcouponappliesto.MinimumPrice, :RADRAT => tblcouponappliesto.RADRAT, :SizeID => tblcouponappliesto.SizeID, :SpecialtyID => tblcouponappliesto.SpecialtyID, :StyleID => tblcouponappliesto.StyleID, :UnitID => tblcouponappliesto.UnitID, :CouponDateRangeID => tblcouponappliesto.CouponDateRangeID }

        return tblcouponappliestoJson.to_json

    end

    def self.list(data)
        tblcouponappliestos = Tblcouponappliesto.all

        Array tblcouponappliestoJson = Array.new
        tblcouponappliestos.each do |tblcouponappliesto|
            tblcouponappliestoJson.push({ :id => tblcouponappliesto.id, :ComboChoice => tblcouponappliesto.ComboChoice, :ComboQuantity => tblcouponappliesto.ComboQuantity, :CouponAppliesToID => tblcouponappliesto.CouponAppliesToID, :CouponID => tblcouponappliesto.CouponID, :DollarOff => tblcouponappliesto.DollarOff, :FixedPrice => tblcouponappliesto.FixedPrice, :MinimumPrice => tblcouponappliesto.MinimumPrice, :RADRAT => tblcouponappliesto.RADRAT, :SizeID => tblcouponappliesto.SizeID, :SpecialtyID => tblcouponappliesto.SpecialtyID, :StyleID => tblcouponappliesto.StyleID, :UnitID => tblcouponappliesto.UnitID, :CouponDateRangeID => tblcouponappliesto.CouponDateRangeID })
        end

        return tblcouponappliestoJson.to_json

    end

    def self.filter(data)
        tblcouponappliestos = self.filterData(data)

        count = tblcouponappliestos.length

        page  = data['Tblcouponappliesto']['pagination']['page'].to_i
        limit = data['Tblcouponappliesto']['pagination']['limit'].to_i
 
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
        tblcouponappliestos = tblcouponappliestos.slice(offset, limit)

        Array tblcouponappliestoJson = Array.new
        tblcouponappliestos.each do |tblcouponappliesto|
            tblcouponappliestoJson.push({ :id => tblcouponappliesto.id, :ComboChoice => tblcouponappliesto.ComboChoice, :ComboQuantity => tblcouponappliesto.ComboQuantity, :CouponAppliesToID => tblcouponappliesto.CouponAppliesToID, :CouponID => tblcouponappliesto.CouponID, :DollarOff => tblcouponappliesto.DollarOff, :FixedPrice => tblcouponappliesto.FixedPrice, :MinimumPrice => tblcouponappliesto.MinimumPrice, :RADRAT => tblcouponappliesto.RADRAT, :SizeID => tblcouponappliesto.SizeID, :SpecialtyID => tblcouponappliesto.SpecialtyID, :StyleID => tblcouponappliesto.StyleID, :UnitID => tblcouponappliesto.UnitID, :CouponDateRangeID => tblcouponappliesto.CouponDateRangeID })
        end

        tblcouponappliestoContainer = { :total => count, :tblcouponappliestos => tblcouponappliestoJson }

        return tblcouponappliestoContainer.to_json

    end

    def self.filterData(data)

        tblcouponappliestos = []
        if(data.key?("Tblcouponappliesto"))
            filters = data['Tblcouponappliesto']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblcouponappliestos = Tblcouponappliesto.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblcouponappliestos = tblcouponappliestos & Tblcouponappliesto.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblcouponappliestos
    end

end

