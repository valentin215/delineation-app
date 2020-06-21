class CreateDelineations < ActiveRecord::Migration[6.0]
  def change
    create_table :delineations do |t|
      t.integer :p_waves
      t.integer :qrs
      t.decimal :mean_rate
      t.integer :min_heart_rate
      t.integer :max_heart_rate
      t.time :time_min_rate
      t.time :time_max_rate
      t.time :start_time
      t.time :end_time
      t.date :day

      t.timestamps
    end
  end
end
