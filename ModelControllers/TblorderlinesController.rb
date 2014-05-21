require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblorderlinesController
    public
    def self.create(data)
        tblorderlines = Tblorderlines.create( :CouponID => data['CouponID'], :Discount => data['Discount'], :Half1SauceID => data['Half1SauceID'], :Half1SauceModifierID => data['Half1SauceModifierID'], :Half2SauceID => data['Half2SauceID'], :Half2SauceModifierID => data['Half2SauceModifierID'], :IdealCost => data['IdealCost'], :IdealHalf1SauceCost => data['IdealHalf1SauceCost'], :IdealHalf1SauceWeight => data['IdealHalf1SauceWeight'], :IdealHalf2SauceCost => data['IdealHalf2SauceCost'], :IdealHalf2SauceWeight => data['IdealHalf2SauceWeight'], :IdealStandardCost => data['IdealStandardCost'], :IdealStyleCost => data['IdealStyleCost'], :IdealStyleWeight => data['IdealStyleWeight'], :InternetDescription => data['InternetDescription'], :MPOReason => data['MPOReason'], :OrderID => data['OrderID'], :OrderLineID => data['OrderLineID'], :OrderLineNotes => data['OrderLineNotes'], :Quantity => data['Quantity'], :RADRAT => data['RADRAT'], :SizeID => data['SizeID'], :SpecialtyID => data['SpecialtyID'], :StyleID => data['StyleID'], :UnitID => data['UnitID'], :IdealCost => data['IdealCost'], :Cost => data['Cost'] )

        tblorderlinesJson = { :id => tblorderlines.id, :CouponID => tblorderlines.CouponID, :Discount => tblorderlines.Discount, :Half1SauceID => tblorderlines.Half1SauceID, :Half1SauceModifierID => tblorderlines.Half1SauceModifierID, :Half2SauceID => tblorderlines.Half2SauceID, :Half2SauceModifierID => tblorderlines.Half2SauceModifierID, :IdealCost => tblorderlines.IdealCost, :IdealHalf1SauceCost => tblorderlines.IdealHalf1SauceCost, :IdealHalf1SauceWeight => tblorderlines.IdealHalf1SauceWeight, :IdealHalf2SauceCost => tblorderlines.IdealHalf2SauceCost, :IdealHalf2SauceWeight => tblorderlines.IdealHalf2SauceWeight, :IdealStandardCost => tblorderlines.IdealStandardCost, :IdealStyleCost => tblorderlines.IdealStyleCost, :IdealStyleWeight => tblorderlines.IdealStyleWeight, :InternetDescription => tblorderlines.InternetDescription, :MPOReason => tblorderlines.MPOReason, :OrderID => tblorderlines.OrderID, :OrderLineID => tblorderlines.OrderLineID, :OrderLineNotes => tblorderlines.OrderLineNotes, :Quantity => tblorderlines.Quantity, :RADRAT => tblorderlines.RADRAT, :SizeID => tblorderlines.SizeID, :SpecialtyID => tblorderlines.SpecialtyID, :StyleID => tblorderlines.StyleID, :UnitID => tblorderlines.UnitID, :IdealCost => tblorderlines.IdealCost, :Cost => tblorderlines.Cost }

        return tblorderlinesJson.to_json
    end

    def self.read(data)
        tblorderlines = Tblorderlines.find(data['id'])

        tblorderlinesJson = { :id => tblorderlines.id, :CouponID => tblorderlines.CouponID, :Discount => tblorderlines.Discount, :Half1SauceID => tblorderlines.Half1SauceID, :Half1SauceModifierID => tblorderlines.Half1SauceModifierID, :Half2SauceID => tblorderlines.Half2SauceID, :Half2SauceModifierID => tblorderlines.Half2SauceModifierID, :IdealCost => tblorderlines.IdealCost, :IdealHalf1SauceCost => tblorderlines.IdealHalf1SauceCost, :IdealHalf1SauceWeight => tblorderlines.IdealHalf1SauceWeight, :IdealHalf2SauceCost => tblorderlines.IdealHalf2SauceCost, :IdealHalf2SauceWeight => tblorderlines.IdealHalf2SauceWeight, :IdealStandardCost => tblorderlines.IdealStandardCost, :IdealStyleCost => tblorderlines.IdealStyleCost, :IdealStyleWeight => tblorderlines.IdealStyleWeight, :InternetDescription => tblorderlines.InternetDescription, :MPOReason => tblorderlines.MPOReason, :OrderID => tblorderlines.OrderID, :OrderLineID => tblorderlines.OrderLineID, :OrderLineNotes => tblorderlines.OrderLineNotes, :Quantity => tblorderlines.Quantity, :RADRAT => tblorderlines.RADRAT, :SizeID => tblorderlines.SizeID, :SpecialtyID => tblorderlines.SpecialtyID, :StyleID => tblorderlines.StyleID, :UnitID => tblorderlines.UnitID, :IdealCost => tblorderlines.IdealCost, :Cost => tblorderlines.Cost }

        return tblorderlinesJson.to_json

    end

    def self.update(data)
        tblorderlines = Tblorderlines.update( data['id'], :CouponID => data['CouponID'], :Discount => data['Discount'], :Half1SauceID => data['Half1SauceID'], :Half1SauceModifierID => data['Half1SauceModifierID'], :Half2SauceID => data['Half2SauceID'], :Half2SauceModifierID => data['Half2SauceModifierID'], :IdealCost => data['IdealCost'], :IdealHalf1SauceCost => data['IdealHalf1SauceCost'], :IdealHalf1SauceWeight => data['IdealHalf1SauceWeight'], :IdealHalf2SauceCost => data['IdealHalf2SauceCost'], :IdealHalf2SauceWeight => data['IdealHalf2SauceWeight'], :IdealStandardCost => data['IdealStandardCost'], :IdealStyleCost => data['IdealStyleCost'], :IdealStyleWeight => data['IdealStyleWeight'], :InternetDescription => data['InternetDescription'], :MPOReason => data['MPOReason'], :OrderID => data['OrderID'], :OrderLineID => data['OrderLineID'], :OrderLineNotes => data['OrderLineNotes'], :Quantity => data['Quantity'], :RADRAT => data['RADRAT'], :SizeID => data['SizeID'], :SpecialtyID => data['SpecialtyID'], :StyleID => data['StyleID'], :UnitID => data['UnitID'], :IdealCost => data['IdealCost'], :Cost => data['Cost'] )

        tblorderlinesJson = { :id => tblorderlines.id, :CouponID => tblorderlines.CouponID, :Discount => tblorderlines.Discount, :Half1SauceID => tblorderlines.Half1SauceID, :Half1SauceModifierID => tblorderlines.Half1SauceModifierID, :Half2SauceID => tblorderlines.Half2SauceID, :Half2SauceModifierID => tblorderlines.Half2SauceModifierID, :IdealCost => tblorderlines.IdealCost, :IdealHalf1SauceCost => tblorderlines.IdealHalf1SauceCost, :IdealHalf1SauceWeight => tblorderlines.IdealHalf1SauceWeight, :IdealHalf2SauceCost => tblorderlines.IdealHalf2SauceCost, :IdealHalf2SauceWeight => tblorderlines.IdealHalf2SauceWeight, :IdealStandardCost => tblorderlines.IdealStandardCost, :IdealStyleCost => tblorderlines.IdealStyleCost, :IdealStyleWeight => tblorderlines.IdealStyleWeight, :InternetDescription => tblorderlines.InternetDescription, :MPOReason => tblorderlines.MPOReason, :OrderID => tblorderlines.OrderID, :OrderLineID => tblorderlines.OrderLineID, :OrderLineNotes => tblorderlines.OrderLineNotes, :Quantity => tblorderlines.Quantity, :RADRAT => tblorderlines.RADRAT, :SizeID => tblorderlines.SizeID, :SpecialtyID => tblorderlines.SpecialtyID, :StyleID => tblorderlines.StyleID, :UnitID => tblorderlines.UnitID, :IdealCost => tblorderlines.IdealCost, :Cost => tblorderlines.Cost }

        return tblorderlinesJson.to_json

    end

    def self.delete(data)
        tblorderlines = Tblorderlines.find(data['id'])
        tblorderlines.destroy

        tblorderlinesJson = { :id => tblorderlines.id, :CouponID => tblorderlines.CouponID, :Discount => tblorderlines.Discount, :Half1SauceID => tblorderlines.Half1SauceID, :Half1SauceModifierID => tblorderlines.Half1SauceModifierID, :Half2SauceID => tblorderlines.Half2SauceID, :Half2SauceModifierID => tblorderlines.Half2SauceModifierID, :IdealCost => tblorderlines.IdealCost, :IdealHalf1SauceCost => tblorderlines.IdealHalf1SauceCost, :IdealHalf1SauceWeight => tblorderlines.IdealHalf1SauceWeight, :IdealHalf2SauceCost => tblorderlines.IdealHalf2SauceCost, :IdealHalf2SauceWeight => tblorderlines.IdealHalf2SauceWeight, :IdealStandardCost => tblorderlines.IdealStandardCost, :IdealStyleCost => tblorderlines.IdealStyleCost, :IdealStyleWeight => tblorderlines.IdealStyleWeight, :InternetDescription => tblorderlines.InternetDescription, :MPOReason => tblorderlines.MPOReason, :OrderID => tblorderlines.OrderID, :OrderLineID => tblorderlines.OrderLineID, :OrderLineNotes => tblorderlines.OrderLineNotes, :Quantity => tblorderlines.Quantity, :RADRAT => tblorderlines.RADRAT, :SizeID => tblorderlines.SizeID, :SpecialtyID => tblorderlines.SpecialtyID, :StyleID => tblorderlines.StyleID, :UnitID => tblorderlines.UnitID, :IdealCost => tblorderlines.IdealCost, :Cost => tblorderlines.Cost }

        return tblorderlinesJson.to_json

    end

    def self.list(data)
        tblorderlines = Tblorderlines.all

        Array tblorderlinesJson = Array.new
        tblorderlines.each do |tblorderlines|
            tblorderlinesJson.push({ :id => tblorderlines.id, :CouponID => tblorderlines.CouponID, :Discount => tblorderlines.Discount, :Half1SauceID => tblorderlines.Half1SauceID, :Half1SauceModifierID => tblorderlines.Half1SauceModifierID, :Half2SauceID => tblorderlines.Half2SauceID, :Half2SauceModifierID => tblorderlines.Half2SauceModifierID, :IdealCost => tblorderlines.IdealCost, :IdealHalf1SauceCost => tblorderlines.IdealHalf1SauceCost, :IdealHalf1SauceWeight => tblorderlines.IdealHalf1SauceWeight, :IdealHalf2SauceCost => tblorderlines.IdealHalf2SauceCost, :IdealHalf2SauceWeight => tblorderlines.IdealHalf2SauceWeight, :IdealStandardCost => tblorderlines.IdealStandardCost, :IdealStyleCost => tblorderlines.IdealStyleCost, :IdealStyleWeight => tblorderlines.IdealStyleWeight, :InternetDescription => tblorderlines.InternetDescription, :MPOReason => tblorderlines.MPOReason, :OrderID => tblorderlines.OrderID, :OrderLineID => tblorderlines.OrderLineID, :OrderLineNotes => tblorderlines.OrderLineNotes, :Quantity => tblorderlines.Quantity, :RADRAT => tblorderlines.RADRAT, :SizeID => tblorderlines.SizeID, :SpecialtyID => tblorderlines.SpecialtyID, :StyleID => tblorderlines.StyleID, :UnitID => tblorderlines.UnitID, :IdealCost => tblorderlines.IdealCost, :Cost => tblorderlines.Cost })
        end

        return tblorderlinesJson.to_json

    end

    def self.filter(data)
        tblorderlines = self.filterData(data)

        count = tblorderlines.length

        page  = data['Tblorderlines']['pagination']['page'].to_i
        limit = data['Tblorderlines']['pagination']['limit'].to_i
 
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
        tblorderlines = tblorderlines.slice(offset, limit)

        Array tblorderlinesJson = Array.new
        tblorderlines.each do |tblorderlines|
            tblorderlinesJson.push({ :id => tblorderlines.id, :CouponID => tblorderlines.CouponID, :Discount => tblorderlines.Discount, :Half1SauceID => tblorderlines.Half1SauceID, :Half1SauceModifierID => tblorderlines.Half1SauceModifierID, :Half2SauceID => tblorderlines.Half2SauceID, :Half2SauceModifierID => tblorderlines.Half2SauceModifierID, :IdealCost => tblorderlines.IdealCost, :IdealHalf1SauceCost => tblorderlines.IdealHalf1SauceCost, :IdealHalf1SauceWeight => tblorderlines.IdealHalf1SauceWeight, :IdealHalf2SauceCost => tblorderlines.IdealHalf2SauceCost, :IdealHalf2SauceWeight => tblorderlines.IdealHalf2SauceWeight, :IdealStandardCost => tblorderlines.IdealStandardCost, :IdealStyleCost => tblorderlines.IdealStyleCost, :IdealStyleWeight => tblorderlines.IdealStyleWeight, :InternetDescription => tblorderlines.InternetDescription, :MPOReason => tblorderlines.MPOReason, :OrderID => tblorderlines.OrderID, :OrderLineID => tblorderlines.OrderLineID, :OrderLineNotes => tblorderlines.OrderLineNotes, :Quantity => tblorderlines.Quantity, :RADRAT => tblorderlines.RADRAT, :SizeID => tblorderlines.SizeID, :SpecialtyID => tblorderlines.SpecialtyID, :StyleID => tblorderlines.StyleID, :UnitID => tblorderlines.UnitID, :IdealCost => tblorderlines.IdealCost, :Cost => tblorderlines.Cost })
        end

        tblorderlinesContainer = { :total => count, :tblorderlines => tblorderlinesJson }

        return tblorderlinesContainer.to_json

    end

    def self.filterData(data)

        tblorderlines = []
        if(data.key?("Tblorderlines"))
            filters = data['Tblorderlines']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblorderlines = Tblorderlines.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblorderlines = tblorderlines & Tblorderlines.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblorderlines
    end

end

