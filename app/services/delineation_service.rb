class DelineationService
  # this service help us to quickly create a new delineation object with datas needed for Cardiologs
  def self.generate_delineations(csv, start_time, date)
    new(csv, start_time, date).generate_delineations
  end

  def initialize(csv, start_time, date)
    @csv = csv
    @start_time = start_time
    @date = date
  end 

  def generate_delineations
    premature_qrs, premature_p = 0, 0
    arr_qrs = []

    # first, we loop over the CSV imported
    CSV.foreach(@csv.path, headers: false) do |row|
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

    # we do all of our calculations
    arr_qrs_diff_waves = get_arr_diff_between_qrs_waves(arr_qrs)
    frequency_per_minute = calculation_frequeny_minute(arr_qrs_diff_waves)
    min_rate = get_min_rate(arr_qrs_diff_waves)
    max_rate = get_max_rate(arr_qrs_diff_waves)
    wave_time_max = get_wave_time_max_heart_rate(arr_qrs, arr_qrs_diff_waves, max_rate)
    wave_time_min = get_wave_time_min_heart_rate(arr_qrs, arr_qrs_diff_waves, min_rate)

    # we create our object that will be called inside the index view
    Delineation.create(
      p_waves: premature_p,
      qrs: premature_qrs,
      mean_rate: frequency_per_minute,
      min_heart_rate: min_rate,
      max_heart_rate: max_rate,
      time_min_rate: wave_time_min,
      time_max_rate: wave_time_max,
      day: @date
    )
  end 
    
  def calculation_frequeny_minute(qrs_diff_waves)
    # this method help us to calculate the frequency per minute (it could pass others diff waves as parameter)
    mean_rate = qrs_diff_waves.sum / qrs_diff_waves.length
    frequency_per_minute = 60 / (mean_rate.to_f / 1000)
    frequency_per_minute
  end 

  def get_min_rate(qrs_diff_waves)
    min_rate = qrs_diff_waves.min
  end 

  def get_max_rate(qrs_diff_waves)
    max_rate = qrs_diff_waves.max
  end 

  def get_wave_time_max_heart_rate(arr_qrs, arr_diff_qrs_waves, rate)
    max_time_ms = arr_qrs[arr_diff_qrs_waves.index(rate)][1]
    wave_time_max = @start_time.to_time + (max_time_ms.to_f / 6000).minutes
    wave_time_max
  end 

  def get_wave_time_min_heart_rate(arr_qrs, arr_diff_qrs_waves, rate)
    min_time_ms = arr_qrs[arr_diff_qrs_waves.index(rate)][1]
    wave_time_min = @start_time.to_time + (min_time_ms.to_f / 6000).minutes
    wave_time_min
  end 

  private 

  def get_arr_diff_between_qrs_waves(qrs_waves)
    # this method is the difference between each wave onset and wave offset
    arr_diff_qrs_waves = qrs_waves.map { |waves| waves[1].to_i - waves[0].to_i }
  end 
end 