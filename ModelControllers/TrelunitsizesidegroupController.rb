require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelunitsizesidegroupController
    public
    def self.create(data)
        trelunitsizesidegroup = Trelunitsizesidegroup.create( :RADRAT => data['RADRAT'], :SideGroupID => data['SideGroupID'], :SizeID => data['SizeID'], :UnitID => data['UnitID'], :RADRAT => data['RADRAT'] )

        trelunitsizesidegroupJson = { :id => trelunitsizesidegroup.id, :RADRAT => trelunitsizesidegroup.RADRAT, :SideGroupID => trelunitsizesidegroup.SideGroupID, :SizeID => trelunitsizesidegroup.SizeID, :UnitID => trelunitsizesidegroup.UnitID, :RADRAT => trelunitsizesidegroup.RADRAT }

        return trelunitsizesidegroupJson.to_json
    end

    def self.read(data)
        trelunitsizesidegroup = Trelunitsizesidegroup.find(data['id'])

        trelunitsizesidegroupJson = { :id => trelunitsizesidegroup.id, :RADRAT => trelunitsizesidegroup.RADRAT, :SideGroupID => trelunitsizesidegroup.SideGroupID, :SizeID => trelunitsizesidegroup.SizeID, :UnitID => trelunitsizesidegroup.UnitID, :RADRAT => trelunitsizesidegroup.RADRAT }

        return trelunitsizesidegroupJson.to_json

    end

    def self.update(data)
        trelunitsizesidegroup = Trelunitsizesidegroup.update( data['id'], :RADRAT => data['RADRAT'], :SideGroupID => data['SideGroupID'], :SizeID => data['SizeID'], :UnitID => data['UnitID'], :RADRAT => data['RADRAT'] )

        trelunitsizesidegroupJson = { :id => trelunitsizesidegroup.id, :RADRAT => trelunitsizesidegroup.RADRAT, :SideGroupID => trelunitsizesidegroup.SideGroupID, :SizeID => trelunitsizesidegroup.SizeID, :UnitID => trelunitsizesidegroup.UnitID, :RADRAT => trelunitsizesidegroup.RADRAT }

        return trelunitsizesidegroupJson.to_json

    end

    def self.delete(data)
        trelunitsizesidegroup = Trelunitsizesidegroup.find(data['id'])
        trelunitsizesidegroup.destroy

        trelunitsizesidegroupJson = { :id => trelunitsizesidegroup.id, :RADRAT => trelunitsizesidegroup.RADRAT, :SideGroupID => trelunitsizesidegroup.SideGroupID, :SizeID => trelunitsizesidegroup.SizeID, :UnitID => trelunitsizesidegroup.UnitID, :RADRAT => trelunitsizesidegroup.RADRAT }

        return trelunitsizesidegroupJson.to_json

    end

    def self.list(data)
        trelunitsizesidegroups = Trelunitsizesidegroup.all

        Array trelunitsizesidegroupJson = Array.new
        trelunitsizesidegroups.each do |trelunitsizesidegroup|
            trelunitsizesidegroupJson.push({ :id => trelunitsizesidegroup.id, :RADRAT => trelunitsizesidegroup.RADRAT, :SideGroupID => trelunitsizesidegroup.SideGroupID, :SizeID => trelunitsizesidegroup.SizeID, :UnitID => trelunitsizesidegroup.UnitID, :RADRAT => trelunitsizesidegroup.RADRAT })
        end

        return trelunitsizesidegroupJson.to_json

    end

    def self.filter(data)
        trelunitsizesidegroups = self.filterData(data)

        count = trelunitsizesidegroups.length

        page  = data['Trelunitsizesidegroup']['pagination']['page'].to_i
        limit = data['Trelunitsizesidegroup']['pagination']['limit'].to_i
 
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
        trelunitsizesidegroups = trelunitsizesidegroups.slice(offset, limit)

        Array trelunitsizesidegroupJson = Array.new
        trelunitsizesidegroups.each do |trelunitsizesidegroup|
            trelunitsizesidegroupJson.push({ :id => trelunitsizesidegroup.id, :RADRAT => trelunitsizesidegroup.RADRAT, :SideGroupID => trelunitsizesidegroup.SideGroupID, :SizeID => trelunitsizesidegroup.SizeID, :UnitID => trelunitsizesidegroup.UnitID, :RADRAT => trelunitsizesidegroup.RADRAT })
        end

        trelunitsizesidegroupContainer = { :total => count, :trelunitsizesidegroups => trelunitsizesidegroupJson }

        return trelunitsizesidegroupContainer.to_json

    end

    def self.filterData(data)

        trelunitsizesidegroups = []
        if(data.key?("Trelunitsizesidegroup"))
            filters = data['Trelunitsizesidegroup']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelunitsizesidegroups = Trelunitsizesidegroup.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelunitsizesidegroups = trelunitsizesidegroups & Trelunitsizesidegroup.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelunitsizesidegroups
    end

end

