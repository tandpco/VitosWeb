require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblunitController
    public
    def self.create(data)
        tblunit = Tblunit.create( :CustomDescription => data['CustomDescription'], :InternetDescription => data['InternetDescription'], :IsActive => data['IsActive'], :IsInternet => data['IsInternet'], :RADRAT => data['RADRAT'], :UnitDescription => data['UnitDescription'], :UnitID => data['UnitID'], :UnitMenuSortOrder => data['UnitMenuSortOrder'], :UnitShortDescription => data['UnitShortDescription'], :Address1 => data['Address1'] )

        tblunitJson = { :id => tblunit.id, :CustomDescription => tblunit.CustomDescription, :InternetDescription => tblunit.InternetDescription, :IsActive => tblunit.IsActive, :IsInternet => tblunit.IsInternet, :RADRAT => tblunit.RADRAT, :UnitDescription => tblunit.UnitDescription, :UnitID => tblunit.UnitID, :UnitMenuSortOrder => tblunit.UnitMenuSortOrder, :UnitShortDescription => tblunit.UnitShortDescription, :Address1 => tblunit.Address1 }

        return tblunitJson.to_json
    end

    def self.read(data)
        tblunit = Tblunit.find(data['id'])

        tblunitJson = { :id => tblunit.id, :CustomDescription => tblunit.CustomDescription, :InternetDescription => tblunit.InternetDescription, :IsActive => tblunit.IsActive, :IsInternet => tblunit.IsInternet, :RADRAT => tblunit.RADRAT, :UnitDescription => tblunit.UnitDescription, :UnitID => tblunit.UnitID, :UnitMenuSortOrder => tblunit.UnitMenuSortOrder, :UnitShortDescription => tblunit.UnitShortDescription, :Address1 => tblunit.Address1 }

        return tblunitJson.to_json

    end

    def self.update(data)
        tblunit = Tblunit.update( data['id'], :CustomDescription => data['CustomDescription'], :InternetDescription => data['InternetDescription'], :IsActive => data['IsActive'], :IsInternet => data['IsInternet'], :RADRAT => data['RADRAT'], :UnitDescription => data['UnitDescription'], :UnitID => data['UnitID'], :UnitMenuSortOrder => data['UnitMenuSortOrder'], :UnitShortDescription => data['UnitShortDescription'], :Address1 => data['Address1'] )

        tblunitJson = { :status => status, :id => tblunit.id, :CustomDescription => tblunit.CustomDescription, :InternetDescription => tblunit.InternetDescription, :IsActive => tblunit.IsActive, :IsInternet => tblunit.IsInternet, :RADRAT => tblunit.RADRAT, :UnitDescription => tblunit.UnitDescription, :UnitID => tblunit.UnitID, :UnitMenuSortOrder => tblunit.UnitMenuSortOrder, :UnitShortDescription => tblunit.UnitShortDescription, :Address1 => tblunit.Address1 }

        return tblunitJson.to_json

    end

    def self.delete(data)
        tblunit = Tblunit.find(data['id'])
        tblunit.destroy

        tblunitJson = { :id => tblunit.id, :CustomDescription => tblunit.CustomDescription, :InternetDescription => tblunit.InternetDescription, :IsActive => tblunit.IsActive, :IsInternet => tblunit.IsInternet, :RADRAT => tblunit.RADRAT, :UnitDescription => tblunit.UnitDescription, :UnitID => tblunit.UnitID, :UnitMenuSortOrder => tblunit.UnitMenuSortOrder, :UnitShortDescription => tblunit.UnitShortDescription, :Address1 => tblunit.Address1 }

        return tblunitJson.to_json

    end

    def self.list(data)
        tblunits = Tblunit.all

        Array tblunitJson = Array.new
        tblunits.each do |tblunit|
            tblunitJson.push({ :id => tblunit.id, :CustomDescription => tblunit.CustomDescription, :InternetDescription => tblunit.InternetDescription, :IsActive => tblunit.IsActive, :IsInternet => tblunit.IsInternet, :RADRAT => tblunit.RADRAT, :UnitDescription => tblunit.UnitDescription, :UnitID => tblunit.UnitID, :UnitMenuSortOrder => tblunit.UnitMenuSortOrder, :UnitShortDescription => tblunit.UnitShortDescription, :Address1 => tblunit.Address1 })
        end

        return tblunitJson.to_json

    end

    def self.filter(data)
        tblunits = self.filterData(data)

        count = tblunits.length

        page  = data['Tblunit']['pagination']['page'].to_i
        limit = data['Tblunit']['pagination']['limit'].to_i
 
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
        tblunits = tblunits.slice(offset, limit)

        Array tblunitJson = Array.new
        tblunits.each do |tblunit|
            tblunitJson.push({ :id => tblunit.id, :CustomDescription => tblunit.CustomDescription, :InternetDescription => tblunit.InternetDescription, :IsActive => tblunit.IsActive, :IsInternet => tblunit.IsInternet, :RADRAT => tblunit.RADRAT, :UnitDescription => tblunit.UnitDescription, :UnitID => tblunit.UnitID, :UnitMenuSortOrder => tblunit.UnitMenuSortOrder, :UnitShortDescription => tblunit.UnitShortDescription, :Address1 => tblunit.Address1 })
        end

        tblunitContainer = { :total => count, :tblunits => tblunitJson }

        return tblunitContainer.to_json

    end

    def self.filterData(data)

        tblunits = []
        if(data.key?("Tblunit"))
            filters = data['Tblunit']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblunits = Tblunit.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblunits = tblunits & Tblunit.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblunits
    end

end

