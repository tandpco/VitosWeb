require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelunititemsController
    public
    def self.create(data)
        trelunititems = Trelunititems.create( :IsBaseCheese => data['IsBaseCheese'], :IsCheese => data['IsCheese'], :IsExtraCheese => data['IsExtraCheese'], :ItemID => data['ItemID'], :RADRAT => data['RADRAT'], :UnitID => data['UnitID'], :UnitItemPrintOrder => data['UnitItemPrintOrder'], :RADRAT => data['RADRAT'] )

        trelunititemsJson = { :id => trelunititems.id, :IsBaseCheese => trelunititems.IsBaseCheese, :IsCheese => trelunititems.IsCheese, :IsExtraCheese => trelunititems.IsExtraCheese, :ItemID => trelunititems.ItemID, :RADRAT => trelunititems.RADRAT, :UnitID => trelunititems.UnitID, :UnitItemPrintOrder => trelunititems.UnitItemPrintOrder, :RADRAT => trelunititems.RADRAT }

        return trelunititemsJson.to_json
    end

    def self.read(data)
        trelunititems = Trelunititems.find(data['id'])

        trelunititemsJson = { :id => trelunititems.id, :IsBaseCheese => trelunititems.IsBaseCheese, :IsCheese => trelunititems.IsCheese, :IsExtraCheese => trelunititems.IsExtraCheese, :ItemID => trelunititems.ItemID, :RADRAT => trelunititems.RADRAT, :UnitID => trelunititems.UnitID, :UnitItemPrintOrder => trelunititems.UnitItemPrintOrder, :RADRAT => trelunititems.RADRAT }

        return trelunititemsJson.to_json

    end

    def self.update(data)
        trelunititems = Trelunititems.update( data['id'], :IsBaseCheese => data['IsBaseCheese'], :IsCheese => data['IsCheese'], :IsExtraCheese => data['IsExtraCheese'], :ItemID => data['ItemID'], :RADRAT => data['RADRAT'], :UnitID => data['UnitID'], :UnitItemPrintOrder => data['UnitItemPrintOrder'], :RADRAT => data['RADRAT'] )

        trelunititemsJson = { :status => status, :id => trelunititems.id, :IsBaseCheese => trelunititems.IsBaseCheese, :IsCheese => trelunititems.IsCheese, :IsExtraCheese => trelunititems.IsExtraCheese, :ItemID => trelunititems.ItemID, :RADRAT => trelunititems.RADRAT, :UnitID => trelunititems.UnitID, :UnitItemPrintOrder => trelunititems.UnitItemPrintOrder, :RADRAT => trelunititems.RADRAT }

        return trelunititemsJson.to_json

    end

    def self.delete(data)
        trelunititems = Trelunititems.find(data['id'])
        trelunititems.destroy

        trelunititemsJson = { :id => trelunititems.id, :IsBaseCheese => trelunititems.IsBaseCheese, :IsCheese => trelunititems.IsCheese, :IsExtraCheese => trelunititems.IsExtraCheese, :ItemID => trelunititems.ItemID, :RADRAT => trelunititems.RADRAT, :UnitID => trelunititems.UnitID, :UnitItemPrintOrder => trelunititems.UnitItemPrintOrder, :RADRAT => trelunititems.RADRAT }

        return trelunititemsJson.to_json

    end

    def self.list(data)
        trelunititems = Trelunititems.all

        Array trelunititemsJson = Array.new
        trelunititems.each do |trelunititems|
            trelunititemsJson.push({ :id => trelunititems.id, :IsBaseCheese => trelunititems.IsBaseCheese, :IsCheese => trelunititems.IsCheese, :IsExtraCheese => trelunititems.IsExtraCheese, :ItemID => trelunititems.ItemID, :RADRAT => trelunititems.RADRAT, :UnitID => trelunititems.UnitID, :UnitItemPrintOrder => trelunititems.UnitItemPrintOrder, :RADRAT => trelunititems.RADRAT })
        end

        return trelunititemsJson.to_json

    end

    def self.filter(data)
        trelunititems = self.filterData(data)

        count = trelunititems.length

        page  = data['Trelunititems']['pagination']['page'].to_i
        limit = data['Trelunititems']['pagination']['limit'].to_i
 
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
        trelunititems = trelunititems.slice(offset, limit)

        Array trelunititemsJson = Array.new
        trelunititems.each do |trelunititems|
            trelunititemsJson.push({ :id => trelunititems.id, :IsBaseCheese => trelunititems.IsBaseCheese, :IsCheese => trelunititems.IsCheese, :IsExtraCheese => trelunititems.IsExtraCheese, :ItemID => trelunititems.ItemID, :RADRAT => trelunititems.RADRAT, :UnitID => trelunititems.UnitID, :UnitItemPrintOrder => trelunititems.UnitItemPrintOrder, :RADRAT => trelunititems.RADRAT })
        end

        trelunititemsContainer = { :total => count, :trelunititems => trelunititemsJson }

        return trelunititemsContainer.to_json

    end

    def self.filterData(data)

        trelunititems = []
        if(data.key?("Trelunititems"))
            filters = data['Trelunititems']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelunititems = Trelunititems.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelunititems = trelunititems & Trelunititems.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelunititems
    end

end

