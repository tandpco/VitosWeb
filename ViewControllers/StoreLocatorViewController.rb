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
        
            if(polyPoints.count > 0)
                if(polygon.contains?(userCoordinate))
                    # puts("User is within store #{store['id']}'s boundary")
                    returnData['StoreID'] = store['id']
                    returnData['Message'] = 'The nearest store to your current location is ' + store['id'].to_s + '.'
                    break
                end
            end
        end
        if(returnData['StoreID'].to_i < 1)
            result = findDistanceToNearestStore(data)
            returnData = result
        end
        return returnData.to_json
    end
    
     def self.findDistanceToNearestStore(data)
        x_client = data['x'].to_f
        y_client = data['y'].to_f
        returnValue = Hash.new()
        $stores = JSON::load(File.open("./JSON-DATA/store-coordinates.json"))
        minDistance = 1000000
        closestStoreId = -1
        distance = ''
        
        $stores.each do |store| 
            #puts(store)
            x_store = store['location']['x'].to_f
            y_store = store['location']['y'].to_f
            
            distance = getDistanceFromLatLon(x_client, y_client, x_store, y_store)
            if(distance < minDistance)
                closestStoreId = store['id']
                minDistance = distance
            end
        end
        if(minDistance > 50)
            if(returnValue['StoreID'].to_i < 1)
                returnValue['StoreID'] = "1"
                returnValue['Message'] = 'No stores found'
            else
                returnValue['StoreID'] = closestStoreId.to_s
                returnValue['Message'] = 'No Stores within 25 miles of your location. Store ' + closestStoreId.to_s + ' is ' + minDistance.to_s + ' miles away from your current location.'
            end
        else
            returnValue['StoreID'] = closestStoreId.to_s
            returnValue['Message'] = 'Is ' + minDistance.to_s + ' miles away from your location.'
        end
        #puts(returnValue)
        return returnValue
    end
    
    def self.getDistanceFromLatLon(x_client, y_client, x_store, y_store)
        r = 3963.1676 # Radius of the earth in miles
        radLat1 = deg2rad(y_client)
        radLat2 = deg2rad(y_store)
        radDiffLat = deg2rad(y_store - y_client)
        radDifLon  = deg2rad(x_store - x_client)

        a = Math::sin(radDiffLat/2) * Math::sin(radDiffLat/2)
        a += Math::cos(radLat1) * Math::cos(radLat2) * Math::sin(radDifLon/2) * Math::sin(radDifLon/2)
        c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
        d = r * c
        return d
    end
    
    def self.deg2rad(deg) 
        return deg * (Math::PI/180)
    end
    
end
