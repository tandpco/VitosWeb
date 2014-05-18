require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelsidegroupsidesController
    public
    def self.create(data)
        trelsidegroupsides = Trelsidegroupsides.create( :RADRAT => data['RADRAT'], :SideGroupID => data['SideGroupID'], :SidesID => data['SidesID'], :RADRAT => data['RADRAT'] )

        trelsidegroupsidesJson = { :id => trelsidegroupsides.id, :RADRAT => trelsidegroupsides.RADRAT, :SideGroupID => trelsidegroupsides.SideGroupID, :SidesID => trelsidegroupsides.SidesID, :RADRAT => trelsidegroupsides.RADRAT }

        return trelsidegroupsidesJson.to_json
    end

    def self.read(data)
        trelsidegroupsides = Trelsidegroupsides.find(data['id'])

        trelsidegroupsidesJson = { :id => trelsidegroupsides.id, :RADRAT => trelsidegroupsides.RADRAT, :SideGroupID => trelsidegroupsides.SideGroupID, :SidesID => trelsidegroupsides.SidesID, :RADRAT => trelsidegroupsides.RADRAT }

        return trelsidegroupsidesJson.to_json

    end

    def self.update(data)
        trelsidegroupsides = Trelsidegroupsides.update( data['id'], :RADRAT => data['RADRAT'], :SideGroupID => data['SideGroupID'], :SidesID => data['SidesID'], :RADRAT => data['RADRAT'] )

        trelsidegroupsidesJson = { :id => trelsidegroupsides.id, :RADRAT => trelsidegroupsides.RADRAT, :SideGroupID => trelsidegroupsides.SideGroupID, :SidesID => trelsidegroupsides.SidesID, :RADRAT => trelsidegroupsides.RADRAT }

        return trelsidegroupsidesJson.to_json

    end

    def self.delete(data)
        trelsidegroupsides = Trelsidegroupsides.find(data['id'])
        trelsidegroupsides.destroy

        trelsidegroupsidesJson = { :id => trelsidegroupsides.id, :RADRAT => trelsidegroupsides.RADRAT, :SideGroupID => trelsidegroupsides.SideGroupID, :SidesID => trelsidegroupsides.SidesID, :RADRAT => trelsidegroupsides.RADRAT }

        return trelsidegroupsidesJson.to_json

    end

    def self.list(data)
        trelsidegroupsides = Trelsidegroupsides.all

        Array trelsidegroupsidesJson = Array.new
        trelsidegroupsides.each do |trelsidegroupsides|
            trelsidegroupsidesJson.push({ :id => trelsidegroupsides.id, :RADRAT => trelsidegroupsides.RADRAT, :SideGroupID => trelsidegroupsides.SideGroupID, :SidesID => trelsidegroupsides.SidesID, :RADRAT => trelsidegroupsides.RADRAT })
        end

        return trelsidegroupsidesJson.to_json

    end

    def self.filter(data)
        trelsidegroupsides = self.filterData(data)

        count = trelsidegroupsides.length

        page  = data['Trelsidegroupsides']['pagination']['page'].to_i
        limit = data['Trelsidegroupsides']['pagination']['limit'].to_i
 
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
        trelsidegroupsides = trelsidegroupsides.slice(offset, limit)

        Array trelsidegroupsidesJson = Array.new
        trelsidegroupsides.each do |trelsidegroupsides|
            trelsidegroupsidesJson.push({ :id => trelsidegroupsides.id, :RADRAT => trelsidegroupsides.RADRAT, :SideGroupID => trelsidegroupsides.SideGroupID, :SidesID => trelsidegroupsides.SidesID, :RADRAT => trelsidegroupsides.RADRAT })
        end

        trelsidegroupsidesContainer = { :total => count, :trelsidegroupsides => trelsidegroupsidesJson }

        return trelsidegroupsidesContainer.to_json

    end

    def self.filterData(data)

        trelsidegroupsides = []
        if(data.key?("Trelsidegroupsides"))
            filters = data['Trelsidegroupsides']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelsidegroupsides = Trelsidegroupsides.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelsidegroupsides = trelsidegroupsides & Trelsidegroupsides.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelsidegroupsides
    end

end

