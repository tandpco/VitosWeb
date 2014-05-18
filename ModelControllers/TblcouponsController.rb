require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblcouponsController
    public
    def self.create(data)
        tblcoupons = Tblcoupons.create( :CouponTypeID => data['CouponTypeID'], :Description => data['Description'], :DollarOff => data['DollarOff'], :IsFree => data['IsFree'], :MinimumPurchase => data['MinimumPurchase'], :PercentageOff => data['PercentageOff'], :RADRAT => data['RADRAT'], :ShortDescription => data['ShortDescription'], :ShowOnWeb => data['ShowOnWeb'], :ValidForDelivery => data['ValidForDelivery'], :ValidForDineIn => data['ValidForDineIn'], :ValidForInternetOrder => data['ValidForInternetOrder'], :ValidForPickup => data['ValidForPickup'], :ValidForTelephoneOrder => data['ValidForTelephoneOrder'], :ValidForWalkInOrder => data['ValidForWalkInOrder'], :CouponID => data['CouponID'] )

        tblcouponsJson = { :id => tblcoupons.id, :CouponTypeID => tblcoupons.CouponTypeID, :Description => tblcoupons.Description, :DollarOff => tblcoupons.DollarOff, :IsFree => tblcoupons.IsFree, :MinimumPurchase => tblcoupons.MinimumPurchase, :PercentageOff => tblcoupons.PercentageOff, :RADRAT => tblcoupons.RADRAT, :ShortDescription => tblcoupons.ShortDescription, :ShowOnWeb => tblcoupons.ShowOnWeb, :ValidForDelivery => tblcoupons.ValidForDelivery, :ValidForDineIn => tblcoupons.ValidForDineIn, :ValidForInternetOrder => tblcoupons.ValidForInternetOrder, :ValidForPickup => tblcoupons.ValidForPickup, :ValidForTelephoneOrder => tblcoupons.ValidForTelephoneOrder, :ValidForWalkInOrder => tblcoupons.ValidForWalkInOrder, :CouponID => tblcoupons.CouponID }

        return tblcouponsJson.to_json
    end

    def self.read(data)
        tblcoupons = Tblcoupons.find(data['id'])

        tblcouponsJson = { :id => tblcoupons.id, :CouponTypeID => tblcoupons.CouponTypeID, :Description => tblcoupons.Description, :DollarOff => tblcoupons.DollarOff, :IsFree => tblcoupons.IsFree, :MinimumPurchase => tblcoupons.MinimumPurchase, :PercentageOff => tblcoupons.PercentageOff, :RADRAT => tblcoupons.RADRAT, :ShortDescription => tblcoupons.ShortDescription, :ShowOnWeb => tblcoupons.ShowOnWeb, :ValidForDelivery => tblcoupons.ValidForDelivery, :ValidForDineIn => tblcoupons.ValidForDineIn, :ValidForInternetOrder => tblcoupons.ValidForInternetOrder, :ValidForPickup => tblcoupons.ValidForPickup, :ValidForTelephoneOrder => tblcoupons.ValidForTelephoneOrder, :ValidForWalkInOrder => tblcoupons.ValidForWalkInOrder, :CouponID => tblcoupons.CouponID }

        return tblcouponsJson.to_json

    end

    def self.update(data)
        tblcoupons = Tblcoupons.update( data['id'], :CouponTypeID => data['CouponTypeID'], :Description => data['Description'], :DollarOff => data['DollarOff'], :IsFree => data['IsFree'], :MinimumPurchase => data['MinimumPurchase'], :PercentageOff => data['PercentageOff'], :RADRAT => data['RADRAT'], :ShortDescription => data['ShortDescription'], :ShowOnWeb => data['ShowOnWeb'], :ValidForDelivery => data['ValidForDelivery'], :ValidForDineIn => data['ValidForDineIn'], :ValidForInternetOrder => data['ValidForInternetOrder'], :ValidForPickup => data['ValidForPickup'], :ValidForTelephoneOrder => data['ValidForTelephoneOrder'], :ValidForWalkInOrder => data['ValidForWalkInOrder'], :CouponID => data['CouponID'] )

        tblcouponsJson = { :status => status, :id => tblcoupons.id, :CouponTypeID => tblcoupons.CouponTypeID, :Description => tblcoupons.Description, :DollarOff => tblcoupons.DollarOff, :IsFree => tblcoupons.IsFree, :MinimumPurchase => tblcoupons.MinimumPurchase, :PercentageOff => tblcoupons.PercentageOff, :RADRAT => tblcoupons.RADRAT, :ShortDescription => tblcoupons.ShortDescription, :ShowOnWeb => tblcoupons.ShowOnWeb, :ValidForDelivery => tblcoupons.ValidForDelivery, :ValidForDineIn => tblcoupons.ValidForDineIn, :ValidForInternetOrder => tblcoupons.ValidForInternetOrder, :ValidForPickup => tblcoupons.ValidForPickup, :ValidForTelephoneOrder => tblcoupons.ValidForTelephoneOrder, :ValidForWalkInOrder => tblcoupons.ValidForWalkInOrder, :CouponID => tblcoupons.CouponID }

        return tblcouponsJson.to_json

    end

    def self.delete(data)
        tblcoupons = Tblcoupons.find(data['id'])
        tblcoupons.destroy

        tblcouponsJson = { :id => tblcoupons.id, :CouponTypeID => tblcoupons.CouponTypeID, :Description => tblcoupons.Description, :DollarOff => tblcoupons.DollarOff, :IsFree => tblcoupons.IsFree, :MinimumPurchase => tblcoupons.MinimumPurchase, :PercentageOff => tblcoupons.PercentageOff, :RADRAT => tblcoupons.RADRAT, :ShortDescription => tblcoupons.ShortDescription, :ShowOnWeb => tblcoupons.ShowOnWeb, :ValidForDelivery => tblcoupons.ValidForDelivery, :ValidForDineIn => tblcoupons.ValidForDineIn, :ValidForInternetOrder => tblcoupons.ValidForInternetOrder, :ValidForPickup => tblcoupons.ValidForPickup, :ValidForTelephoneOrder => tblcoupons.ValidForTelephoneOrder, :ValidForWalkInOrder => tblcoupons.ValidForWalkInOrder, :CouponID => tblcoupons.CouponID }

        return tblcouponsJson.to_json

    end

    def self.list(data)
        tblcoupons = Tblcoupons.all

        Array tblcouponsJson = Array.new
        tblcoupons.each do |tblcoupons|
            tblcouponsJson.push({ :id => tblcoupons.id, :CouponTypeID => tblcoupons.CouponTypeID, :Description => tblcoupons.Description, :DollarOff => tblcoupons.DollarOff, :IsFree => tblcoupons.IsFree, :MinimumPurchase => tblcoupons.MinimumPurchase, :PercentageOff => tblcoupons.PercentageOff, :RADRAT => tblcoupons.RADRAT, :ShortDescription => tblcoupons.ShortDescription, :ShowOnWeb => tblcoupons.ShowOnWeb, :ValidForDelivery => tblcoupons.ValidForDelivery, :ValidForDineIn => tblcoupons.ValidForDineIn, :ValidForInternetOrder => tblcoupons.ValidForInternetOrder, :ValidForPickup => tblcoupons.ValidForPickup, :ValidForTelephoneOrder => tblcoupons.ValidForTelephoneOrder, :ValidForWalkInOrder => tblcoupons.ValidForWalkInOrder, :CouponID => tblcoupons.CouponID })
        end

        return tblcouponsJson.to_json

    end

    def self.filter(data)
        tblcoupons = self.filterData(data)

        count = tblcoupons.length

        page  = data['Tblcoupons']['pagination']['page'].to_i
        limit = data['Tblcoupons']['pagination']['limit'].to_i
 
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
        tblcoupons = tblcoupons.slice(offset, limit)

        Array tblcouponsJson = Array.new
        tblcoupons.each do |tblcoupons|
            tblcouponsJson.push({ :id => tblcoupons.id, :CouponTypeID => tblcoupons.CouponTypeID, :Description => tblcoupons.Description, :DollarOff => tblcoupons.DollarOff, :IsFree => tblcoupons.IsFree, :MinimumPurchase => tblcoupons.MinimumPurchase, :PercentageOff => tblcoupons.PercentageOff, :RADRAT => tblcoupons.RADRAT, :ShortDescription => tblcoupons.ShortDescription, :ShowOnWeb => tblcoupons.ShowOnWeb, :ValidForDelivery => tblcoupons.ValidForDelivery, :ValidForDineIn => tblcoupons.ValidForDineIn, :ValidForInternetOrder => tblcoupons.ValidForInternetOrder, :ValidForPickup => tblcoupons.ValidForPickup, :ValidForTelephoneOrder => tblcoupons.ValidForTelephoneOrder, :ValidForWalkInOrder => tblcoupons.ValidForWalkInOrder, :CouponID => tblcoupons.CouponID })
        end

        tblcouponsContainer = { :total => count, :tblcoupons => tblcouponsJson }

        return tblcouponsContainer.to_json

    end

    def self.filterData(data)

        tblcoupons = []
        if(data.key?("Tblcoupons"))
            filters = data['Tblcoupons']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblcoupons = Tblcoupons.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblcoupons = tblcoupons & Tblcoupons.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblcoupons
    end

end

