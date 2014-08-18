require 'sinatra'
require 'json'
require 'securerandom'

class SessionViewController
    public

    def self.createSession(data)
        # Probably fine for now, but need to add timestamp to uuid()
        sessionId = SecureRandom.uuid()
        $session[sessionId] = Hash.new()

        returnData = Hash.new()
        returnData["sessionId"] = sessionId
        return returnData.to_json
    end

    def self.get(data)
        sessionId = data['sessionId']
        key       = data['key']
    
        returnData = Hash.new()
        returnData[key] = $session[sessionId][key]
    
        return returnData.to_json

    end

    def self.set(data)
        sessionId = data['sessionId']
        key       = data['key'].to_s
        value     = data['value'].to_s
    
        $session[sessionId][key] = value
    
        returnData = Hash.new()
        returnData[key] = $session[sessionId][key]
        return returnData.to_json
    end
    
end
