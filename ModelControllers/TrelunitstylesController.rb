require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelunitstylesController
    public
    def self.create(data)
        trelunitstyles = Trelunitstyles.create( :StyleID => data['StyleID'], :UnitID => data['UnitID'], :IsBeforeItems => data['IsBeforeItems'] )

        trelunitstylesJson = { :id => trelunitstyles.id, :StyleID => trelunitstyles.StyleID, :UnitID => trelunitstyles.UnitID, :IsBeforeItems => trelunitstyles.IsBeforeItems }

        return trelunitstylesJson.to_json
    end

    def self.read(data)
        trelunitstyles = Trelunitstyles.find(data['id'])

        trelunitstylesJson = { :id => trelunitstyles.id, :StyleID => trelunitstyles.StyleID, :UnitID => trelunitstyles.UnitID, :IsBeforeItems => trelunitstyles.IsBeforeItems }

        return trelunitstylesJson.to_json

    end

    def self.update(data)
        trelunitstyles = Trelunitstyles.update( data['id'], :StyleID => data['StyleID'], :UnitID => data['UnitID'], :IsBeforeItems => data['IsBeforeItems'] )

        trelunitstylesJson = { :status => status, :id => trelunitstyles.id, :StyleID => trelunitstyles.StyleID, :UnitID => trelunitstyles.UnitID, :IsBeforeItems => trelunitstyles.IsBeforeItems }

        return trelunitstylesJson.to_json

    end

    def self.delete(data)
        trelunitstyles = Trelunitstyles.find(data['id'])
        trelunitstyles.destroy

        trelunitstylesJson = { :id => trelunitstyles.id, :StyleID => trelunitstyles.StyleID, :UnitID => trelunitstyles.UnitID, :IsBeforeItems => trelunitstyles.IsBeforeItems }

        return trelunitstylesJson.to_json

    end

    def self.list(data)
        trelunitstyles = Trelunitstyles.all

        Array trelunitstylesJson = Array.new
        trelunitstyles.each do |trelunitstyles|
            trelunitstylesJson.push({ :id => trelunitstyles.id, :StyleID => trelunitstyles.StyleID, :UnitID => trelunitstyles.UnitID, :IsBeforeItems => trelunitstyles.IsBeforeItems })
        end

        return trelunitstylesJson.to_json

    end

    def self.filter(data)
        trelunitstyles = self.filterData(data)

        count = trelunitstyles.length

        page  = data['Trelunitstyles']['pagination']['page'].to_i
        limit = data['Trelunitstyles']['pagination']['limit'].to_i
 
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
        trelunitstyles = trelunitstyles.slice(offset, limit)

        Array trelunitstylesJson = Array.new
        trelunitstyles.each do |trelunitstyles|
            trelunitstylesJson.push({ :id => trelunitstyles.id, :StyleID => trelunitstyles.StyleID, :UnitID => trelunitstyles.UnitID, :IsBeforeItems => trelunitstyles.IsBeforeItems })
        end

        trelunitstylesContainer = { :total => count, :trelunitstyles => trelunitstylesJson }

        return trelunitstylesContainer.to_json

    end

    def self.filterData(data)

        trelunitstyles = []
        if(data.key?("Trelunitstyles"))
            filters = data['Trelunitstyles']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelunitstyles = Trelunitstyles.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelunitstyles = trelunitstyles & Trelunitstyles.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelunitstyles
    end

end

