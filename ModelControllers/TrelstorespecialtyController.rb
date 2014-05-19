require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TrelstorespecialtyController
    public
    def self.create(data)
        trelstorespecialty = Trelstorespecialty.create( :SpecialtyID => data['SpecialtyID'], :StoreID => data['StoreID'] )

        trelstorespecialtyJson = { :id => trelstorespecialty.id, :SpecialtyID => trelstorespecialty.SpecialtyID, :StoreID => trelstorespecialty.StoreID }

        return trelstorespecialtyJson.to_json
    end

    def self.read(data)
        trelstorespecialty = Trelstorespecialty.find(data['id'])

        trelstorespecialtyJson = { :id => trelstorespecialty.id, :SpecialtyID => trelstorespecialty.SpecialtyID, :StoreID => trelstorespecialty.StoreID }

        return trelstorespecialtyJson.to_json

    end

    def self.update(data)
        trelstorespecialty = Trelstorespecialty.update( data['id'], :SpecialtyID => data['SpecialtyID'], :StoreID => data['StoreID'] )

        trelstorespecialtyJson = { :id => trelstorespecialty.id, :SpecialtyID => trelstorespecialty.SpecialtyID, :StoreID => trelstorespecialty.StoreID }

        return trelstorespecialtyJson.to_json

    end

    def self.delete(data)
        trelstorespecialty = Trelstorespecialty.find(data['id'])
        trelstorespecialty.destroy

        trelstorespecialtyJson = { :id => trelstorespecialty.id, :SpecialtyID => trelstorespecialty.SpecialtyID, :StoreID => trelstorespecialty.StoreID }

        return trelstorespecialtyJson.to_json

    end

    def self.list(data)
        trelstorespecialties = Trelstorespecialty.all

        Array trelstorespecialtyJson = Array.new
        trelstorespecialties.each do |trelstorespecialty|
            trelstorespecialtyJson.push({ :id => trelstorespecialty.id, :SpecialtyID => trelstorespecialty.SpecialtyID, :StoreID => trelstorespecialty.StoreID })
        end

        return trelstorespecialtyJson.to_json

    end

    def self.filter(data)
        trelstorespecialties = self.filterData(data)

        count = trelstorespecialties.length

        page  = data['Trelstorespecialty']['pagination']['page'].to_i
        limit = data['Trelstorespecialty']['pagination']['limit'].to_i
 
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
        trelstorespecialties = trelstorespecialties.slice(offset, limit)

        Array trelstorespecialtyJson = Array.new
        trelstorespecialties.each do |trelstorespecialty|
            trelstorespecialtyJson.push({ :id => trelstorespecialty.id, :SpecialtyID => trelstorespecialty.SpecialtyID, :StoreID => trelstorespecialty.StoreID })
        end

        trelstorespecialtyContainer = { :total => count, :trelstorespecialties => trelstorespecialtyJson }

        return trelstorespecialtyContainer.to_json

    end

    def self.filterData(data)

        trelstorespecialties = []
        if(data.key?("Trelstorespecialty"))
            filters = data['Trelstorespecialty']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    trelstorespecialties = Trelstorespecialty.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    trelstorespecialties = trelstorespecialties & Trelstorespecialty.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return trelstorespecialties
    end

end

