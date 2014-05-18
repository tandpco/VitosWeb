require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblcouponspromocodesController
    public
    def self.create(data)
        tblcouponspromocodes = Tblcouponspromocodes.create( :IsMassMailer => data['IsMassMailer'], :MaxUses => data['MaxUses'], :PromoCode => data['PromoCode'], :RADRAT => data['RADRAT'], :Uses => data['Uses'], :Birthdate => data['Birthdate'] )

        tblcouponspromocodesJson = { :id => tblcouponspromocodes.id, :IsMassMailer => tblcouponspromocodes.IsMassMailer, :MaxUses => tblcouponspromocodes.MaxUses, :PromoCode => tblcouponspromocodes.PromoCode, :RADRAT => tblcouponspromocodes.RADRAT, :Uses => tblcouponspromocodes.Uses, :Birthdate => tblcouponspromocodes.Birthdate }

        return tblcouponspromocodesJson.to_json
    end

    def self.read(data)
        tblcouponspromocodes = Tblcouponspromocodes.find(data['id'])

        tblcouponspromocodesJson = { :id => tblcouponspromocodes.id, :IsMassMailer => tblcouponspromocodes.IsMassMailer, :MaxUses => tblcouponspromocodes.MaxUses, :PromoCode => tblcouponspromocodes.PromoCode, :RADRAT => tblcouponspromocodes.RADRAT, :Uses => tblcouponspromocodes.Uses, :Birthdate => tblcouponspromocodes.Birthdate }

        return tblcouponspromocodesJson.to_json

    end

    def self.update(data)
        tblcouponspromocodes = Tblcouponspromocodes.update( data['id'], :IsMassMailer => data['IsMassMailer'], :MaxUses => data['MaxUses'], :PromoCode => data['PromoCode'], :RADRAT => data['RADRAT'], :Uses => data['Uses'], :Birthdate => data['Birthdate'] )

        tblcouponspromocodesJson = { :id => tblcouponspromocodes.id, :IsMassMailer => tblcouponspromocodes.IsMassMailer, :MaxUses => tblcouponspromocodes.MaxUses, :PromoCode => tblcouponspromocodes.PromoCode, :RADRAT => tblcouponspromocodes.RADRAT, :Uses => tblcouponspromocodes.Uses, :Birthdate => tblcouponspromocodes.Birthdate }

        return tblcouponspromocodesJson.to_json

    end

    def self.delete(data)
        tblcouponspromocodes = Tblcouponspromocodes.find(data['id'])
        tblcouponspromocodes.destroy

        tblcouponspromocodesJson = { :id => tblcouponspromocodes.id, :IsMassMailer => tblcouponspromocodes.IsMassMailer, :MaxUses => tblcouponspromocodes.MaxUses, :PromoCode => tblcouponspromocodes.PromoCode, :RADRAT => tblcouponspromocodes.RADRAT, :Uses => tblcouponspromocodes.Uses, :Birthdate => tblcouponspromocodes.Birthdate }

        return tblcouponspromocodesJson.to_json

    end

    def self.list(data)
        tblcouponspromocodes = Tblcouponspromocodes.all

        Array tblcouponspromocodesJson = Array.new
        tblcouponspromocodes.each do |tblcouponspromocodes|
            tblcouponspromocodesJson.push({ :id => tblcouponspromocodes.id, :IsMassMailer => tblcouponspromocodes.IsMassMailer, :MaxUses => tblcouponspromocodes.MaxUses, :PromoCode => tblcouponspromocodes.PromoCode, :RADRAT => tblcouponspromocodes.RADRAT, :Uses => tblcouponspromocodes.Uses, :Birthdate => tblcouponspromocodes.Birthdate })
        end

        return tblcouponspromocodesJson.to_json

    end

    def self.filter(data)
        tblcouponspromocodes = self.filterData(data)

        count = tblcouponspromocodes.length

        page  = data['Tblcouponspromocodes']['pagination']['page'].to_i
        limit = data['Tblcouponspromocodes']['pagination']['limit'].to_i
 
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
        tblcouponspromocodes = tblcouponspromocodes.slice(offset, limit)

        Array tblcouponspromocodesJson = Array.new
        tblcouponspromocodes.each do |tblcouponspromocodes|
            tblcouponspromocodesJson.push({ :id => tblcouponspromocodes.id, :IsMassMailer => tblcouponspromocodes.IsMassMailer, :MaxUses => tblcouponspromocodes.MaxUses, :PromoCode => tblcouponspromocodes.PromoCode, :RADRAT => tblcouponspromocodes.RADRAT, :Uses => tblcouponspromocodes.Uses, :Birthdate => tblcouponspromocodes.Birthdate })
        end

        tblcouponspromocodesContainer = { :total => count, :tblcouponspromocodes => tblcouponspromocodesJson }

        return tblcouponspromocodesContainer.to_json

    end

    def self.filterData(data)

        tblcouponspromocodes = []
        if(data.key?("Tblcouponspromocodes"))
            filters = data['Tblcouponspromocodes']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblcouponspromocodes = Tblcouponspromocodes.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblcouponspromocodes = tblcouponspromocodes & Tblcouponspromocodes.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblcouponspromocodes
    end

end

