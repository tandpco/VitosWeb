require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelstoresizestyleController
    public
    def self.create(data)
        trelstoresizestyle = Trelstoresizestyle.create( :SizeID => data['SizeID'], :StoreID => data['StoreID'], :StyleID => data['StyleID'], :StyleSurcharge => data['StyleSurcharge'], :RADRAT => data['RADRAT'] )

        trelstoresizestyleJson = { :id => trelstoresizestyle.id, :SizeID => trelstoresizestyle.SizeID, :StoreID => trelstoresizestyle.StoreID, :StyleID => trelstoresizestyle.StyleID, :StyleSurcharge => trelstoresizestyle.StyleSurcharge, :RADRAT => trelstoresizestyle.RADRAT }

        return trelstoresizestyleJson.to_json
    end

    def self.read(data)
        trelstoresizestyle = Trelstoresizestyle.find(data['id'])

        trelstoresizestyleJson = { :id => trelstoresizestyle.id, :SizeID => trelstoresizestyle.SizeID, :StoreID => trelstoresizestyle.StoreID, :StyleID => trelstoresizestyle.StyleID, :StyleSurcharge => trelstoresizestyle.StyleSurcharge, :RADRAT => trelstoresizestyle.RADRAT }

        return trelstoresizestyleJson.to_json

    end

    def self.update(data)
        trelstoresizestyle = Trelstoresizestyle.update( data['id'], :SizeID => data['SizeID'], :StoreID => data['StoreID'], :StyleID => data['StyleID'], :StyleSurcharge => data['StyleSurcharge'], :RADRAT => data['RADRAT'] )

        trelstoresizestyleJson = { :status => status, :id => trelstoresizestyle.id, :SizeID => trelstoresizestyle.SizeID, :StoreID => trelstoresizestyle.StoreID, :StyleID => trelstoresizestyle.StyleID, :StyleSurcharge => trelstoresizestyle.StyleSurcharge, :RADRAT => trelstoresizestyle.RADRAT }

        return trelstoresizestyleJson.to_json

    end

    def self.delete(data)
        trelstoresizestyle = Trelstoresizestyle.find(data['id'])
        trelstoresizestyle.destroy

        trelstoresizestyleJson = { :id => trelstoresizestyle.id, :SizeID => trelstoresizestyle.SizeID, :StoreID => trelstoresizestyle.StoreID, :StyleID => trelstoresizestyle.StyleID, :StyleSurcharge => trelstoresizestyle.StyleSurcharge, :RADRAT => trelstoresizestyle.RADRAT }

        return trelstoresizestyleJson.to_json

    end

    def self.list(data)
        trelstoresizestyles = Trelstoresizestyle.all

        Array trelstoresizestyleJson = Array.new
        trelstoresizestyles.each do |trelstoresizestyle|
            trelstoresizestyleJson.push({ :id => trelstoresizestyle.id, :SizeID => trelstoresizestyle.SizeID, :StoreID => trelstoresizestyle.StoreID, :StyleID => trelstoresizestyle.StyleID, :StyleSurcharge => trelstoresizestyle.StyleSurcharge, :RADRAT => trelstoresizestyle.RADRAT })
        end

        return trelstoresizestyleJson.to_json

    end

    def self.filter(data)
        trelstoresizestyles = self.filterData(data)

        count = trelstoresizestyles.length

        page  = data['Trelstoresizestyle']['pagination']['page'].to_i
        limit = data['Trelstoresizestyle']['pagination']['limit'].to_i
 
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
        trelstoresizestyles = trelstoresizestyles.slice(offset, limit)

        Array trelstoresizestyleJson = Array.new
        trelstoresizestyles.each do |trelstoresizestyle|
            trelstoresizestyleJson.push({ :id => trelstoresizestyle.id, :SizeID => trelstoresizestyle.SizeID, :StoreID => trelstoresizestyle.StoreID, :StyleID => trelstoresizestyle.StyleID, :StyleSurcharge => trelstoresizestyle.StyleSurcharge, :RADRAT => trelstoresizestyle.RADRAT })
        end

        trelstoresizestyleContainer = { :total => count, :trelstoresizestyles => trelstoresizestyleJson }

        return trelstoresizestyleContainer.to_json

    end

    def self.filterData(data)

        trelstoresizestyles = []
        if(data.key?("Trelstoresizestyle"))
            filters = data['Trelstoresizestyle']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelstoresizestyles = Trelstoresizestyle.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelstoresizestyles = trelstoresizestyles & Trelstoresizestyle.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelstoresizestyles
    end

end

