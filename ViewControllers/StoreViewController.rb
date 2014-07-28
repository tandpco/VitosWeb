require 'sinatra'
require 'json'
require 'time'

class StoreViewController
    public

    def self.getStore(data)
        storeId   = data['storeId'].to_s

        rows = ActiveRecord::Base.connection.select_all('select * from tblStores where storeid = ' + storeId + ' AND 1 = 1')

        now  = Time.new()

        isOpen = false
        if(rows.count > 0)
            nTime = now.hour * 100 + now.min
            open  = 0
            close = 0
            case now.wday 
                when 0
                    open = rows[0]['OpenSun']
                    close = rows[0]['CloseSun']
                when 1
                    open = rows[0]['OpenMon']
                    close = rows[0]['CloseMon']
                when 2
                    open = rows[0]['OpenTue']
                    close = rows[0]['CloseTue']
                when 3
                    open = rows[0]['OpenWed']
                    close = rows[0]['CloseWed']
                when 4
                    open = rows[0]['OpenThu']
                    close = rows[0]['CloseThu']
                when 5
                    open = rows[0]['OpenFri']
                    close = rows[0]['CloseFri']
                when 6
                    open = rows[0]['OpenSat']
                    close = rows[0]['CloseSat']
            end

            if(nTime >= open && nTime <= 2400) or (nTime >= 0 && nTime <= close)
                isOpen = true
            end

            rows[0]['IsOpen'] = isOpen
        end

        return rows.to_json
    end

    def self.listStores(data)
        email     = data['email']
        password  = data['password']

        rows = ActiveRecord::Base.connection.select_all('select * from tblStores where storeid > 0 AND 1 = 1')

        return rows.to_json
    end

end

