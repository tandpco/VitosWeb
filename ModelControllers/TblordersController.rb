require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblordersController
    public
    def self.create(data)
        tblorders = Tblorders.create( :AddressID => data['AddressID'], :CustomerID => data['CustomerID'], :CustomerName => data['CustomerName'], :CustomerPhone => data['CustomerPhone'], :DailySequence => data['DailySequence'], :DeliveryCharge => data['DeliveryCharge'], :DriverMoney => data['DriverMoney'], :EditEmpID => data['EditEmpID'], :EditReason => data['EditReason'], :EmpID => data['EmpID'], :ExpectedDate => data['ExpectedDate'], :IPAddress => data['IPAddress'], :IsPaid => data['IsPaid'], :OrderID => data['OrderID'], :OrderNotes => data['OrderNotes'], :OrderStatusID => data['OrderStatusID'], :OrderTypeID => data['OrderTypeID'], :PaidDate => data['PaidDate'], :PaymentAuthorization => data['PaymentAuthorization'], :PaymentEmpID => data['PaymentEmpID'], :PaymentReference => data['PaymentReference'], :PaymentTypeID => data['PaymentTypeID'], :RADRAT => data['RADRAT'], :RefID => data['RefID'], :ReleaseDate => data['ReleaseDate'], :SessionID => data['SessionID'], :StoreID => data['StoreID'], :SubmitDate => data['SubmitDate'], :Tax => data['Tax'], :Tax2 => data['Tax2'], :Tip => data['Tip'], :TransactionDate => data['TransactionDate'], :VoidDate => data['VoidDate'], :VoidEmpID => data['VoidEmpID'], :VoidReason => data['VoidReason'], :IsActive => data['IsActive'] )

        tblordersJson = { :id => tblorders.id, :AddressID => tblorders.AddressID, :CustomerID => tblorders.CustomerID, :CustomerName => tblorders.CustomerName, :CustomerPhone => tblorders.CustomerPhone, :DailySequence => tblorders.DailySequence, :DeliveryCharge => tblorders.DeliveryCharge, :DriverMoney => tblorders.DriverMoney, :EditEmpID => tblorders.EditEmpID, :EditReason => tblorders.EditReason, :EmpID => tblorders.EmpID, :ExpectedDate => tblorders.ExpectedDate, :IPAddress => tblorders.IPAddress, :IsPaid => tblorders.IsPaid, :OrderID => tblorders.OrderID, :OrderNotes => tblorders.OrderNotes, :OrderStatusID => tblorders.OrderStatusID, :OrderTypeID => tblorders.OrderTypeID, :PaidDate => tblorders.PaidDate, :PaymentAuthorization => tblorders.PaymentAuthorization, :PaymentEmpID => tblorders.PaymentEmpID, :PaymentReference => tblorders.PaymentReference, :PaymentTypeID => tblorders.PaymentTypeID, :RADRAT => tblorders.RADRAT, :RefID => tblorders.RefID, :ReleaseDate => tblorders.ReleaseDate, :SessionID => tblorders.SessionID, :StoreID => tblorders.StoreID, :SubmitDate => tblorders.SubmitDate, :Tax => tblorders.Tax, :Tax2 => tblorders.Tax2, :Tip => tblorders.Tip, :TransactionDate => tblorders.TransactionDate, :VoidDate => tblorders.VoidDate, :VoidEmpID => tblorders.VoidEmpID, :VoidReason => tblorders.VoidReason, :IsActive => tblorders.IsActive }

        return tblordersJson.to_json
    end

    def self.read(data)
        tblorders = Tblorders.find(data['id'])

        tblordersJson = { :id => tblorders.id, :AddressID => tblorders.AddressID, :CustomerID => tblorders.CustomerID, :CustomerName => tblorders.CustomerName, :CustomerPhone => tblorders.CustomerPhone, :DailySequence => tblorders.DailySequence, :DeliveryCharge => tblorders.DeliveryCharge, :DriverMoney => tblorders.DriverMoney, :EditEmpID => tblorders.EditEmpID, :EditReason => tblorders.EditReason, :EmpID => tblorders.EmpID, :ExpectedDate => tblorders.ExpectedDate, :IPAddress => tblorders.IPAddress, :IsPaid => tblorders.IsPaid, :OrderID => tblorders.OrderID, :OrderNotes => tblorders.OrderNotes, :OrderStatusID => tblorders.OrderStatusID, :OrderTypeID => tblorders.OrderTypeID, :PaidDate => tblorders.PaidDate, :PaymentAuthorization => tblorders.PaymentAuthorization, :PaymentEmpID => tblorders.PaymentEmpID, :PaymentReference => tblorders.PaymentReference, :PaymentTypeID => tblorders.PaymentTypeID, :RADRAT => tblorders.RADRAT, :RefID => tblorders.RefID, :ReleaseDate => tblorders.ReleaseDate, :SessionID => tblorders.SessionID, :StoreID => tblorders.StoreID, :SubmitDate => tblorders.SubmitDate, :Tax => tblorders.Tax, :Tax2 => tblorders.Tax2, :Tip => tblorders.Tip, :TransactionDate => tblorders.TransactionDate, :VoidDate => tblorders.VoidDate, :VoidEmpID => tblorders.VoidEmpID, :VoidReason => tblorders.VoidReason, :IsActive => tblorders.IsActive }

        return tblordersJson.to_json

    end

    def self.update(data)
        tblorders = Tblorders.update( data['id'], :AddressID => data['AddressID'], :CustomerID => data['CustomerID'], :CustomerName => data['CustomerName'], :CustomerPhone => data['CustomerPhone'], :DailySequence => data['DailySequence'], :DeliveryCharge => data['DeliveryCharge'], :DriverMoney => data['DriverMoney'], :EditEmpID => data['EditEmpID'], :EditReason => data['EditReason'], :EmpID => data['EmpID'], :ExpectedDate => data['ExpectedDate'], :IPAddress => data['IPAddress'], :IsPaid => data['IsPaid'], :OrderID => data['OrderID'], :OrderNotes => data['OrderNotes'], :OrderStatusID => data['OrderStatusID'], :OrderTypeID => data['OrderTypeID'], :PaidDate => data['PaidDate'], :PaymentAuthorization => data['PaymentAuthorization'], :PaymentEmpID => data['PaymentEmpID'], :PaymentReference => data['PaymentReference'], :PaymentTypeID => data['PaymentTypeID'], :RADRAT => data['RADRAT'], :RefID => data['RefID'], :ReleaseDate => data['ReleaseDate'], :SessionID => data['SessionID'], :StoreID => data['StoreID'], :SubmitDate => data['SubmitDate'], :Tax => data['Tax'], :Tax2 => data['Tax2'], :Tip => data['Tip'], :TransactionDate => data['TransactionDate'], :VoidDate => data['VoidDate'], :VoidEmpID => data['VoidEmpID'], :VoidReason => data['VoidReason'], :IsActive => data['IsActive'] )

        tblordersJson = { :status => status, :id => tblorders.id, :AddressID => tblorders.AddressID, :CustomerID => tblorders.CustomerID, :CustomerName => tblorders.CustomerName, :CustomerPhone => tblorders.CustomerPhone, :DailySequence => tblorders.DailySequence, :DeliveryCharge => tblorders.DeliveryCharge, :DriverMoney => tblorders.DriverMoney, :EditEmpID => tblorders.EditEmpID, :EditReason => tblorders.EditReason, :EmpID => tblorders.EmpID, :ExpectedDate => tblorders.ExpectedDate, :IPAddress => tblorders.IPAddress, :IsPaid => tblorders.IsPaid, :OrderID => tblorders.OrderID, :OrderNotes => tblorders.OrderNotes, :OrderStatusID => tblorders.OrderStatusID, :OrderTypeID => tblorders.OrderTypeID, :PaidDate => tblorders.PaidDate, :PaymentAuthorization => tblorders.PaymentAuthorization, :PaymentEmpID => tblorders.PaymentEmpID, :PaymentReference => tblorders.PaymentReference, :PaymentTypeID => tblorders.PaymentTypeID, :RADRAT => tblorders.RADRAT, :RefID => tblorders.RefID, :ReleaseDate => tblorders.ReleaseDate, :SessionID => tblorders.SessionID, :StoreID => tblorders.StoreID, :SubmitDate => tblorders.SubmitDate, :Tax => tblorders.Tax, :Tax2 => tblorders.Tax2, :Tip => tblorders.Tip, :TransactionDate => tblorders.TransactionDate, :VoidDate => tblorders.VoidDate, :VoidEmpID => tblorders.VoidEmpID, :VoidReason => tblorders.VoidReason, :IsActive => tblorders.IsActive }

        return tblordersJson.to_json

    end

    def self.delete(data)
        tblorders = Tblorders.find(data['id'])
        tblorders.destroy

        tblordersJson = { :id => tblorders.id, :AddressID => tblorders.AddressID, :CustomerID => tblorders.CustomerID, :CustomerName => tblorders.CustomerName, :CustomerPhone => tblorders.CustomerPhone, :DailySequence => tblorders.DailySequence, :DeliveryCharge => tblorders.DeliveryCharge, :DriverMoney => tblorders.DriverMoney, :EditEmpID => tblorders.EditEmpID, :EditReason => tblorders.EditReason, :EmpID => tblorders.EmpID, :ExpectedDate => tblorders.ExpectedDate, :IPAddress => tblorders.IPAddress, :IsPaid => tblorders.IsPaid, :OrderID => tblorders.OrderID, :OrderNotes => tblorders.OrderNotes, :OrderStatusID => tblorders.OrderStatusID, :OrderTypeID => tblorders.OrderTypeID, :PaidDate => tblorders.PaidDate, :PaymentAuthorization => tblorders.PaymentAuthorization, :PaymentEmpID => tblorders.PaymentEmpID, :PaymentReference => tblorders.PaymentReference, :PaymentTypeID => tblorders.PaymentTypeID, :RADRAT => tblorders.RADRAT, :RefID => tblorders.RefID, :ReleaseDate => tblorders.ReleaseDate, :SessionID => tblorders.SessionID, :StoreID => tblorders.StoreID, :SubmitDate => tblorders.SubmitDate, :Tax => tblorders.Tax, :Tax2 => tblorders.Tax2, :Tip => tblorders.Tip, :TransactionDate => tblorders.TransactionDate, :VoidDate => tblorders.VoidDate, :VoidEmpID => tblorders.VoidEmpID, :VoidReason => tblorders.VoidReason, :IsActive => tblorders.IsActive }

        return tblordersJson.to_json

    end

    def self.list(data)
        tblorders = Tblorders.all

        Array tblordersJson = Array.new
        tblorders.each do |tblorders|
            tblordersJson.push({ :id => tblorders.id, :AddressID => tblorders.AddressID, :CustomerID => tblorders.CustomerID, :CustomerName => tblorders.CustomerName, :CustomerPhone => tblorders.CustomerPhone, :DailySequence => tblorders.DailySequence, :DeliveryCharge => tblorders.DeliveryCharge, :DriverMoney => tblorders.DriverMoney, :EditEmpID => tblorders.EditEmpID, :EditReason => tblorders.EditReason, :EmpID => tblorders.EmpID, :ExpectedDate => tblorders.ExpectedDate, :IPAddress => tblorders.IPAddress, :IsPaid => tblorders.IsPaid, :OrderID => tblorders.OrderID, :OrderNotes => tblorders.OrderNotes, :OrderStatusID => tblorders.OrderStatusID, :OrderTypeID => tblorders.OrderTypeID, :PaidDate => tblorders.PaidDate, :PaymentAuthorization => tblorders.PaymentAuthorization, :PaymentEmpID => tblorders.PaymentEmpID, :PaymentReference => tblorders.PaymentReference, :PaymentTypeID => tblorders.PaymentTypeID, :RADRAT => tblorders.RADRAT, :RefID => tblorders.RefID, :ReleaseDate => tblorders.ReleaseDate, :SessionID => tblorders.SessionID, :StoreID => tblorders.StoreID, :SubmitDate => tblorders.SubmitDate, :Tax => tblorders.Tax, :Tax2 => tblorders.Tax2, :Tip => tblorders.Tip, :TransactionDate => tblorders.TransactionDate, :VoidDate => tblorders.VoidDate, :VoidEmpID => tblorders.VoidEmpID, :VoidReason => tblorders.VoidReason, :IsActive => tblorders.IsActive })
        end

        return tblordersJson.to_json

    end

    def self.filter(data)
        tblorders = self.filterData(data)

        count = tblorders.length

        page  = data['Tblorders']['pagination']['page'].to_i
        limit = data['Tblorders']['pagination']['limit'].to_i
 
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
        tblorders = tblorders.slice(offset, limit)

        Array tblordersJson = Array.new
        tblorders.each do |tblorders|
            tblordersJson.push({ :id => tblorders.id, :AddressID => tblorders.AddressID, :CustomerID => tblorders.CustomerID, :CustomerName => tblorders.CustomerName, :CustomerPhone => tblorders.CustomerPhone, :DailySequence => tblorders.DailySequence, :DeliveryCharge => tblorders.DeliveryCharge, :DriverMoney => tblorders.DriverMoney, :EditEmpID => tblorders.EditEmpID, :EditReason => tblorders.EditReason, :EmpID => tblorders.EmpID, :ExpectedDate => tblorders.ExpectedDate, :IPAddress => tblorders.IPAddress, :IsPaid => tblorders.IsPaid, :OrderID => tblorders.OrderID, :OrderNotes => tblorders.OrderNotes, :OrderStatusID => tblorders.OrderStatusID, :OrderTypeID => tblorders.OrderTypeID, :PaidDate => tblorders.PaidDate, :PaymentAuthorization => tblorders.PaymentAuthorization, :PaymentEmpID => tblorders.PaymentEmpID, :PaymentReference => tblorders.PaymentReference, :PaymentTypeID => tblorders.PaymentTypeID, :RADRAT => tblorders.RADRAT, :RefID => tblorders.RefID, :ReleaseDate => tblorders.ReleaseDate, :SessionID => tblorders.SessionID, :StoreID => tblorders.StoreID, :SubmitDate => tblorders.SubmitDate, :Tax => tblorders.Tax, :Tax2 => tblorders.Tax2, :Tip => tblorders.Tip, :TransactionDate => tblorders.TransactionDate, :VoidDate => tblorders.VoidDate, :VoidEmpID => tblorders.VoidEmpID, :VoidReason => tblorders.VoidReason, :IsActive => tblorders.IsActive })
        end

        tblordersContainer = { :total => count, :tblorders => tblordersJson }

        return tblordersContainer.to_json

    end

    def self.filterData(data)

        tblorders = []
        if(data.key?("Tblorders"))
            filters = data['Tblorders']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblorders = Tblorders.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblorders = tblorders & Tblorders.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblorders
    end

end

