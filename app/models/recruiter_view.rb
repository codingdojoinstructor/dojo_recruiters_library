class RecruiterView < ActiveRecord::Base
  belongs_to :recruiter
  belongs_to :student

  attr_accessible :recruiter_id, :student_id, :status

  def self.get_total_hours(date, student_id)
      if date.nil?
          records = self.where(:student_id => student_id, :status => 1).order("created_at asc")
      else
          records = self.where(:created_at => date.beginning_of_day..date.end_of_day, :student_id => student_id, :status => 1).order("created_at asc")
      end

      total = 0

      return {:total => total.to_i } if records.length == 0


      records.each do |record|
          total = total + ((record.updated_at.to_time - record.created_at.to_time))
      end

      total_hours = (total/ 3600).to_i
      total_minutes = ((total % 3600) / 60).to_i
      total_seconds = ((total % 3600) % 60).to_i

      total_hours_text = "#{total_hours} hour".pluralize(total_hours)
      total_minutes_text = "#{total_minutes} minute".pluralize(total_minutes)
      total_seconds_text = "#{total_seconds} second".pluralize(total_seconds)


      return {
                :total => total.to_i,
                :total_hours => total_hours,
                :total_hours_text => total_hours_text,
                :total_minutes => total_minutes,
                :total_minutes_text => total_minutes_text,
                :total_seconds => total_seconds,
                :total_seconds_text => total_seconds_text
             }
  end
end
