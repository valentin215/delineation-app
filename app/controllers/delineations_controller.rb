class DelineationsController < ApplicationController
    def index
      @imported_results = Delineation.last
    end 

    def import_csv
      arr_qrs, arr_diff_qrs_waves, max_rate, min_rate = [], [], [], []
      max_time_ms, min_time_ms, premature_qrs, premature_p = 0, 0, 0, 0
      time = params.dig(:csv_import, :time)
      date = params.dig(:csv_import, :date).to_date

      CSV.foreach(params[:csv_import][:file].path, headers: false) do |row|
        next if row[0] == 'INV' || row[0] == 'T'
        if row[0] == 'QRS'
          arr_qrs << [row[1], row[2]]
          if row[3] == 'premature' || row[4] == 'premature'
            premature_qrs += 1
          end 
        elsif row[0] == 'P' && (row[3] == 'premature' || row[4] == 'premature')
          premature_p += 1
        end 
      end 

      arr_diff_qrs_waves = arr_qrs.map { |waves| waves[1].to_i - waves[0].to_i }
      mean_rate = arr_diff_qrs_waves.sum / arr_diff_qrs_waves.length
      frequency_per_minute = 60 / (mean_rate.to_f / 1000)

      min_rate = arr_diff_qrs_waves.min
      max_rate = arr_diff_qrs_waves.max

      max_time_ms = arr_qrs[arr_diff_qrs_waves.index(max_rate)][1]
      min_time_ms = arr_qrs[arr_diff_qrs_waves.index(min_rate)][1]

      wave_time_max = time.to_time + (max_time_ms.to_f / 6000).minutes
      wave_time_min = time.to_time + (min_time_ms.to_f / 6000).minutes

      Delineation.create(
        p_waves: premature_p,
        qrs: premature_qrs,
        mean_rate: frequency_per_minute,
        min_heart_rate: min_rate,
        max_heart_rate: max_rate,
        time_min_rate: wave_time_min,
        time_max_rate: wave_time_max,
        day: date
      )

      redirect_to root_url, notice: "Data imported"
    end 
    
    def export_csv;end

    private 

    def set_params
      params.require(:delineation).permit(:file, :time, :date)
    end 
end
