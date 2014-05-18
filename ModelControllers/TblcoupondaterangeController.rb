require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblcoupondaterangeController
    public
    def self.create(data)
        tblcoupondaterange = Tblcoupondaterange.create( :CouponID => data['CouponID'], :RADRAT => data['RADRAT'], :ValidFrom => data['ValidFrom'], :ValidTo => data['ValidTo'], :PromoCode => data['PromoCode'] )

        tblcoupondaterangeJson = { :id => tblcoupondaterange.id, :CouponID => tblcoupondaterange.CouponID, :RADRAT => tblcoupondaterange.RADRAT, :ValidFrom => tblcoupondaterange.ValidFrom, :ValidTo => tblcoupondaterange.ValidTo, :PromoCode => tblcoupondaterange.PromoCode }

        return tblcoupondaterangeJson.to_json
    end

    def self.read(data)
        tblcoupondaterange = Tblcoupondaterange.find(data['id'])

        tblcoupondaterangeJson = { :id => tblcoupondaterange.id, :CouponID => tblcoupondaterange.CouponID, :RADRAT => tblcoupondaterange.RADRAT, :ValidFrom => tblcoupondaterange.ValidFrom, :ValidTo => tblcoupondaterange.ValidTo, :PromoCode => tblcoupondaterange.PromoCode }

        return tblcoupondaterangeJson.to_json

    end

    def self.update(data)
        tblcoupondaterange = Tblcoupondaterange.update( data['id'], :CouponID => data['CouponID'], :RADRAT => data['RADRAT'], :ValidFrom => data['ValidFrom'], :ValidTo => data['ValidTo'], :PromoCode => data['PromoCode'] )

        tblcoupondaterangeJson = { :id => tblcoupondaterange.id, :CouponID => tblcoupondaterange.CouponID, :RADRAT => tblcoupondaterange.RADRAT, :ValidFrom => tblcoupondaterange.ValidFrom, :ValidTo => tblcoupondaterange.ValidTo, :PromoCode => tblcoupondaterange.PromoCode }

        return tblcoupondaterangeJson.to_json

    end

    def self.delete(data)
        tblcoupondaterange = Tblcoupondaterange.find(data['id'])
        tblcoupondaterange.destroy

        tblcoupondaterangeJson = { :id => tblcoupondaterange.id, :CouponID => tblcoupondaterange.CouponID, :RADRAT => tblcoupondaterange.RADRAT, :ValidFrom => tblcoupondaterange.ValidFrom, :ValidTo => tblcoupondaterange.ValidTo, :PromoCode => tblcoupondaterange.PromoCode }

        return tblcoupondaterangeJson.to_json

    end

    def self.list(data)
        tblcoupondateranges = Tblcoupondaterange.all

        Array tblcoupondaterangeJson = Array.new
        tblcoupondateranges.each do |tblcoupondaterange|
            tblcoupondaterangeJson.push({ :id => tblcoupondaterange.id, :CouponID => tblcoupondaterange.CouponID, :RADRAT => tblcoupondaterange.RADRAT, :ValidFrom => tblcoupondaterange.ValidFrom, :ValidTo => tblcoupondaterange.ValidTo, :PromoCode => tblcoupondaterange.PromoCode })
        end

        return tblcoupondaterangeJson.to_json

    end

    def self.filter(data)
        tblcoupondateranges = self.filterData(data)

        count = tblcoupondateranges.length

        page  = data['Tblcoupondaterange']['pagination']['page'].to_i
        limit = data['Tblcoupondaterange']['pagination']['limit'].to_i
 
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
        tblcoupondateranges = tblcoupondateranges.slice(offset, limit)

        Array tblcoupondaterangeJson = Array.new
        tblcoupondateranges.each do |tblcoupondaterange|
            tblcoupondaterangeJson.push({ :id => tblcoupondaterange.id, :CouponID => tblcoupondaterange.CouponID, :RADRAT => tblcoupondaterange.RADRAT, :ValidFrom => tblcoupondaterange.ValidFrom, :ValidTo => tblcoupondaterange.ValidTo, :PromoCode => tblcoupondaterange.PromoCode })
        end

        tblcoupondaterangeContainer = { :total => count, :tblcoupondateranges => tblcoupondaterangeJson }

        return tblcoupondaterangeContainer.to_json

    end

    def self.filterData(data)

        tblcoupondateranges = []
        if(data.key?("Tblcoupondaterange"))
            filters = data['Tblcoupondaterange']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblcoupondateranges = Tblcoupondaterange.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblcoupondateranges = tblcoupondateranges & Tblcoupondaterange.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblcoupondateranges
    end

end

