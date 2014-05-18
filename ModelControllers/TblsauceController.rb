require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblsauceController
    public
    def self.create(data)
        tblsauce = Tblsauce.create( :IsInternet => data['IsInternet'], :RADRAT => data['RADRAT'], :SauceDescription => data['SauceDescription'], :SauceID => data['SauceID'], :SauceShortDescription => data['SauceShortDescription'], :IsActive => data['IsActive'] )

        tblsauceJson = { :id => tblsauce.id, :IsInternet => tblsauce.IsInternet, :RADRAT => tblsauce.RADRAT, :SauceDescription => tblsauce.SauceDescription, :SauceID => tblsauce.SauceID, :SauceShortDescription => tblsauce.SauceShortDescription, :IsActive => tblsauce.IsActive }

        return tblsauceJson.to_json
    end

    def self.read(data)
        tblsauce = Tblsauce.find(data['id'])

        tblsauceJson = { :id => tblsauce.id, :IsInternet => tblsauce.IsInternet, :RADRAT => tblsauce.RADRAT, :SauceDescription => tblsauce.SauceDescription, :SauceID => tblsauce.SauceID, :SauceShortDescription => tblsauce.SauceShortDescription, :IsActive => tblsauce.IsActive }

        return tblsauceJson.to_json

    end

    def self.update(data)
        tblsauce = Tblsauce.update( data['id'], :IsInternet => data['IsInternet'], :RADRAT => data['RADRAT'], :SauceDescription => data['SauceDescription'], :SauceID => data['SauceID'], :SauceShortDescription => data['SauceShortDescription'], :IsActive => data['IsActive'] )

        tblsauceJson = { :status => status, :id => tblsauce.id, :IsInternet => tblsauce.IsInternet, :RADRAT => tblsauce.RADRAT, :SauceDescription => tblsauce.SauceDescription, :SauceID => tblsauce.SauceID, :SauceShortDescription => tblsauce.SauceShortDescription, :IsActive => tblsauce.IsActive }

        return tblsauceJson.to_json

    end

    def self.delete(data)
        tblsauce = Tblsauce.find(data['id'])
        tblsauce.destroy

        tblsauceJson = { :id => tblsauce.id, :IsInternet => tblsauce.IsInternet, :RADRAT => tblsauce.RADRAT, :SauceDescription => tblsauce.SauceDescription, :SauceID => tblsauce.SauceID, :SauceShortDescription => tblsauce.SauceShortDescription, :IsActive => tblsauce.IsActive }

        return tblsauceJson.to_json

    end

    def self.list(data)
        tblsauces = Tblsauce.all

        Array tblsauceJson = Array.new
        tblsauces.each do |tblsauce|
            tblsauceJson.push({ :id => tblsauce.id, :IsInternet => tblsauce.IsInternet, :RADRAT => tblsauce.RADRAT, :SauceDescription => tblsauce.SauceDescription, :SauceID => tblsauce.SauceID, :SauceShortDescription => tblsauce.SauceShortDescription, :IsActive => tblsauce.IsActive })
        end

        return tblsauceJson.to_json

    end

    def self.filter(data)
        tblsauces = self.filterData(data)

        count = tblsauces.length

        page  = data['Tblsauce']['pagination']['page'].to_i
        limit = data['Tblsauce']['pagination']['limit'].to_i
 
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
        tblsauces = tblsauces.slice(offset, limit)

        Array tblsauceJson = Array.new
        tblsauces.each do |tblsauce|
            tblsauceJson.push({ :id => tblsauce.id, :IsInternet => tblsauce.IsInternet, :RADRAT => tblsauce.RADRAT, :SauceDescription => tblsauce.SauceDescription, :SauceID => tblsauce.SauceID, :SauceShortDescription => tblsauce.SauceShortDescription, :IsActive => tblsauce.IsActive })
        end

        tblsauceContainer = { :total => count, :tblsauces => tblsauceJson }

        return tblsauceContainer.to_json

    end

    def self.filterData(data)

        tblsauces = []
        if(data.key?("Tblsauce"))
            filters = data['Tblsauce']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblsauces = Tblsauce.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblsauces = tblsauces & Tblsauce.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblsauces
    end

end

