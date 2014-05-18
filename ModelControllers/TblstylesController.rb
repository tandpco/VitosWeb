require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblstylesController
    public
    def self.create(data)
        tblstyles = Tblstyles.create( :RADRAT => data['RADRAT'], :StyleDescription => data['StyleDescription'], :StyleID => data['StyleID'], :StyleShortDescription => data['StyleShortDescription'], :StyleSpecialMessage => data['StyleSpecialMessage'], :IsActive => data['IsActive'] )

        tblstylesJson = { :id => tblstyles.id, :RADRAT => tblstyles.RADRAT, :StyleDescription => tblstyles.StyleDescription, :StyleID => tblstyles.StyleID, :StyleShortDescription => tblstyles.StyleShortDescription, :StyleSpecialMessage => tblstyles.StyleSpecialMessage, :IsActive => tblstyles.IsActive }

        return tblstylesJson.to_json
    end

    def self.read(data)
        tblstyles = Tblstyles.find(data['id'])

        tblstylesJson = { :id => tblstyles.id, :RADRAT => tblstyles.RADRAT, :StyleDescription => tblstyles.StyleDescription, :StyleID => tblstyles.StyleID, :StyleShortDescription => tblstyles.StyleShortDescription, :StyleSpecialMessage => tblstyles.StyleSpecialMessage, :IsActive => tblstyles.IsActive }

        return tblstylesJson.to_json

    end

    def self.update(data)
        tblstyles = Tblstyles.update( data['id'], :RADRAT => data['RADRAT'], :StyleDescription => data['StyleDescription'], :StyleID => data['StyleID'], :StyleShortDescription => data['StyleShortDescription'], :StyleSpecialMessage => data['StyleSpecialMessage'], :IsActive => data['IsActive'] )

        tblstylesJson = { :status => status, :id => tblstyles.id, :RADRAT => tblstyles.RADRAT, :StyleDescription => tblstyles.StyleDescription, :StyleID => tblstyles.StyleID, :StyleShortDescription => tblstyles.StyleShortDescription, :StyleSpecialMessage => tblstyles.StyleSpecialMessage, :IsActive => tblstyles.IsActive }

        return tblstylesJson.to_json

    end

    def self.delete(data)
        tblstyles = Tblstyles.find(data['id'])
        tblstyles.destroy

        tblstylesJson = { :id => tblstyles.id, :RADRAT => tblstyles.RADRAT, :StyleDescription => tblstyles.StyleDescription, :StyleID => tblstyles.StyleID, :StyleShortDescription => tblstyles.StyleShortDescription, :StyleSpecialMessage => tblstyles.StyleSpecialMessage, :IsActive => tblstyles.IsActive }

        return tblstylesJson.to_json

    end

    def self.list(data)
        tblstyles = Tblstyles.all

        Array tblstylesJson = Array.new
        tblstyles.each do |tblstyles|
            tblstylesJson.push({ :id => tblstyles.id, :RADRAT => tblstyles.RADRAT, :StyleDescription => tblstyles.StyleDescription, :StyleID => tblstyles.StyleID, :StyleShortDescription => tblstyles.StyleShortDescription, :StyleSpecialMessage => tblstyles.StyleSpecialMessage, :IsActive => tblstyles.IsActive })
        end

        return tblstylesJson.to_json

    end

    def self.filter(data)
        tblstyles = self.filterData(data)

        count = tblstyles.length

        page  = data['Tblstyles']['pagination']['page'].to_i
        limit = data['Tblstyles']['pagination']['limit'].to_i
 
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
        tblstyles = tblstyles.slice(offset, limit)

        Array tblstylesJson = Array.new
        tblstyles.each do |tblstyles|
            tblstylesJson.push({ :id => tblstyles.id, :RADRAT => tblstyles.RADRAT, :StyleDescription => tblstyles.StyleDescription, :StyleID => tblstyles.StyleID, :StyleShortDescription => tblstyles.StyleShortDescription, :StyleSpecialMessage => tblstyles.StyleSpecialMessage, :IsActive => tblstyles.IsActive })
        end

        tblstylesContainer = { :total => count, :tblstyles => tblstylesJson }

        return tblstylesContainer.to_json

    end

    def self.filterData(data)

        tblstyles = []
        if(data.key?("Tblstyles"))
            filters = data['Tblstyles']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblstyles = Tblstyles.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblstyles = tblstyles & Tblstyles.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblstyles
    end

end

