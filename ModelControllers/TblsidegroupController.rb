require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblsidegroupController
    public
    def self.create(data)
        tblsidegroup = Tblsidegroup.create( :RADRAT => data['RADRAT'], :SideGroupDescription => data['SideGroupDescription'], :SideGroupID => data['SideGroupID'], :SideGroupShortDescription => data['SideGroupShortDescription'], :IsActive => data['IsActive'] )

        tblsidegroupJson = { :id => tblsidegroup.id, :RADRAT => tblsidegroup.RADRAT, :SideGroupDescription => tblsidegroup.SideGroupDescription, :SideGroupID => tblsidegroup.SideGroupID, :SideGroupShortDescription => tblsidegroup.SideGroupShortDescription, :IsActive => tblsidegroup.IsActive }

        return tblsidegroupJson.to_json
    end

    def self.read(data)
        tblsidegroup = Tblsidegroup.find(data['id'])

        tblsidegroupJson = { :id => tblsidegroup.id, :RADRAT => tblsidegroup.RADRAT, :SideGroupDescription => tblsidegroup.SideGroupDescription, :SideGroupID => tblsidegroup.SideGroupID, :SideGroupShortDescription => tblsidegroup.SideGroupShortDescription, :IsActive => tblsidegroup.IsActive }

        return tblsidegroupJson.to_json

    end

    def self.update(data)
        tblsidegroup = Tblsidegroup.update( data['id'], :RADRAT => data['RADRAT'], :SideGroupDescription => data['SideGroupDescription'], :SideGroupID => data['SideGroupID'], :SideGroupShortDescription => data['SideGroupShortDescription'], :IsActive => data['IsActive'] )

        tblsidegroupJson = { :id => tblsidegroup.id, :RADRAT => tblsidegroup.RADRAT, :SideGroupDescription => tblsidegroup.SideGroupDescription, :SideGroupID => tblsidegroup.SideGroupID, :SideGroupShortDescription => tblsidegroup.SideGroupShortDescription, :IsActive => tblsidegroup.IsActive }

        return tblsidegroupJson.to_json

    end

    def self.delete(data)
        tblsidegroup = Tblsidegroup.find(data['id'])
        tblsidegroup.destroy

        tblsidegroupJson = { :id => tblsidegroup.id, :RADRAT => tblsidegroup.RADRAT, :SideGroupDescription => tblsidegroup.SideGroupDescription, :SideGroupID => tblsidegroup.SideGroupID, :SideGroupShortDescription => tblsidegroup.SideGroupShortDescription, :IsActive => tblsidegroup.IsActive }

        return tblsidegroupJson.to_json

    end

    def self.list(data)
        tblsidegroups = Tblsidegroup.all

        Array tblsidegroupJson = Array.new
        tblsidegroups.each do |tblsidegroup|
            tblsidegroupJson.push({ :id => tblsidegroup.id, :RADRAT => tblsidegroup.RADRAT, :SideGroupDescription => tblsidegroup.SideGroupDescription, :SideGroupID => tblsidegroup.SideGroupID, :SideGroupShortDescription => tblsidegroup.SideGroupShortDescription, :IsActive => tblsidegroup.IsActive })
        end

        return tblsidegroupJson.to_json

    end

    def self.filter(data)
        tblsidegroups = self.filterData(data)

        count = tblsidegroups.length

        page  = data['Tblsidegroup']['pagination']['page'].to_i
        limit = data['Tblsidegroup']['pagination']['limit'].to_i
 
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
        tblsidegroups = tblsidegroups.slice(offset, limit)

        Array tblsidegroupJson = Array.new
        tblsidegroups.each do |tblsidegroup|
            tblsidegroupJson.push({ :id => tblsidegroup.id, :RADRAT => tblsidegroup.RADRAT, :SideGroupDescription => tblsidegroup.SideGroupDescription, :SideGroupID => tblsidegroup.SideGroupID, :SideGroupShortDescription => tblsidegroup.SideGroupShortDescription, :IsActive => tblsidegroup.IsActive })
        end

        tblsidegroupContainer = { :total => count, :tblsidegroups => tblsidegroupJson }

        return tblsidegroupContainer.to_json

    end

    def self.filterData(data)

        tblsidegroups = []
        if(data.key?("Tblsidegroup"))
            filters = data['Tblsidegroup']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblsidegroups = Tblsidegroup.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblsidegroups = tblsidegroups & Tblsidegroup.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblsidegroups
    end

end

