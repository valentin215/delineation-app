class DelineationsController < ApplicationController
    def index
      @delineation_results = Delineation.last
    end 

    def import_csv
      # post method that will calculate create new delineations thanks to the service
      starting_time = params.dig(:csv_import, :time)
      date = params.dig(:csv_import, :date).to_date
      csv = params[:csv_import][:file]

      DelineationService.generate_delineations(csv, starting_time, date)

      redirect_to root_url, notice: "Data imported"
    end 
    
    def export_csv
      # this method is the beginning of the anwser of the bonus question
      # The following steps are what I wanted to do to retrieve cvs datas:
      # 1 - we create a hash with the following structure : { date: { hour: { data: [] } } }
      # 2 - the date is the date picked by the cardiolog, the hour will be 1,2..24 and data will be and an array of arrays. Each array will be a row of csv
      # 3 - we populate the hash during the loop over the csv file
      # 4 - we create a get method with inputs that will send params of date and hours
      # 5 - we retrieve our csv datas passing params as keys 
      # 6 - we transforme our array of arrays into CSV
      # 7 - the user can get his CSV file downloaded with a range of hours
    end

    private 

    def set_params
      params.require(:delineation).permit(:file, :time, :date)
    end 
end
