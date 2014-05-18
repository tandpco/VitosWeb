require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblstoresController
    public
    def self.create(data)
        tblstores = Tblstores.create( :Address2 => data['Address2'], :CheckOK => data['CheckOK'], :City => data['City'], :CloseFri => data['CloseFri'], :CloseMon => data['CloseMon'], :CloseSat => data['CloseSat'], :CloseSun => data['CloseSun'], :CloseThu => data['CloseThu'], :CloseTue => data['CloseTue'], :CloseWed => data['CloseWed'], :DefaultDeliveryCharge => data['DefaultDeliveryCharge'], :DefaultDriverMoney => data['DefaultDriverMoney'], :DeliveryMin => data['DeliveryMin'], :DistrictID => data['DistrictID'], :DMAID => data['DMAID'], :FriendlyLocation => data['FriendlyLocation'], :Hours => data['Hours'], :IsActive => data['IsActive'], :IsDeliveryTaxable => data['IsDeliveryTaxable'], :LaborTax => data['LaborTax'], :Latitude => data['Latitude'], :Longitude => data['Longitude'], :MetaDescription => data['MetaDescription'], :NetworkIP => data['NetworkIP'], :OpenFri => data['OpenFri'], :OpenMon => data['OpenMon'], :OpenSat => data['OpenSat'], :OpenSun => data['OpenSun'], :OpenThu => data['OpenThu'], :OpenTue => data['OpenTue'], :OpenWed => data['OpenWed'], :PayrollPeriodTypeID => data['PayrollPeriodTypeID'], :PayrollReportEmail => data['PayrollReportEmail'], :PGWID => data['PGWID'], :PGWWebID => data['PGWWebID'], :PGWWebID2 => data['PGWWebID2'], :PostalCode => data['PostalCode'], :RADRAT => data['RADRAT'], :RequireDriverSwipe => data['RequireDriverSwipe'], :Serving => data['Serving'], :State => data['State'], :StoreID => data['StoreID'], :StoreName => data['StoreName'], :TaxRate => data['TaxRate'], :TaxRate2 => data['TaxRate2'], :TZOffset => data['TZOffset'], :UnemploymentVariable => data['UnemploymentVariable'], :IsActive => data['IsActive'] )

        tblstoresJson = { :id => tblstores.id, :Address2 => tblstores.Address2, :CheckOK => tblstores.CheckOK, :City => tblstores.City, :CloseFri => tblstores.CloseFri, :CloseMon => tblstores.CloseMon, :CloseSat => tblstores.CloseSat, :CloseSun => tblstores.CloseSun, :CloseThu => tblstores.CloseThu, :CloseTue => tblstores.CloseTue, :CloseWed => tblstores.CloseWed, :DefaultDeliveryCharge => tblstores.DefaultDeliveryCharge, :DefaultDriverMoney => tblstores.DefaultDriverMoney, :DeliveryMin => tblstores.DeliveryMin, :DistrictID => tblstores.DistrictID, :DMAID => tblstores.DMAID, :FriendlyLocation => tblstores.FriendlyLocation, :Hours => tblstores.Hours, :IsActive => tblstores.IsActive, :IsDeliveryTaxable => tblstores.IsDeliveryTaxable, :LaborTax => tblstores.LaborTax, :Latitude => tblstores.Latitude, :Longitude => tblstores.Longitude, :MetaDescription => tblstores.MetaDescription, :NetworkIP => tblstores.NetworkIP, :OpenFri => tblstores.OpenFri, :OpenMon => tblstores.OpenMon, :OpenSat => tblstores.OpenSat, :OpenSun => tblstores.OpenSun, :OpenThu => tblstores.OpenThu, :OpenTue => tblstores.OpenTue, :OpenWed => tblstores.OpenWed, :PayrollPeriodTypeID => tblstores.PayrollPeriodTypeID, :PayrollReportEmail => tblstores.PayrollReportEmail, :PGWID => tblstores.PGWID, :PGWWebID => tblstores.PGWWebID, :PGWWebID2 => tblstores.PGWWebID2, :PostalCode => tblstores.PostalCode, :RADRAT => tblstores.RADRAT, :RequireDriverSwipe => tblstores.RequireDriverSwipe, :Serving => tblstores.Serving, :State => tblstores.State, :StoreID => tblstores.StoreID, :StoreName => tblstores.StoreName, :TaxRate => tblstores.TaxRate, :TaxRate2 => tblstores.TaxRate2, :TZOffset => tblstores.TZOffset, :UnemploymentVariable => tblstores.UnemploymentVariable, :IsActive => tblstores.IsActive }

        return tblstoresJson.to_json
    end

    def self.read(data)
        tblstores = Tblstores.find(data['id'])

        tblstoresJson = { :id => tblstores.id, :Address2 => tblstores.Address2, :CheckOK => tblstores.CheckOK, :City => tblstores.City, :CloseFri => tblstores.CloseFri, :CloseMon => tblstores.CloseMon, :CloseSat => tblstores.CloseSat, :CloseSun => tblstores.CloseSun, :CloseThu => tblstores.CloseThu, :CloseTue => tblstores.CloseTue, :CloseWed => tblstores.CloseWed, :DefaultDeliveryCharge => tblstores.DefaultDeliveryCharge, :DefaultDriverMoney => tblstores.DefaultDriverMoney, :DeliveryMin => tblstores.DeliveryMin, :DistrictID => tblstores.DistrictID, :DMAID => tblstores.DMAID, :FriendlyLocation => tblstores.FriendlyLocation, :Hours => tblstores.Hours, :IsActive => tblstores.IsActive, :IsDeliveryTaxable => tblstores.IsDeliveryTaxable, :LaborTax => tblstores.LaborTax, :Latitude => tblstores.Latitude, :Longitude => tblstores.Longitude, :MetaDescription => tblstores.MetaDescription, :NetworkIP => tblstores.NetworkIP, :OpenFri => tblstores.OpenFri, :OpenMon => tblstores.OpenMon, :OpenSat => tblstores.OpenSat, :OpenSun => tblstores.OpenSun, :OpenThu => tblstores.OpenThu, :OpenTue => tblstores.OpenTue, :OpenWed => tblstores.OpenWed, :PayrollPeriodTypeID => tblstores.PayrollPeriodTypeID, :PayrollReportEmail => tblstores.PayrollReportEmail, :PGWID => tblstores.PGWID, :PGWWebID => tblstores.PGWWebID, :PGWWebID2 => tblstores.PGWWebID2, :PostalCode => tblstores.PostalCode, :RADRAT => tblstores.RADRAT, :RequireDriverSwipe => tblstores.RequireDriverSwipe, :Serving => tblstores.Serving, :State => tblstores.State, :StoreID => tblstores.StoreID, :StoreName => tblstores.StoreName, :TaxRate => tblstores.TaxRate, :TaxRate2 => tblstores.TaxRate2, :TZOffset => tblstores.TZOffset, :UnemploymentVariable => tblstores.UnemploymentVariable, :IsActive => tblstores.IsActive }

        return tblstoresJson.to_json

    end

    def self.update(data)
        tblstores = Tblstores.update( data['id'], :Address2 => data['Address2'], :CheckOK => data['CheckOK'], :City => data['City'], :CloseFri => data['CloseFri'], :CloseMon => data['CloseMon'], :CloseSat => data['CloseSat'], :CloseSun => data['CloseSun'], :CloseThu => data['CloseThu'], :CloseTue => data['CloseTue'], :CloseWed => data['CloseWed'], :DefaultDeliveryCharge => data['DefaultDeliveryCharge'], :DefaultDriverMoney => data['DefaultDriverMoney'], :DeliveryMin => data['DeliveryMin'], :DistrictID => data['DistrictID'], :DMAID => data['DMAID'], :FriendlyLocation => data['FriendlyLocation'], :Hours => data['Hours'], :IsActive => data['IsActive'], :IsDeliveryTaxable => data['IsDeliveryTaxable'], :LaborTax => data['LaborTax'], :Latitude => data['Latitude'], :Longitude => data['Longitude'], :MetaDescription => data['MetaDescription'], :NetworkIP => data['NetworkIP'], :OpenFri => data['OpenFri'], :OpenMon => data['OpenMon'], :OpenSat => data['OpenSat'], :OpenSun => data['OpenSun'], :OpenThu => data['OpenThu'], :OpenTue => data['OpenTue'], :OpenWed => data['OpenWed'], :PayrollPeriodTypeID => data['PayrollPeriodTypeID'], :PayrollReportEmail => data['PayrollReportEmail'], :PGWID => data['PGWID'], :PGWWebID => data['PGWWebID'], :PGWWebID2 => data['PGWWebID2'], :PostalCode => data['PostalCode'], :RADRAT => data['RADRAT'], :RequireDriverSwipe => data['RequireDriverSwipe'], :Serving => data['Serving'], :State => data['State'], :StoreID => data['StoreID'], :StoreName => data['StoreName'], :TaxRate => data['TaxRate'], :TaxRate2 => data['TaxRate2'], :TZOffset => data['TZOffset'], :UnemploymentVariable => data['UnemploymentVariable'], :IsActive => data['IsActive'] )

        tblstoresJson = { :status => status, :id => tblstores.id, :Address2 => tblstores.Address2, :CheckOK => tblstores.CheckOK, :City => tblstores.City, :CloseFri => tblstores.CloseFri, :CloseMon => tblstores.CloseMon, :CloseSat => tblstores.CloseSat, :CloseSun => tblstores.CloseSun, :CloseThu => tblstores.CloseThu, :CloseTue => tblstores.CloseTue, :CloseWed => tblstores.CloseWed, :DefaultDeliveryCharge => tblstores.DefaultDeliveryCharge, :DefaultDriverMoney => tblstores.DefaultDriverMoney, :DeliveryMin => tblstores.DeliveryMin, :DistrictID => tblstores.DistrictID, :DMAID => tblstores.DMAID, :FriendlyLocation => tblstores.FriendlyLocation, :Hours => tblstores.Hours, :IsActive => tblstores.IsActive, :IsDeliveryTaxable => tblstores.IsDeliveryTaxable, :LaborTax => tblstores.LaborTax, :Latitude => tblstores.Latitude, :Longitude => tblstores.Longitude, :MetaDescription => tblstores.MetaDescription, :NetworkIP => tblstores.NetworkIP, :OpenFri => tblstores.OpenFri, :OpenMon => tblstores.OpenMon, :OpenSat => tblstores.OpenSat, :OpenSun => tblstores.OpenSun, :OpenThu => tblstores.OpenThu, :OpenTue => tblstores.OpenTue, :OpenWed => tblstores.OpenWed, :PayrollPeriodTypeID => tblstores.PayrollPeriodTypeID, :PayrollReportEmail => tblstores.PayrollReportEmail, :PGWID => tblstores.PGWID, :PGWWebID => tblstores.PGWWebID, :PGWWebID2 => tblstores.PGWWebID2, :PostalCode => tblstores.PostalCode, :RADRAT => tblstores.RADRAT, :RequireDriverSwipe => tblstores.RequireDriverSwipe, :Serving => tblstores.Serving, :State => tblstores.State, :StoreID => tblstores.StoreID, :StoreName => tblstores.StoreName, :TaxRate => tblstores.TaxRate, :TaxRate2 => tblstores.TaxRate2, :TZOffset => tblstores.TZOffset, :UnemploymentVariable => tblstores.UnemploymentVariable, :IsActive => tblstores.IsActive }

        return tblstoresJson.to_json

    end

    def self.delete(data)
        tblstores = Tblstores.find(data['id'])
        tblstores.destroy

        tblstoresJson = { :id => tblstores.id, :Address2 => tblstores.Address2, :CheckOK => tblstores.CheckOK, :City => tblstores.City, :CloseFri => tblstores.CloseFri, :CloseMon => tblstores.CloseMon, :CloseSat => tblstores.CloseSat, :CloseSun => tblstores.CloseSun, :CloseThu => tblstores.CloseThu, :CloseTue => tblstores.CloseTue, :CloseWed => tblstores.CloseWed, :DefaultDeliveryCharge => tblstores.DefaultDeliveryCharge, :DefaultDriverMoney => tblstores.DefaultDriverMoney, :DeliveryMin => tblstores.DeliveryMin, :DistrictID => tblstores.DistrictID, :DMAID => tblstores.DMAID, :FriendlyLocation => tblstores.FriendlyLocation, :Hours => tblstores.Hours, :IsActive => tblstores.IsActive, :IsDeliveryTaxable => tblstores.IsDeliveryTaxable, :LaborTax => tblstores.LaborTax, :Latitude => tblstores.Latitude, :Longitude => tblstores.Longitude, :MetaDescription => tblstores.MetaDescription, :NetworkIP => tblstores.NetworkIP, :OpenFri => tblstores.OpenFri, :OpenMon => tblstores.OpenMon, :OpenSat => tblstores.OpenSat, :OpenSun => tblstores.OpenSun, :OpenThu => tblstores.OpenThu, :OpenTue => tblstores.OpenTue, :OpenWed => tblstores.OpenWed, :PayrollPeriodTypeID => tblstores.PayrollPeriodTypeID, :PayrollReportEmail => tblstores.PayrollReportEmail, :PGWID => tblstores.PGWID, :PGWWebID => tblstores.PGWWebID, :PGWWebID2 => tblstores.PGWWebID2, :PostalCode => tblstores.PostalCode, :RADRAT => tblstores.RADRAT, :RequireDriverSwipe => tblstores.RequireDriverSwipe, :Serving => tblstores.Serving, :State => tblstores.State, :StoreID => tblstores.StoreID, :StoreName => tblstores.StoreName, :TaxRate => tblstores.TaxRate, :TaxRate2 => tblstores.TaxRate2, :TZOffset => tblstores.TZOffset, :UnemploymentVariable => tblstores.UnemploymentVariable, :IsActive => tblstores.IsActive }

        return tblstoresJson.to_json

    end

    def self.list(data)
        tblstores = Tblstores.all

        Array tblstoresJson = Array.new
        tblstores.each do |tblstores|
            tblstoresJson.push({ :id => tblstores.id, :Address2 => tblstores.Address2, :CheckOK => tblstores.CheckOK, :City => tblstores.City, :CloseFri => tblstores.CloseFri, :CloseMon => tblstores.CloseMon, :CloseSat => tblstores.CloseSat, :CloseSun => tblstores.CloseSun, :CloseThu => tblstores.CloseThu, :CloseTue => tblstores.CloseTue, :CloseWed => tblstores.CloseWed, :DefaultDeliveryCharge => tblstores.DefaultDeliveryCharge, :DefaultDriverMoney => tblstores.DefaultDriverMoney, :DeliveryMin => tblstores.DeliveryMin, :DistrictID => tblstores.DistrictID, :DMAID => tblstores.DMAID, :FriendlyLocation => tblstores.FriendlyLocation, :Hours => tblstores.Hours, :IsActive => tblstores.IsActive, :IsDeliveryTaxable => tblstores.IsDeliveryTaxable, :LaborTax => tblstores.LaborTax, :Latitude => tblstores.Latitude, :Longitude => tblstores.Longitude, :MetaDescription => tblstores.MetaDescription, :NetworkIP => tblstores.NetworkIP, :OpenFri => tblstores.OpenFri, :OpenMon => tblstores.OpenMon, :OpenSat => tblstores.OpenSat, :OpenSun => tblstores.OpenSun, :OpenThu => tblstores.OpenThu, :OpenTue => tblstores.OpenTue, :OpenWed => tblstores.OpenWed, :PayrollPeriodTypeID => tblstores.PayrollPeriodTypeID, :PayrollReportEmail => tblstores.PayrollReportEmail, :PGWID => tblstores.PGWID, :PGWWebID => tblstores.PGWWebID, :PGWWebID2 => tblstores.PGWWebID2, :PostalCode => tblstores.PostalCode, :RADRAT => tblstores.RADRAT, :RequireDriverSwipe => tblstores.RequireDriverSwipe, :Serving => tblstores.Serving, :State => tblstores.State, :StoreID => tblstores.StoreID, :StoreName => tblstores.StoreName, :TaxRate => tblstores.TaxRate, :TaxRate2 => tblstores.TaxRate2, :TZOffset => tblstores.TZOffset, :UnemploymentVariable => tblstores.UnemploymentVariable, :IsActive => tblstores.IsActive })
        end

        return tblstoresJson.to_json

    end

    def self.filter(data)
        tblstores = self.filterData(data)

        count = tblstores.length

        page  = data['Tblstores']['pagination']['page'].to_i
        limit = data['Tblstores']['pagination']['limit'].to_i
 
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
        tblstores = tblstores.slice(offset, limit)

        Array tblstoresJson = Array.new
        tblstores.each do |tblstores|
            tblstoresJson.push({ :id => tblstores.id, :Address2 => tblstores.Address2, :CheckOK => tblstores.CheckOK, :City => tblstores.City, :CloseFri => tblstores.CloseFri, :CloseMon => tblstores.CloseMon, :CloseSat => tblstores.CloseSat, :CloseSun => tblstores.CloseSun, :CloseThu => tblstores.CloseThu, :CloseTue => tblstores.CloseTue, :CloseWed => tblstores.CloseWed, :DefaultDeliveryCharge => tblstores.DefaultDeliveryCharge, :DefaultDriverMoney => tblstores.DefaultDriverMoney, :DeliveryMin => tblstores.DeliveryMin, :DistrictID => tblstores.DistrictID, :DMAID => tblstores.DMAID, :FriendlyLocation => tblstores.FriendlyLocation, :Hours => tblstores.Hours, :IsActive => tblstores.IsActive, :IsDeliveryTaxable => tblstores.IsDeliveryTaxable, :LaborTax => tblstores.LaborTax, :Latitude => tblstores.Latitude, :Longitude => tblstores.Longitude, :MetaDescription => tblstores.MetaDescription, :NetworkIP => tblstores.NetworkIP, :OpenFri => tblstores.OpenFri, :OpenMon => tblstores.OpenMon, :OpenSat => tblstores.OpenSat, :OpenSun => tblstores.OpenSun, :OpenThu => tblstores.OpenThu, :OpenTue => tblstores.OpenTue, :OpenWed => tblstores.OpenWed, :PayrollPeriodTypeID => tblstores.PayrollPeriodTypeID, :PayrollReportEmail => tblstores.PayrollReportEmail, :PGWID => tblstores.PGWID, :PGWWebID => tblstores.PGWWebID, :PGWWebID2 => tblstores.PGWWebID2, :PostalCode => tblstores.PostalCode, :RADRAT => tblstores.RADRAT, :RequireDriverSwipe => tblstores.RequireDriverSwipe, :Serving => tblstores.Serving, :State => tblstores.State, :StoreID => tblstores.StoreID, :StoreName => tblstores.StoreName, :TaxRate => tblstores.TaxRate, :TaxRate2 => tblstores.TaxRate2, :TZOffset => tblstores.TZOffset, :UnemploymentVariable => tblstores.UnemploymentVariable, :IsActive => tblstores.IsActive })
        end

        tblstoresContainer = { :total => count, :tblstores => tblstoresJson }

        return tblstoresContainer.to_json

    end

    def self.filterData(data)

        tblstores = []
        if(data.key?("Tblstores"))
            filters = data['Tblstores']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblstores = Tblstores.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblstores = tblstores & Tblstores.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblstores
    end

end

