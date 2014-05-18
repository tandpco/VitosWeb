require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblsidesController
    public
    def self.create(data)
        tblsides = Tblsides.create( :RADRAT => data['RADRAT'], :SideDescription => data['SideDescription'], :SideID => data['SideID'], :SideShortDescription => data['SideShortDescription'], :IsActive => data['IsActive'] )

        tblsidesJson = { :id => tblsides.id, :RADRAT => tblsides.RADRAT, :SideDescription => tblsides.SideDescription, :SideID => tblsides.SideID, :SideShortDescription => tblsides.SideShortDescription, :IsActive => tblsides.IsActive }

        return tblsidesJson.to_json
    end

    def self.read(data)
        tblsides = Tblsides.find(data['id'])

        tblsidesJson = { :id => tblsides.id, :RADRAT => tblsides.RADRAT, :SideDescription => tblsides.SideDescription, :SideID => tblsides.SideID, :SideShortDescription => tblsides.SideShortDescription, :IsActive => tblsides.IsActive }

        return tblsidesJson.to_json

    end

    def self.update(data)
        tblsides = Tblsides.update( data['id'], :RADRAT => data['RADRAT'], :SideDescription => data['SideDescription'], :SideID => data['SideID'], :SideShortDescription => data['SideShortDescription'], :IsActive => data['IsActive'] )

        tblsidesJson = { :status => status, :id => tblsides.id, :RADRAT => tblsides.RADRAT, :SideDescription => tblsides.SideDescription, :SideID => tblsides.SideID, :SideShortDescription => tblsides.SideShortDescription, :IsActive => tblsides.IsActive }

        return tblsidesJson.to_json

    end

    def self.delete(data)
        tblsides = Tblsides.find(data['id'])
        tblsides.destroy

        tblsidesJson = { :id => tblsides.id, :RADRAT => tblsides.RADRAT, :SideDescription => tblsides.SideDescription, :SideID => tblsides.SideID, :SideShortDescription => tblsides.SideShortDescription, :IsActive => tblsides.IsActive }

        return tblsidesJson.to_json

    end

    def self.list(data)
        tblsides = Tblsides.all

        Array tblsidesJson = Array.new
        tblsides.each do |tblsides|
            tblsidesJson.push({ :id => tblsides.id, :RADRAT => tblsides.RADRAT, :SideDescription => tblsides.SideDescription, :SideID => tblsides.SideID, :SideShortDescription => tblsides.SideShortDescription, :IsActive => tblsides.IsActive })
        end

        return tblsidesJson.to_json

    end

    def self.filter(data)
        tblsides = self.filterData(data)

        count = tblsides.length

        page  = data['Tblsides']['pagination']['page'].to_i
        limit = data['Tblsides']['pagination']['limit'].to_i
 
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
        tblsides = tblsides.slice(offset, limit)

        Array tblsidesJson = Array.new
        tblsides.each do |tblsides|
            tblsidesJson.push({ :id => tblsides.id, :RADRAT => tblsides.RADRAT, :SideDescription => tblsides.SideDescription, :SideID => tblsides.SideID, :SideShortDescription => tblsides.SideShortDescription, :IsActive => tblsides.IsActive })
        end

        tblsidesContainer = { :total => count, :tblsides => tblsidesJson }

        return tblsidesContainer.to_json

    end

    def self.filterData(data)

        tblsides = []
        if(data.key?("Tblsides"))
            filters = data['Tblsides']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblsides = Tblsides.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblsides = tblsides & Tblsides.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblsides
    end

end

