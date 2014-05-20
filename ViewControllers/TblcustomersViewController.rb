require 'sinatra'
require 'json'
require 'data_mapper'

Dir["../ModelControllers/*.rb"].sort.each do |file|
    file.sub!(".rb","");
    require file
end

Dir["../Models/*.rb"].sort.each do |file|
    file.sub!(".rb","");
    require file
end


class TblcustomersViewController
    public

    def self.getTblcustomers(data)
        tblcustomers = Tblcustomers.filter(data)

        return tblcustomers.to_json
    end
end
