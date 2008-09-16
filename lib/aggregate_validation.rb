class AggregateValidation
  def initialize(ver)
    @version = ver
    @emails = { }
  end
  
  def add_email(student, k, em)
    related_column = (k =~ /2_/) ? 'home2_id' : 'home_id'
    home_id = student[related_column]
    if home_id != 0
      ((@emails[em] ||= { })[home_id] ||= []).push([student.id, k, related_column])
    end
  end
  
  def analyze_results
    @emails.each do |em, val|
      if val.size > 1
        val.each do |home_id, arr|
          arr.each do |student_id, k, related_column|
            @version.events.create(:event_type => 'validation',
              :description => 'email address with multiple owners',
              :record_summary => Student.find(student_id).to_s,
              :table_row_type => 'Student', 
              :table_row_id => student_id,
              :table_column => k,
              :table_row_value => em,
              :related_row_type => 'Student', 
              :related_row_id => student_id,
              :related_column => related_column,
              :related_row_value => home_id)
          end
        end
      end
    end
  end
end
