require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblsizesController
    public
    def self.create(data)
        tblsizes = Tblsizes.create( :RADRAT => data['RADRAT'], :SizeDescription => data['SizeDescription'], :SizeID => data['SizeID'], :SizeShortDescription => data['SizeShortDescription'], :InternetDescription => data['InternetDescription'] )

        tblsizesJson = { :id => tblsizes.id, :RADRAT => tblsizes.RADRAT, :SizeDescription => tblsizes.SizeDescription, :SizeID => tblsizes.SizeID, :SizeShortDescription => tblsizes.SizeShortDescription, :InternetDescription => tblsizes.InternetDescription }

        return tblsizesJson.to_json
    end

    def self.read(data)
        tblsizes = Tblsizes.find(data['id'])

        tblsizesJson = { :id => tblsizes.id, :RADRAT => tblsizes.RADRAT, :SizeDescription => tblsizes.SizeDescription, :SizeID => tblsizes.SizeID, :SizeShortDescription => tblsizes.SizeShortDescription, :InternetDescription => tblsizes.InternetDescription }

        return tblsizesJson.to_json

    end

    def self.update(data)
        tblsizes = Tblsizes.update( data['id'], :RADRAT => data['RADRAT'], :SizeDescription => data['SizeDescription'], :SizeID => data['SizeID'], :SizeShortDescription => data['SizeShortDescription'], :InternetDescription => data['InternetDescription'] )

        tblsizesJson = { :status => status, :id => tblsizes.id, :RADRAT => tblsizes.RADRAT, :SizeDescription => tblsizes.SizeDescription, :SizeID => tblsizes.SizeID, :SizeShortDescription => tblsizes.SizeShortDescription, :InternetDescription => tblsizes.InternetDescription }

        return tblsizesJson.to_json

    end

    def self.delete(data)
        tblsizes = Tblsizes.find(data['id'])
        tblsizes.destroy

        tblsizesJson = { :id => tblsizes.id, :RADRAT => tblsizes.RADRAT, :SizeDescription => tblsizes.SizeDescription, :SizeID => tblsizes.SizeID, :SizeShortDescription => tblsizes.SizeShortDescription, :InternetDescription => tblsizes.InternetDescription }

        return tblsizesJson.to_json

    end

    def self.list(data)
        tblsizes = Tblsizes.all

        Array tblsizesJson = Array.new
        tblsizes.each do |tblsizes|
            tblsizesJson.push({ :id => tblsizes.id, :RADRAT => tblsizes.RADRAT, :SizeDescription => tblsizes.SizeDescription, :SizeID => tblsizes.SizeID, :SizeShortDescription => tblsizes.SizeShortDescription, :InternetDescription => tblsizes.InternetDescription })
        end

        return tblsizesJson.to_json

    end

    def self.filter(data)
        tblsizes = self.filterData(data)

        count = tblsizes.length

        page  = data['Tblsizes']['pagination']['page'].to_i
        limit = data['Tblsizes']['pagination']['limit'].to_i
 
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
        tblsizes = tblsizes.slice(offset, limit)

        Array tblsizesJson = Array.new
        tblsizes.each do |tblsizes|
            tblsizesJson.push({ :id => tblsizes.id, :RADRAT => tblsizes.RADRAT, :SizeDescription => tblsizes.SizeDescription, :SizeID => tblsizes.SizeID, :SizeShortDescription => tblsizes.SizeShortDescription, :InternetDescription => tblsizes.InternetDescription })
        end

        tblsizesContainer = { :total => count, :tblsizes => tblsizesJson }

        return tblsizesContainer.to_json

    end

    def self.filterData(data)

        tblsizes = []
        if(data.key?("Tblsizes"))
            filters = data['Tblsizes']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblsizes = Tblsizes.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblsizes = tblsizes & Tblsizes.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblsizes
    end

end

