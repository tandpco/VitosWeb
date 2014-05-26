require 'geometry'
require 'json'

include Geometry

userCoordinate = Point(-83.69410299999998,41.5961917)
stores = JSON::load(File.new('./store-coordinates.json'))

stores.each do |store|
    polyPoints = Array.new
    coordinates = store['coordinates']
    coordinates.each do |coordinate|
        point = Point(coordinate['x'],coordinate['y'])
        polyPoints.push(point)
        # puts point.inspect
    end
    polygon = Polygon.new(polyPoints)

    puts("Searching store #{store['id']}'s boundary")
    if(polygon.contains?(userCoordinate))
        puts("    USER IS WITHIN STORE #{store['id']}'S BOUNDARY")
        break
    end
end

