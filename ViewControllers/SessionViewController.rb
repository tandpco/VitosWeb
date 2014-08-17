require 'sinatra'
require 'json'

class SessionViewController
    public

    def self.createSession(data)
        id        = 1
        sessionId = id.to_s
        $session[sessionId] = Hash.new()

        returnData = Hash.new()
        returnData["sessionId"] = sessionId
        return returnData.to_json
    end

    def self.get(data)
        #sessionId = data['sessionId']
        sessionId = "1"
        key       = data['key']
    
        returnData = Hash.new()
        returnData[key] = $session[sessionId][key]
    
        return returnData.to_json

    end

    def self.set(data)
        #sessionId = data['sessionId']
        sessionId = "1"
        key       = data['key'].to_s
        value     = data['value'].to_s
    
        $session[sessionId][key] = value
    
        returnData = Hash.new()
        returnData[key] = $session[sessionId][key]
        return returnData.to_json
    end
    
end
