class BulletPoint < ApplicationRecord
  belongs_to :bullet_pointable, polymorphic: true

  validates :body, presence: true
  validates :bullet_pointable, presence: true

  scope :ordered, -> { order(:position, :created_at) }
  scope :for_bullet_pointable, ->(bullet_pointable_type, bullet_pointable_id) { 
    where(bullet_pointable_type: bullet_pointable_type, bullet_pointable_id: bullet_pointable_id) 
  }

  before_create :set_position

  def self.wizard(bullet_pointable_type, bullet_pointable_id, prompt)
    begin
      bullet_pointable_class = bullet_pointable_type.constantize
      bullet_pointable = bullet_pointable_class.find(bullet_pointable_id)
      
      # Build content for the prompt
      content = bullet_pointable.title
      if bullet_pointable.respond_to?(:body) && bullet_pointable.body.present?
        content += "\n\n#{bullet_pointable.body}"
      elsif bullet_pointable.respond_to?(:summary) && bullet_pointable.summary.present?
        content += "\n\n#{bullet_pointable.summary}"
      end
      
      if prompt.present?
        prompt = "Generate as many bullet points as needed, each should be a different aspect or key point. Return as JSON array: [{\"body\": \"Point 1\"}, {\"body\": \"Point 2\"}, {\"body\": \"Point 3\"}, {\"body\": \"Point 4\"}, {\"body\": \"Point 5\"}]. Here's the Content: " + prompt
      else
        prompt = "Generate exactly 5 key bullet points that summarize the main points from this content. Follow the three act structure. These should be concise, informative points that capture the essence of the content. You MUST return a JSON array with exactly 5 objects like this: [{\"body\": \"First key point\"}, {\"body\": \"Second key point\"}, {\"body\": \"Third key point\"}, {\"body\": \"Fourth key point\"}, {\"body\": \"Fifth key point\"}]. Keep each bullet point under 150 characters. Here's the content:\n\n#{content}"
      end
      
      bullet_points_data = WizardService.ask(prompt, "json_object")
      
      # Handle nested response structure
      if bullet_points_data.is_a?(Hash) && bullet_points_data.keys.length == 1
        bullet_points_data = bullet_points_data[bullet_points_data.keys.first]
      end
      
      # Handle string response by trying to parse it as JSON
      if bullet_points_data.is_a?(String)
        begin
          bullet_points_data = JSON.parse(bullet_points_data)
        rescue JSON::ParserError
          # If it's not valid JSON, try to extract bullet points from the text
          lines = bullet_points_data.split("\n").reject(&:blank?)
          bullet_points_data = lines.map { |line| { "body" => line.strip } }
        end
      end
      
      # Ensure we have an array to work with
      if bullet_points_data.is_a?(Hash)
        bullet_points_data = [bullet_points_data]
      elsif !bullet_points_data.is_a?(Array)
        raise "Invalid response format: expected array or object, got #{bullet_points_data.class}"
      end
      
      # If we don't have enough bullet points, try a different approach
      if bullet_points_data.length < 3
        # Try to generate more bullet points from the content
        fallback_prompt = "From this content, create 5 distinct bullet points. Each should be a different aspect or key point. Return as JSON array: [{\"body\": \"Point 1\"}, {\"body\": \"Point 2\"}, {\"body\": \"Point 3\"}, {\"body\": \"Point 4\"}, {\"body\": \"Point 5\"}]. Content: #{content}"
        
        begin
          fallback_data = WizardService.ask(fallback_prompt, "json_object")
          
          if fallback_data.is_a?(Hash) && fallback_data.keys.length == 1
            fallback_data = fallback_data[fallback_data.keys.first]
          end
          
          if fallback_data.is_a?(Array) && fallback_data.length >= 3
            bullet_points_data = fallback_data
          end
        rescue => e
          Rails.logger.warn "Fallback bullet point generation failed: #{e.message}"
        end
      end
      
      # If still not enough, create manual bullet points based on content
      if bullet_points_data.length < 3
        manual_points = []
        
        # Extract key information from content
        content_lower = content.downcase
        
        # Add points based on content analysis
        if content_lower.include?("champion") || content_lower.include?("winner")
          manual_points << { "body" => "Achieved championship status" }
        end
        
        if content_lower.include?("record") || content_lower.include?("most")
          manual_points << { "body" => "Set or holds significant records" }
        end
        
        if content_lower.include?("career") || content_lower.include?("history")
          manual_points << { "body" => "Notable career achievements" }
        end
        
        if content_lower.include?("team") || content_lower.include?("club")
          manual_points << { "body" => "Made significant team contributions" }
        end
        
        if content_lower.include?("skill") || content_lower.include?("talent")
          manual_points << { "body" => "Demonstrated exceptional skills" }
        end
        
        # Add generic points to reach minimum
        while manual_points.length < 3
          manual_points << { "body" => "Key highlight from the content" }
        end
        
        # Combine with any existing points
        bullet_points_data = (bullet_points_data + manual_points).first(5)
      end
      
      created_bullet_points = []
      bullet_points_data.each do |bullet_point_data|
        next unless bullet_point_data.is_a?(Hash) && bullet_point_data["body"]
        
        bullet_point = create!(
          body: bullet_point_data["body"],
          bullet_pointable_type: bullet_pointable_type,
          bullet_pointable_id: bullet_pointable_id
        )
        created_bullet_points << bullet_point
      end
      
      {
        success: true,
        message: "Successfully generated #{created_bullet_points.count} bullet points for #{bullet_pointable_type} ##{bullet_pointable_id}",
        bullet_points: created_bullet_points
      }
      
    rescue NameError
      { success: false, error: "Invalid bullet_pointable type: #{bullet_pointable_type}" }
    rescue ActiveRecord::RecordNotFound
      { success: false, error: "#{bullet_pointable_type} not found" }
    rescue => e
      Rails.logger.error "BulletPoint wizard error: #{e.message}"
      { success: false, error: "Failed to generate bullet points", details: e.message }
    end
  end

  private

  def set_position
    return if position.present?
    
    max_position = BulletPoint.for_bullet_pointable(bullet_pointable_type, bullet_pointable_id).maximum(:position) || -1
    self.position = max_position + 1
  end
end 