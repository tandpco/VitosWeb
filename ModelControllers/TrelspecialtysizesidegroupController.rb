require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelspecialtysizesidegroupController
    public
    def self.create(data)
        trelspecialtysizesidegroup = Trelspecialtysizesidegroup.create( :RADRAT => data['RADRAT'], :SideGroupID => data['SideGroupID'], :SizeID => data['SizeID'], :SpecialtyID => data['SpecialtyID'], :ItemCount => data['ItemCount'] )

        trelspecialtysizesidegroupJson = { :id => trelspecialtysizesidegroup.id, :RADRAT => trelspecialtysizesidegroup.RADRAT, :SideGroupID => trelspecialtysizesidegroup.SideGroupID, :SizeID => trelspecialtysizesidegroup.SizeID, :SpecialtyID => trelspecialtysizesidegroup.SpecialtyID, :ItemCount => trelspecialtysizesidegroup.ItemCount }

        return trelspecialtysizesidegroupJson.to_json
    end

    def self.read(data)
        trelspecialtysizesidegroup = Trelspecialtysizesidegroup.find(data['id'])

        trelspecialtysizesidegroupJson = { :id => trelspecialtysizesidegroup.id, :RADRAT => trelspecialtysizesidegroup.RADRAT, :SideGroupID => trelspecialtysizesidegroup.SideGroupID, :SizeID => trelspecialtysizesidegroup.SizeID, :SpecialtyID => trelspecialtysizesidegroup.SpecialtyID, :ItemCount => trelspecialtysizesidegroup.ItemCount }

        return trelspecialtysizesidegroupJson.to_json

    end

    def self.update(data)
        trelspecialtysizesidegroup = Trelspecialtysizesidegroup.update( data['id'], :RADRAT => data['RADRAT'], :SideGroupID => data['SideGroupID'], :SizeID => data['SizeID'], :SpecialtyID => data['SpecialtyID'], :ItemCount => data['ItemCount'] )

        trelspecialtysizesidegroupJson = { :status => status, :id => trelspecialtysizesidegroup.id, :RADRAT => trelspecialtysizesidegroup.RADRAT, :SideGroupID => trelspecialtysizesidegroup.SideGroupID, :SizeID => trelspecialtysizesidegroup.SizeID, :SpecialtyID => trelspecialtysizesidegroup.SpecialtyID, :ItemCount => trelspecialtysizesidegroup.ItemCount }

        return trelspecialtysizesidegroupJson.to_json

    end

    def self.delete(data)
        trelspecialtysizesidegroup = Trelspecialtysizesidegroup.find(data['id'])
        trelspecialtysizesidegroup.destroy

        trelspecialtysizesidegroupJson = { :id => trelspecialtysizesidegroup.id, :RADRAT => trelspecialtysizesidegroup.RADRAT, :SideGroupID => trelspecialtysizesidegroup.SideGroupID, :SizeID => trelspecialtysizesidegroup.SizeID, :SpecialtyID => trelspecialtysizesidegroup.SpecialtyID, :ItemCount => trelspecialtysizesidegroup.ItemCount }

        return trelspecialtysizesidegroupJson.to_json

    end

    def self.list(data)
        trelspecialtysizesidegroups = Trelspecialtysizesidegroup.all

        Array trelspecialtysizesidegroupJson = Array.new
        trelspecialtysizesidegroups.each do |trelspecialtysizesidegroup|
            trelspecialtysizesidegroupJson.push({ :id => trelspecialtysizesidegroup.id, :RADRAT => trelspecialtysizesidegroup.RADRAT, :SideGroupID => trelspecialtysizesidegroup.SideGroupID, :SizeID => trelspecialtysizesidegroup.SizeID, :SpecialtyID => trelspecialtysizesidegroup.SpecialtyID, :ItemCount => trelspecialtysizesidegroup.ItemCount })
        end

        return trelspecialtysizesidegroupJson.to_json

    end

    def self.filter(data)
        trelspecialtysizesidegroups = self.filterData(data)

        count = trelspecialtysizesidegroups.length

        page  = data['Trelspecialtysizesidegroup']['pagination']['page'].to_i
        limit = data['Trelspecialtysizesidegroup']['pagination']['limit'].to_i
 
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
        trelspecialtysizesidegroups = trelspecialtysizesidegroups.slice(offset, limit)

        Array trelspecialtysizesidegroupJson = Array.new
        trelspecialtysizesidegroups.each do |trelspecialtysizesidegroup|
            trelspecialtysizesidegroupJson.push({ :id => trelspecialtysizesidegroup.id, :RADRAT => trelspecialtysizesidegroup.RADRAT, :SideGroupID => trelspecialtysizesidegroup.SideGroupID, :SizeID => trelspecialtysizesidegroup.SizeID, :SpecialtyID => trelspecialtysizesidegroup.SpecialtyID, :ItemCount => trelspecialtysizesidegroup.ItemCount })
        end

        trelspecialtysizesidegroupContainer = { :total => count, :trelspecialtysizesidegroups => trelspecialtysizesidegroupJson }

        return trelspecialtysizesidegroupContainer.to_json

    end

    def self.filterData(data)

        trelspecialtysizesidegroups = []
        if(data.key?("Trelspecialtysizesidegroup"))
            filters = data['Trelspecialtysizesidegroup']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelspecialtysizesidegroups = Trelspecialtysizesidegroup.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelspecialtysizesidegroups = trelspecialtysizesidegroups & Trelspecialtysizesidegroup.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelspecialtysizesidegroups
    end

end

