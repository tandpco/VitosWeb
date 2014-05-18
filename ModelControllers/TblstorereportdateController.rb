require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class TblstorereportdateController
    public
    def self.create(data)
        tblstorereportdate = Tblstorereportdate.create( :BatchRefNumber => data['BatchRefNumber'], :BatchTotal => data['BatchTotal'], :CurrentStatus => data['CurrentStatus'], :RADRAT => data['RADRAT'], :ReportDate => data['ReportDate'], :StoreID => data['StoreID'], :StoreReportID => data['StoreReportID'], :Address1 => data['Address1'] )

        tblstorereportdateJson = { :id => tblstorereportdate.id, :BatchRefNumber => tblstorereportdate.BatchRefNumber, :BatchTotal => tblstorereportdate.BatchTotal, :CurrentStatus => tblstorereportdate.CurrentStatus, :RADRAT => tblstorereportdate.RADRAT, :ReportDate => tblstorereportdate.ReportDate, :StoreID => tblstorereportdate.StoreID, :StoreReportID => tblstorereportdate.StoreReportID, :Address1 => tblstorereportdate.Address1 }

        return tblstorereportdateJson.to_json
    end

    def self.read(data)
        tblstorereportdate = Tblstorereportdate.find(data['id'])

        tblstorereportdateJson = { :id => tblstorereportdate.id, :BatchRefNumber => tblstorereportdate.BatchRefNumber, :BatchTotal => tblstorereportdate.BatchTotal, :CurrentStatus => tblstorereportdate.CurrentStatus, :RADRAT => tblstorereportdate.RADRAT, :ReportDate => tblstorereportdate.ReportDate, :StoreID => tblstorereportdate.StoreID, :StoreReportID => tblstorereportdate.StoreReportID, :Address1 => tblstorereportdate.Address1 }

        return tblstorereportdateJson.to_json

    end

    def self.update(data)
        tblstorereportdate = Tblstorereportdate.update( data['id'], :BatchRefNumber => data['BatchRefNumber'], :BatchTotal => data['BatchTotal'], :CurrentStatus => data['CurrentStatus'], :RADRAT => data['RADRAT'], :ReportDate => data['ReportDate'], :StoreID => data['StoreID'], :StoreReportID => data['StoreReportID'], :Address1 => data['Address1'] )

        tblstorereportdateJson = { :status => status, :id => tblstorereportdate.id, :BatchRefNumber => tblstorereportdate.BatchRefNumber, :BatchTotal => tblstorereportdate.BatchTotal, :CurrentStatus => tblstorereportdate.CurrentStatus, :RADRAT => tblstorereportdate.RADRAT, :ReportDate => tblstorereportdate.ReportDate, :StoreID => tblstorereportdate.StoreID, :StoreReportID => tblstorereportdate.StoreReportID, :Address1 => tblstorereportdate.Address1 }

        return tblstorereportdateJson.to_json

    end

    def self.delete(data)
        tblstorereportdate = Tblstorereportdate.find(data['id'])
        tblstorereportdate.destroy

        tblstorereportdateJson = { :id => tblstorereportdate.id, :BatchRefNumber => tblstorereportdate.BatchRefNumber, :BatchTotal => tblstorereportdate.BatchTotal, :CurrentStatus => tblstorereportdate.CurrentStatus, :RADRAT => tblstorereportdate.RADRAT, :ReportDate => tblstorereportdate.ReportDate, :StoreID => tblstorereportdate.StoreID, :StoreReportID => tblstorereportdate.StoreReportID, :Address1 => tblstorereportdate.Address1 }

        return tblstorereportdateJson.to_json

    end

    def self.list(data)
        tblstorereportdates = Tblstorereportdate.all

        Array tblstorereportdateJson = Array.new
        tblstorereportdates.each do |tblstorereportdate|
            tblstorereportdateJson.push({ :id => tblstorereportdate.id, :BatchRefNumber => tblstorereportdate.BatchRefNumber, :BatchTotal => tblstorereportdate.BatchTotal, :CurrentStatus => tblstorereportdate.CurrentStatus, :RADRAT => tblstorereportdate.RADRAT, :ReportDate => tblstorereportdate.ReportDate, :StoreID => tblstorereportdate.StoreID, :StoreReportID => tblstorereportdate.StoreReportID, :Address1 => tblstorereportdate.Address1 })
        end

        return tblstorereportdateJson.to_json

    end

    def self.filter(data)
        tblstorereportdates = self.filterData(data)

        count = tblstorereportdates.length

        page  = data['Tblstorereportdate']['pagination']['page'].to_i
        limit = data['Tblstorereportdate']['pagination']['limit'].to_i
 
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
        tblstorereportdates = tblstorereportdates.slice(offset, limit)

        Array tblstorereportdateJson = Array.new
        tblstorereportdates.each do |tblstorereportdate|
            tblstorereportdateJson.push({ :id => tblstorereportdate.id, :BatchRefNumber => tblstorereportdate.BatchRefNumber, :BatchTotal => tblstorereportdate.BatchTotal, :CurrentStatus => tblstorereportdate.CurrentStatus, :RADRAT => tblstorereportdate.RADRAT, :ReportDate => tblstorereportdate.ReportDate, :StoreID => tblstorereportdate.StoreID, :StoreReportID => tblstorereportdate.StoreReportID, :Address1 => tblstorereportdate.Address1 })
        end

        tblstorereportdateContainer = { :total => count, :tblstorereportdates => tblstorereportdateJson }

        return tblstorereportdateContainer.to_json

    end

    def self.filterData(data)

        tblstorereportdates = []
        if(data.key?("Tblstorereportdate"))
            filters = data['Tblstorereportdate']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    tblstorereportdates = Tblstorereportdate.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    tblstorereportdates = tblstorereportdates & Tblstorereportdate.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return tblstorereportdates
    end

end

