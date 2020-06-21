class DelineationsController < ApplicationController
    def index
      @imported_delineation = Delineation.last
    end 

    def import_csv
      arr_qrs, max_rate, min_rate, results = []
      premature_qrs, premature_p = 0
      time = params[:time]
      date = params[:date].to_date
      CSV.foreach(params[:file].path, headers: false) do |row|
        next if row[0] == 'INV' || 'T'
        if row[0] == 'QRS'
          arr_qrs << [row[2], row[1]]
          if row[3] == 'premature' || row[4] == 'premature'
            premature_qrs += 1
          end 
        elsif row[0] == 'P' && (row[3] == 'premature' || row[4] == 'premature')
          premature_p += 1
        end 
      end 
      # mean_rate = (arr_qrs.sum) / arr_qrs.length
      # # caculation of rate 
      # min_rate = arr_qrs.min_by?
      # # calculation of rate and then calculate the hour of it 
      # max_rate = arr_qrs.max_by?
      # Delineation.import(results)
      raise
      redirect_to root_url, notice: "Data imported"
    end 
    
    def export_csv;end
end
