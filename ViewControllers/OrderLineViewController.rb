require 'sinatra'
require 'json'

class OrderLineViewController
    public

    def self.getOrderLines(data)
        orderId   = data['OrderID'].to_s

        rows = ActiveRecord::Base.connection.select_all('SELECT [tblorderLines].* FROM [tblorderLines] WHERE OrderID = ' + orderId + ' AND 1 = 1 ORDER BY OrderLineID ASC')

        rows.each do |row|
            row.keys.each do |key|
                puts("#{key} -> #{row[key].class.to_s}, #{row[key].to_s}")
                # if(row[key].class.to_s == "String")
                    # row[key].gsub!(/'/,"\u2019")
                # end
            end
        end

        return rows.to_json
    end
    
    def self.deleteOrderLine(data)
        orderLineId = data['OrderLineID'].to_s

        result = ActiveRecord::Base.connection.execute('DELETE FROM Tblorderlines WHERE OrderLineID = ' + orderLineId)
        return result.to_json
    end

    def self.convertToInt(value)
        if(value == 'NULL' || value.to_i == 0)
            value = nil
        else
            value = value.to_i
        end

        return value
    end

    def self.convertToFloat(value)
        if(value == 'NULL')
            value = nil
        else
            value = value.to_f
        end

        return value
    end


end

