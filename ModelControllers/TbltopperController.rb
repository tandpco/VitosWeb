require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TbltopperController
    public
    def self.create(data)
        tbltopper = Tbltopper.create( :RADRAT => data['RADRAT'], :TopperDescription => data['TopperDescription'], :TopperID => data['TopperID'], :TopperShortDescription => data['TopperShortDescription'] )

        tbltopperJson = { :id => tbltopper.id, :RADRAT => tbltopper.RADRAT, :TopperDescription => tbltopper.TopperDescription, :TopperID => tbltopper.TopperID, :TopperShortDescription => tbltopper.TopperShortDescription }

        return tbltopperJson.to_json
    end

    def self.read(data)
        tbltopper = Tbltopper.find(data['id'])

        tbltopperJson = { :id => tbltopper.id, :RADRAT => tbltopper.RADRAT, :TopperDescription => tbltopper.TopperDescription, :TopperID => tbltopper.TopperID, :TopperShortDescription => tbltopper.TopperShortDescription }

        return tbltopperJson.to_json

    end

    def self.update(data)
        tbltopper = Tbltopper.update( data['id'], :RADRAT => data['RADRAT'], :TopperDescription => data['TopperDescription'], :TopperID => data['TopperID'], :TopperShortDescription => data['TopperShortDescription'] )

        tbltopperJson = { :id => tbltopper.id, :RADRAT => tbltopper.RADRAT, :TopperDescription => tbltopper.TopperDescription, :TopperID => tbltopper.TopperID, :TopperShortDescription => tbltopper.TopperShortDescription }

        return tbltopperJson.to_json

    end

    def self.delete(data)
        tbltopper = Tbltopper.find(data['id'])
        tbltopper.destroy

        tbltopperJson = { :id => tbltopper.id, :RADRAT => tbltopper.RADRAT, :TopperDescription => tbltopper.TopperDescription, :TopperID => tbltopper.TopperID, :TopperShortDescription => tbltopper.TopperShortDescription }

        return tbltopperJson.to_json

    end

    def self.list(data)
        tbltoppers = Tbltopper.all

        Array tbltopperJson = Array.new
        tbltoppers.each do |tbltopper|
            tbltopperJson.push({ :id => tbltopper.id, :RADRAT => tbltopper.RADRAT, :TopperDescription => tbltopper.TopperDescription, :TopperID => tbltopper.TopperID, :TopperShortDescription => tbltopper.TopperShortDescription })
        end

        return tbltopperJson.to_json

    end

    def self.filter(data)
        tbltoppers = self.filterData(data)

        count = tbltoppers.length

        page  = data['Tbltopper']['pagination']['page'].to_i
        limit = data['Tbltopper']['pagination']['limit'].to_i
 
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
        tbltoppers = tbltoppers.slice(offset, limit)

        Array tbltopperJson = Array.new
        tbltoppers.each do |tbltopper|
            tbltopperJson.push({ :id => tbltopper.id, :RADRAT => tbltopper.RADRAT, :TopperDescription => tbltopper.TopperDescription, :TopperID => tbltopper.TopperID, :TopperShortDescription => tbltopper.TopperShortDescription })
        end

        tbltopperContainer = { :total => count, :tbltoppers => tbltopperJson }

        return tbltopperContainer.to_json

    end

    def self.filterData(data)

        tbltoppers = []
        if(data.key?("Tbltopper"))
            filters = data['Tbltopper']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tbltoppers = Tbltopper.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tbltoppers = tbltoppers & Tbltopper.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tbltoppers
    end

end

