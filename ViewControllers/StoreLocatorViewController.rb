require 'sinatra'
require 'json'
require 'geometry'

include Geometry

Dir["../ModelControllers/*.rb"].sort.each do |file|
    file.sub!(".rb","");
    require file
end

Dir["../Models/*.rb"].sort.each do |file|
    file.sub!(".rb","");
    require file
end


class StoreLocatorViewController
    public

    def self.findStore(data)
        x = data['x'].to_f
        y = data['y'].to_f

        userCoordinate = Point(x,y)
        
        returnData = Hash.new
        $stores.each do |store|
            polyPoints = Array.new
            coordinates = store['coordinates']
            coordinates.each do |coordinate|
                point = Point(coordinate['x'],coordinate['y'])
                polyPoints.push(point)
                # puts point.inspect
            end
            polygon = Polygon.new(polyPoints)
        
            if(polygon.contains?(userCoordinate))
                # puts("User is within store #{store['id']}'s boundary")
                returnData['StoreID'] = store['id']
                break
            end
        end

        return returnData.to_json
    end
end
