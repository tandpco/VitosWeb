require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblitemsController
    public
    def self.create(data)
        tblitems = Tblitems.create( :IsInternet => data['IsInternet'], :ItemDescription => data['ItemDescription'], :ItemID => data['ItemID'], :ItemShortDescription => data['ItemShortDescription'], :ItemSortOrder => data['ItemSortOrder'], :RADRAT => data['RADRAT'], :EndDate => data['EndDate'] )

        tblitemsJson = { :id => tblitems.id, :IsInternet => tblitems.IsInternet, :ItemDescription => tblitems.ItemDescription, :ItemID => tblitems.ItemID, :ItemShortDescription => tblitems.ItemShortDescription, :ItemSortOrder => tblitems.ItemSortOrder, :RADRAT => tblitems.RADRAT, :EndDate => tblitems.EndDate }

        return tblitemsJson.to_json
    end

    def self.read(data)
        tblitems = Tblitems.find(data['id'])

        tblitemsJson = { :id => tblitems.id, :IsInternet => tblitems.IsInternet, :ItemDescription => tblitems.ItemDescription, :ItemID => tblitems.ItemID, :ItemShortDescription => tblitems.ItemShortDescription, :ItemSortOrder => tblitems.ItemSortOrder, :RADRAT => tblitems.RADRAT, :EndDate => tblitems.EndDate }

        return tblitemsJson.to_json

    end

    def self.update(data)
        tblitems = Tblitems.update( data['id'], :IsInternet => data['IsInternet'], :ItemDescription => data['ItemDescription'], :ItemID => data['ItemID'], :ItemShortDescription => data['ItemShortDescription'], :ItemSortOrder => data['ItemSortOrder'], :RADRAT => data['RADRAT'], :EndDate => data['EndDate'] )

        tblitemsJson = { :status => status, :id => tblitems.id, :IsInternet => tblitems.IsInternet, :ItemDescription => tblitems.ItemDescription, :ItemID => tblitems.ItemID, :ItemShortDescription => tblitems.ItemShortDescription, :ItemSortOrder => tblitems.ItemSortOrder, :RADRAT => tblitems.RADRAT, :EndDate => tblitems.EndDate }

        return tblitemsJson.to_json

    end

    def self.delete(data)
        tblitems = Tblitems.find(data['id'])
        tblitems.destroy

        tblitemsJson = { :id => tblitems.id, :IsInternet => tblitems.IsInternet, :ItemDescription => tblitems.ItemDescription, :ItemID => tblitems.ItemID, :ItemShortDescription => tblitems.ItemShortDescription, :ItemSortOrder => tblitems.ItemSortOrder, :RADRAT => tblitems.RADRAT, :EndDate => tblitems.EndDate }

        return tblitemsJson.to_json

    end

    def self.list(data)
        tblitems = Tblitems.all

        Array tblitemsJson = Array.new
        tblitems.each do |tblitems|
            tblitemsJson.push({ :id => tblitems.id, :IsInternet => tblitems.IsInternet, :ItemDescription => tblitems.ItemDescription, :ItemID => tblitems.ItemID, :ItemShortDescription => tblitems.ItemShortDescription, :ItemSortOrder => tblitems.ItemSortOrder, :RADRAT => tblitems.RADRAT, :EndDate => tblitems.EndDate })
        end

        return tblitemsJson.to_json

    end

    def self.filter(data)
        tblitems = self.filterData(data)

        count = tblitems.length

        page  = data['Tblitems']['pagination']['page'].to_i
        limit = data['Tblitems']['pagination']['limit'].to_i
 
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
        tblitems = tblitems.slice(offset, limit)

        Array tblitemsJson = Array.new
        tblitems.each do |tblitems|
            tblitemsJson.push({ :id => tblitems.id, :IsInternet => tblitems.IsInternet, :ItemDescription => tblitems.ItemDescription, :ItemID => tblitems.ItemID, :ItemShortDescription => tblitems.ItemShortDescription, :ItemSortOrder => tblitems.ItemSortOrder, :RADRAT => tblitems.RADRAT, :EndDate => tblitems.EndDate })
        end

        tblitemsContainer = { :total => count, :tblitems => tblitemsJson }

        return tblitemsContainer.to_json

    end

    def self.filterData(data)

        tblitems = []
        if(data.key?("Tblitems"))
            filters = data['Tblitems']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblitems = Tblitems.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblitems = tblitems & Tblitems.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblitems
    end

end

