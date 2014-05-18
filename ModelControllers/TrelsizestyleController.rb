require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelsizestyleController
    public
    def self.create(data)
        trelsizestyle = Trelsizestyle.create( :SizeID => data['SizeID'], :StyleID => data['StyleID'], :ItemID => data['ItemID'] )

        trelsizestyleJson = { :id => trelsizestyle.id, :SizeID => trelsizestyle.SizeID, :StyleID => trelsizestyle.StyleID, :ItemID => trelsizestyle.ItemID }

        return trelsizestyleJson.to_json
    end

    def self.read(data)
        trelsizestyle = Trelsizestyle.find(data['id'])

        trelsizestyleJson = { :id => trelsizestyle.id, :SizeID => trelsizestyle.SizeID, :StyleID => trelsizestyle.StyleID, :ItemID => trelsizestyle.ItemID }

        return trelsizestyleJson.to_json

    end

    def self.update(data)
        trelsizestyle = Trelsizestyle.update( data['id'], :SizeID => data['SizeID'], :StyleID => data['StyleID'], :ItemID => data['ItemID'] )

        trelsizestyleJson = { :status => status, :id => trelsizestyle.id, :SizeID => trelsizestyle.SizeID, :StyleID => trelsizestyle.StyleID, :ItemID => trelsizestyle.ItemID }

        return trelsizestyleJson.to_json

    end

    def self.delete(data)
        trelsizestyle = Trelsizestyle.find(data['id'])
        trelsizestyle.destroy

        trelsizestyleJson = { :id => trelsizestyle.id, :SizeID => trelsizestyle.SizeID, :StyleID => trelsizestyle.StyleID, :ItemID => trelsizestyle.ItemID }

        return trelsizestyleJson.to_json

    end

    def self.list(data)
        trelsizestyles = Trelsizestyle.all

        Array trelsizestyleJson = Array.new
        trelsizestyles.each do |trelsizestyle|
            trelsizestyleJson.push({ :id => trelsizestyle.id, :SizeID => trelsizestyle.SizeID, :StyleID => trelsizestyle.StyleID, :ItemID => trelsizestyle.ItemID })
        end

        return trelsizestyleJson.to_json

    end

    def self.filter(data)
        trelsizestyles = self.filterData(data)

        count = trelsizestyles.length

        page  = data['Trelsizestyle']['pagination']['page'].to_i
        limit = data['Trelsizestyle']['pagination']['limit'].to_i
 
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
        trelsizestyles = trelsizestyles.slice(offset, limit)

        Array trelsizestyleJson = Array.new
        trelsizestyles.each do |trelsizestyle|
            trelsizestyleJson.push({ :id => trelsizestyle.id, :SizeID => trelsizestyle.SizeID, :StyleID => trelsizestyle.StyleID, :ItemID => trelsizestyle.ItemID })
        end

        trelsizestyleContainer = { :total => count, :trelsizestyles => trelsizestyleJson }

        return trelsizestyleContainer.to_json

    end

    def self.filterData(data)

        trelsizestyles = []
        if(data.key?("Trelsizestyle"))
            filters = data['Trelsizestyle']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelsizestyles = Trelsizestyle.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelsizestyles = trelsizestyles & Trelsizestyle.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelsizestyles
    end

end

