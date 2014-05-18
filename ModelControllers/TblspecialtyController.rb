require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblspecialtyController
    public
    def self.create(data)
        tblspecialty = Tblspecialty.create( :IsActive => data['IsActive'], :IsInternet => data['IsInternet'], :NoBaseCheese => data['NoBaseCheese'], :RADRAT => data['RADRAT'], :SauceID => data['SauceID'], :SpecialtyDescription => data['SpecialtyDescription'], :SpecialtyID => data['SpecialtyID'], :SpecialtyShortDescription => data['SpecialtyShortDescription'], :StyleID => data['StyleID'], :UnitID => data['UnitID'], :BatchCount => data['BatchCount'] )

        tblspecialtyJson = { :id => tblspecialty.id, :IsActive => tblspecialty.IsActive, :IsInternet => tblspecialty.IsInternet, :NoBaseCheese => tblspecialty.NoBaseCheese, :RADRAT => tblspecialty.RADRAT, :SauceID => tblspecialty.SauceID, :SpecialtyDescription => tblspecialty.SpecialtyDescription, :SpecialtyID => tblspecialty.SpecialtyID, :SpecialtyShortDescription => tblspecialty.SpecialtyShortDescription, :StyleID => tblspecialty.StyleID, :UnitID => tblspecialty.UnitID, :BatchCount => tblspecialty.BatchCount }

        return tblspecialtyJson.to_json
    end

    def self.read(data)
        tblspecialty = Tblspecialty.find(data['id'])

        tblspecialtyJson = { :id => tblspecialty.id, :IsActive => tblspecialty.IsActive, :IsInternet => tblspecialty.IsInternet, :NoBaseCheese => tblspecialty.NoBaseCheese, :RADRAT => tblspecialty.RADRAT, :SauceID => tblspecialty.SauceID, :SpecialtyDescription => tblspecialty.SpecialtyDescription, :SpecialtyID => tblspecialty.SpecialtyID, :SpecialtyShortDescription => tblspecialty.SpecialtyShortDescription, :StyleID => tblspecialty.StyleID, :UnitID => tblspecialty.UnitID, :BatchCount => tblspecialty.BatchCount }

        return tblspecialtyJson.to_json

    end

    def self.update(data)
        tblspecialty = Tblspecialty.update( data['id'], :IsActive => data['IsActive'], :IsInternet => data['IsInternet'], :NoBaseCheese => data['NoBaseCheese'], :RADRAT => data['RADRAT'], :SauceID => data['SauceID'], :SpecialtyDescription => data['SpecialtyDescription'], :SpecialtyID => data['SpecialtyID'], :SpecialtyShortDescription => data['SpecialtyShortDescription'], :StyleID => data['StyleID'], :UnitID => data['UnitID'], :BatchCount => data['BatchCount'] )

        tblspecialtyJson = { :status => status, :id => tblspecialty.id, :IsActive => tblspecialty.IsActive, :IsInternet => tblspecialty.IsInternet, :NoBaseCheese => tblspecialty.NoBaseCheese, :RADRAT => tblspecialty.RADRAT, :SauceID => tblspecialty.SauceID, :SpecialtyDescription => tblspecialty.SpecialtyDescription, :SpecialtyID => tblspecialty.SpecialtyID, :SpecialtyShortDescription => tblspecialty.SpecialtyShortDescription, :StyleID => tblspecialty.StyleID, :UnitID => tblspecialty.UnitID, :BatchCount => tblspecialty.BatchCount }

        return tblspecialtyJson.to_json

    end

    def self.delete(data)
        tblspecialty = Tblspecialty.find(data['id'])
        tblspecialty.destroy

        tblspecialtyJson = { :id => tblspecialty.id, :IsActive => tblspecialty.IsActive, :IsInternet => tblspecialty.IsInternet, :NoBaseCheese => tblspecialty.NoBaseCheese, :RADRAT => tblspecialty.RADRAT, :SauceID => tblspecialty.SauceID, :SpecialtyDescription => tblspecialty.SpecialtyDescription, :SpecialtyID => tblspecialty.SpecialtyID, :SpecialtyShortDescription => tblspecialty.SpecialtyShortDescription, :StyleID => tblspecialty.StyleID, :UnitID => tblspecialty.UnitID, :BatchCount => tblspecialty.BatchCount }

        return tblspecialtyJson.to_json

    end

    def self.list(data)
        tblspecialties = Tblspecialty.all

        Array tblspecialtyJson = Array.new
        tblspecialties.each do |tblspecialty|
            tblspecialtyJson.push({ :id => tblspecialty.id, :IsActive => tblspecialty.IsActive, :IsInternet => tblspecialty.IsInternet, :NoBaseCheese => tblspecialty.NoBaseCheese, :RADRAT => tblspecialty.RADRAT, :SauceID => tblspecialty.SauceID, :SpecialtyDescription => tblspecialty.SpecialtyDescription, :SpecialtyID => tblspecialty.SpecialtyID, :SpecialtyShortDescription => tblspecialty.SpecialtyShortDescription, :StyleID => tblspecialty.StyleID, :UnitID => tblspecialty.UnitID, :BatchCount => tblspecialty.BatchCount })
        end

        return tblspecialtyJson.to_json

    end

    def self.filter(data)
        tblspecialties = self.filterData(data)

        count = tblspecialties.length

        page  = data['Tblspecialty']['pagination']['page'].to_i
        limit = data['Tblspecialty']['pagination']['limit'].to_i
 
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
        tblspecialties = tblspecialties.slice(offset, limit)

        Array tblspecialtyJson = Array.new
        tblspecialties.each do |tblspecialty|
            tblspecialtyJson.push({ :id => tblspecialty.id, :IsActive => tblspecialty.IsActive, :IsInternet => tblspecialty.IsInternet, :NoBaseCheese => tblspecialty.NoBaseCheese, :RADRAT => tblspecialty.RADRAT, :SauceID => tblspecialty.SauceID, :SpecialtyDescription => tblspecialty.SpecialtyDescription, :SpecialtyID => tblspecialty.SpecialtyID, :SpecialtyShortDescription => tblspecialty.SpecialtyShortDescription, :StyleID => tblspecialty.StyleID, :UnitID => tblspecialty.UnitID, :BatchCount => tblspecialty.BatchCount })
        end

        tblspecialtyContainer = { :total => count, :tblspecialties => tblspecialtyJson }

        return tblspecialtyContainer.to_json

    end

    def self.filterData(data)

        tblspecialties = []
        if(data.key?("Tblspecialty"))
            filters = data['Tblspecialty']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblspecialties = Tblspecialty.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblspecialties = tblspecialties & Tblspecialty.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblspecialties
    end

end

