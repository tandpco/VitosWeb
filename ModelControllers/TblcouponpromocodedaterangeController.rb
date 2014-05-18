require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblcouponpromocodedaterangeController
    public
    def self.create(data)
        tblcouponpromocodedaterange = Tblcouponpromocodedaterange.create( :PromoCodeDateRangeID => data['PromoCodeDateRangeID'], :RADRAT => data['RADRAT'], :ValidFrom => data['ValidFrom'], :ValidTo => data['ValidTo'], :CouponID => data['CouponID'] )

        tblcouponpromocodedaterangeJson = { :id => tblcouponpromocodedaterange.id, :PromoCodeDateRangeID => tblcouponpromocodedaterange.PromoCodeDateRangeID, :RADRAT => tblcouponpromocodedaterange.RADRAT, :ValidFrom => tblcouponpromocodedaterange.ValidFrom, :ValidTo => tblcouponpromocodedaterange.ValidTo, :CouponID => tblcouponpromocodedaterange.CouponID }

        return tblcouponpromocodedaterangeJson.to_json
    end

    def self.read(data)
        tblcouponpromocodedaterange = Tblcouponpromocodedaterange.find(data['id'])

        tblcouponpromocodedaterangeJson = { :id => tblcouponpromocodedaterange.id, :PromoCodeDateRangeID => tblcouponpromocodedaterange.PromoCodeDateRangeID, :RADRAT => tblcouponpromocodedaterange.RADRAT, :ValidFrom => tblcouponpromocodedaterange.ValidFrom, :ValidTo => tblcouponpromocodedaterange.ValidTo, :CouponID => tblcouponpromocodedaterange.CouponID }

        return tblcouponpromocodedaterangeJson.to_json

    end

    def self.update(data)
        tblcouponpromocodedaterange = Tblcouponpromocodedaterange.update( data['id'], :PromoCodeDateRangeID => data['PromoCodeDateRangeID'], :RADRAT => data['RADRAT'], :ValidFrom => data['ValidFrom'], :ValidTo => data['ValidTo'], :CouponID => data['CouponID'] )

        tblcouponpromocodedaterangeJson = { :id => tblcouponpromocodedaterange.id, :PromoCodeDateRangeID => tblcouponpromocodedaterange.PromoCodeDateRangeID, :RADRAT => tblcouponpromocodedaterange.RADRAT, :ValidFrom => tblcouponpromocodedaterange.ValidFrom, :ValidTo => tblcouponpromocodedaterange.ValidTo, :CouponID => tblcouponpromocodedaterange.CouponID }

        return tblcouponpromocodedaterangeJson.to_json

    end

    def self.delete(data)
        tblcouponpromocodedaterange = Tblcouponpromocodedaterange.find(data['id'])
        tblcouponpromocodedaterange.destroy

        tblcouponpromocodedaterangeJson = { :id => tblcouponpromocodedaterange.id, :PromoCodeDateRangeID => tblcouponpromocodedaterange.PromoCodeDateRangeID, :RADRAT => tblcouponpromocodedaterange.RADRAT, :ValidFrom => tblcouponpromocodedaterange.ValidFrom, :ValidTo => tblcouponpromocodedaterange.ValidTo, :CouponID => tblcouponpromocodedaterange.CouponID }

        return tblcouponpromocodedaterangeJson.to_json

    end

    def self.list(data)
        tblcouponpromocodedateranges = Tblcouponpromocodedaterange.all

        Array tblcouponpromocodedaterangeJson = Array.new
        tblcouponpromocodedateranges.each do |tblcouponpromocodedaterange|
            tblcouponpromocodedaterangeJson.push({ :id => tblcouponpromocodedaterange.id, :PromoCodeDateRangeID => tblcouponpromocodedaterange.PromoCodeDateRangeID, :RADRAT => tblcouponpromocodedaterange.RADRAT, :ValidFrom => tblcouponpromocodedaterange.ValidFrom, :ValidTo => tblcouponpromocodedaterange.ValidTo, :CouponID => tblcouponpromocodedaterange.CouponID })
        end

        return tblcouponpromocodedaterangeJson.to_json

    end

    def self.filter(data)
        tblcouponpromocodedateranges = self.filterData(data)

        count = tblcouponpromocodedateranges.length

        page  = data['Tblcouponpromocodedaterange']['pagination']['page'].to_i
        limit = data['Tblcouponpromocodedaterange']['pagination']['limit'].to_i
 
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
        tblcouponpromocodedateranges = tblcouponpromocodedateranges.slice(offset, limit)

        Array tblcouponpromocodedaterangeJson = Array.new
        tblcouponpromocodedateranges.each do |tblcouponpromocodedaterange|
            tblcouponpromocodedaterangeJson.push({ :id => tblcouponpromocodedaterange.id, :PromoCodeDateRangeID => tblcouponpromocodedaterange.PromoCodeDateRangeID, :RADRAT => tblcouponpromocodedaterange.RADRAT, :ValidFrom => tblcouponpromocodedaterange.ValidFrom, :ValidTo => tblcouponpromocodedaterange.ValidTo, :CouponID => tblcouponpromocodedaterange.CouponID })
        end

        tblcouponpromocodedaterangeContainer = { :total => count, :tblcouponpromocodedateranges => tblcouponpromocodedaterangeJson }

        return tblcouponpromocodedaterangeContainer.to_json

    end

    def self.filterData(data)

        tblcouponpromocodedateranges = []
        if(data.key?("Tblcouponpromocodedaterange"))
            filters = data['Tblcouponpromocodedaterange']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblcouponpromocodedateranges = Tblcouponpromocodedaterange.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblcouponpromocodedateranges = tblcouponpromocodedateranges & Tblcouponpromocodedaterange.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblcouponpromocodedateranges
    end

end

