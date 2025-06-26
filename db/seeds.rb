# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create Sports
puts "Creating sports..."
football = Sport.create!(title: "Football", position: 1)
basketball = Sport.create!(title: "Basketball", position: 2)
tennis = Sport.create!(title: "Tennis", position: 3)

# Create Figures
puts "Creating figures..."
messi = Figure.create!(title: "Lionel Messi", sport: football, position: 1)
ronaldo = Figure.create!(title: "Cristiano Ronaldo", sport: football, position: 2)
lebron = Figure.create!(title: "LeBron James", sport: basketball, position: 1)
federer = Figure.create!(title: "Roger Federer", sport: tennis, position: 1)

# Create Sport Rules
puts "Creating sport rules..."
football_rule = SportRule.create!(
  title: "Offside Rule",
  summary: "Players must not be in an offside position when the ball is played to them",
  body: "A player is in an offside position if they are nearer to the opponent's goal line than both the ball and the second-last opponent when the ball is played to them.",
  sport: football
)

basketball_rule = SportRule.create!(
  title: "3-Second Rule",
  summary: "Offensive players cannot stay in the paint for more than 3 seconds",
  body: "An offensive player cannot remain in the free throw lane (paint) for more than 3 consecutive seconds while their team has possession of the ball.",
  sport: basketball
)

# Create Relationships
puts "Creating relationships..."
rivalry = Relationship.create!(title: "Rivalry")
teammates = Relationship.create!(title: "Teammates")

# Create Relationship Figures
RelationshipFigure.create!(figure: messi, relationship: rivalry)
RelationshipFigure.create!(figure: ronaldo, relationship: rivalry)

# Create Tags
puts "Creating tags..."
legend_tag = Tag.create!(title: "Legend", summary: "All-time great players")
champion_tag = Tag.create!(title: "Champion", summary: "Championship winners")
rising_star_tag = Tag.create!(title: "Rising Star", summary: "Up-and-coming players")

# Tag some figures
messi.tags << legend_tag
messi.tags << champion_tag
ronaldo.tags << legend_tag
ronaldo.tags << champion_tag
lebron.tags << legend_tag
lebron.tags << champion_tag
federer.tags << legend_tag
federer.tags << champion_tag

# Create Events
puts "Creating events..."
Event.create!(title: "Messi wins World Cup 2022", eventable: messi)
Event.create!(title: "Ronaldo joins Al Nassr", eventable: ronaldo)
Event.create!(title: "LeBron breaks scoring record", eventable: lebron)

# Create Stories
puts "Creating stories..."
Story.create!(
  title: "Messi's Journey to World Cup Glory",
  body: "Lionel Messi finally achieved his lifelong dream of winning the World Cup in 2022...",
  storyable: messi
)

Story.create!(
  title: "The Evolution of Basketball",
  body: "Basketball has evolved significantly over the years...",
  storyable: basketball
)

# Create an admin user for testing
admin_user = User.create!(
  email: 'admin@scorefeel.com',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Admin',
  last_name: 'User',
  birthdate: Date.new(1990, 1, 1),
  timezone: 'UTC',
  roles: ['admin']
)

puts "Created admin user: #{admin_user.email}"

# Create a regular user for testing
regular_user = User.create!(
  email: 'user@scorefeel.com',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Regular',
  last_name: 'User',
  birthdate: Date.new(1995, 5, 15),
  timezone: 'America/New_York',
  roles: ['user']
)

puts "Created regular user: #{regular_user.email}"

puts "Seed data created successfully!"
puts "Created #{Sport.count} sports"
puts "Created #{Figure.count} figures"
puts "Created #{SportRule.count} sport rules"
puts "Created #{Relationship.count} relationships"
puts "Created #{Tag.count} tags"
puts "Created #{Event.count} events"
puts "Created #{Story.count} stories"
