require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblsaucemodifierController
    public
    def self.create(data)
        tblsaucemodifier = Tblsaucemodifier.create( :RADRAT => data['RADRAT'], :SauceModifierDescription => data['SauceModifierDescription'], :SauceModifierID => data['SauceModifierID'], :SauceModifierShortDescription => data['SauceModifierShortDescription'], :IsActive => data['IsActive'] )

        tblsaucemodifierJson = { :id => tblsaucemodifier.id, :RADRAT => tblsaucemodifier.RADRAT, :SauceModifierDescription => tblsaucemodifier.SauceModifierDescription, :SauceModifierID => tblsaucemodifier.SauceModifierID, :SauceModifierShortDescription => tblsaucemodifier.SauceModifierShortDescription, :IsActive => tblsaucemodifier.IsActive }

        return tblsaucemodifierJson.to_json
    end

    def self.read(data)
        tblsaucemodifier = Tblsaucemodifier.find(data['id'])

        tblsaucemodifierJson = { :id => tblsaucemodifier.id, :RADRAT => tblsaucemodifier.RADRAT, :SauceModifierDescription => tblsaucemodifier.SauceModifierDescription, :SauceModifierID => tblsaucemodifier.SauceModifierID, :SauceModifierShortDescription => tblsaucemodifier.SauceModifierShortDescription, :IsActive => tblsaucemodifier.IsActive }

        return tblsaucemodifierJson.to_json

    end

    def self.update(data)
        tblsaucemodifier = Tblsaucemodifier.update( data['id'], :RADRAT => data['RADRAT'], :SauceModifierDescription => data['SauceModifierDescription'], :SauceModifierID => data['SauceModifierID'], :SauceModifierShortDescription => data['SauceModifierShortDescription'], :IsActive => data['IsActive'] )

        tblsaucemodifierJson = { :id => tblsaucemodifier.id, :RADRAT => tblsaucemodifier.RADRAT, :SauceModifierDescription => tblsaucemodifier.SauceModifierDescription, :SauceModifierID => tblsaucemodifier.SauceModifierID, :SauceModifierShortDescription => tblsaucemodifier.SauceModifierShortDescription, :IsActive => tblsaucemodifier.IsActive }

        return tblsaucemodifierJson.to_json

    end

    def self.delete(data)
        tblsaucemodifier = Tblsaucemodifier.find(data['id'])
        tblsaucemodifier.destroy

        tblsaucemodifierJson = { :id => tblsaucemodifier.id, :RADRAT => tblsaucemodifier.RADRAT, :SauceModifierDescription => tblsaucemodifier.SauceModifierDescription, :SauceModifierID => tblsaucemodifier.SauceModifierID, :SauceModifierShortDescription => tblsaucemodifier.SauceModifierShortDescription, :IsActive => tblsaucemodifier.IsActive }

        return tblsaucemodifierJson.to_json

    end

    def self.list(data)
        tblsaucemodifiers = Tblsaucemodifier.all

        Array tblsaucemodifierJson = Array.new
        tblsaucemodifiers.each do |tblsaucemodifier|
            tblsaucemodifierJson.push({ :id => tblsaucemodifier.id, :RADRAT => tblsaucemodifier.RADRAT, :SauceModifierDescription => tblsaucemodifier.SauceModifierDescription, :SauceModifierID => tblsaucemodifier.SauceModifierID, :SauceModifierShortDescription => tblsaucemodifier.SauceModifierShortDescription, :IsActive => tblsaucemodifier.IsActive })
        end

        return tblsaucemodifierJson.to_json

    end

    def self.filter(data)
        tblsaucemodifiers = self.filterData(data)

        count = tblsaucemodifiers.length

        page  = data['Tblsaucemodifier']['pagination']['page'].to_i
        limit = data['Tblsaucemodifier']['pagination']['limit'].to_i
 
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
        tblsaucemodifiers = tblsaucemodifiers.slice(offset, limit)

        Array tblsaucemodifierJson = Array.new
        tblsaucemodifiers.each do |tblsaucemodifier|
            tblsaucemodifierJson.push({ :id => tblsaucemodifier.id, :RADRAT => tblsaucemodifier.RADRAT, :SauceModifierDescription => tblsaucemodifier.SauceModifierDescription, :SauceModifierID => tblsaucemodifier.SauceModifierID, :SauceModifierShortDescription => tblsaucemodifier.SauceModifierShortDescription, :IsActive => tblsaucemodifier.IsActive })
        end

        tblsaucemodifierContainer = { :total => count, :tblsaucemodifiers => tblsaucemodifierJson }

        return tblsaucemodifierContainer.to_json

    end

    def self.filterData(data)

        tblsaucemodifiers = []
        if(data.key?("Tblsaucemodifier"))
            filters = data['Tblsaucemodifier']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblsaucemodifiers = Tblsaucemodifier.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblsaucemodifiers = tblsaucemodifiers & Tblsaucemodifier.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblsaucemodifiers
    end

end

