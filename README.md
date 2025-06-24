# ScoreFeel Sports Journalism API

A Rails 8 API for sports journalism that manages figures, sports, rules, relationships, events, tags, and stories.

## Features

- **Figures**: Sports figures/athletes with optional sport associations
- **Sports**: Sport categories with hierarchical structure
- **Sport Rules**: Detailed rules for each sport
- **Relationships**: Connections between figures (rivalries, teammates, etc.)
- **Events**: Timeline events for any entity
- **Tags**: Categorization system for all entities
- **Stories**: Journalistic content about any entity

## API Endpoints

### Base URL

```
/api/v1
```

### Figures

- `GET /figures` - List all figures
- `GET /figures/:id` - Get a specific figure
- `POST /figures` - Create a new figure
- `PUT /figures/:id` - Update a figure
- `DELETE /figures/:id` - Delete a figure

### Sports

- `GET /sports` - List all sports
- `GET /sports/:id` - Get a specific sport
- `POST /sports` - Create a new sport
- `PUT /sports/:id` - Update a sport
- `DELETE /sports/:id` - Delete a sport

### Sport Rules

- `GET /sport_rules` - List all sport rules
- `GET /sport_rules/:id` - Get a specific sport rule
- `POST /sport_rules` - Create a new sport rule
- `PUT /sport_rules/:id` - Update a sport rule
- `DELETE /sport_rules/:id` - Delete a sport rule

### Relationships

- `GET /relationships` - List all relationships
- `GET /relationships/:id` - Get a specific relationship
- `POST /relationships` - Create a new relationship
- `PUT /relationships/:id` - Update a relationship
- `DELETE /relationships/:id` - Delete a relationship

### Events

- `GET /events` - List all events
- `GET /events/:id` - Get a specific event
- `POST /events` - Create a new event
- `PUT /events/:id` - Update an event
- `DELETE /events/:id` - Delete an event

### Tags

- `GET /tags` - List all tags
- `GET /tags/:id` - Get a specific tag
- `POST /tags` - Create a new tag
- `PUT /tags/:id` - Update a tag
- `DELETE /tags/:id` - Delete a tag

### Stories

- `GET /stories` - List all stories
- `GET /stories/:id` - Get a specific story
- `POST /stories` - Create a new story
- `PUT /stories/:id` - Update a story
- `DELETE /stories/:id` - Delete a story

## Data Models

### Figure

- `title` (string, required)
- `sport_id` (integer, optional)
- `position` (integer, optional)

### Sport

- `title` (string, required)
- `sport_id` (integer, optional) - for hierarchical sports
- `position` (integer, optional)

### SportRule

- `title` (string, required)
- `summary` (text, required)
- `body` (text, required)
- `sport_id` (integer, required)

### Relationship

- `title` (string, required)

### RelationshipFigure (Join Table)

- `figure_id` (integer, required)
- `relationship_id` (integer, required)

### Event

- `title` (string, required)
- `eventable_type` (string, required) - polymorphic
- `eventable_id` (integer, required) - polymorphic

### Tag

- `title` (string, required, unique)
- `summary` (text, required)

### Tagging (Join Table)

- `tag_id` (integer, required)
- `tagable_type` (string, required) - polymorphic
- `tagable_id` (integer, required) - polymorphic

### Story

- `title` (string, required)
- `body` (text, required)
- `storyable_type` (string, required) - polymorphic
- `storyable_id` (integer, required) - polymorphic

## Setup

1. Clone the repository
2. Install dependencies: `bundle install`
3. Setup database: `rails db:create db:migrate`
4. Seed data: `rails db:seed`
5. Start server: `rails server`

## Example Usage

### Create a Figure

```bash
curl -X POST http://localhost:3000/api/v1/figures \
  -H "Content-Type: application/json" \
  -d '{
    "figure": {
      "title": "Lionel Messi",
      "sport_id": 1,
      "position": 1
    }
  }'
```

### Get All Figures

```bash
curl http://localhost:3000/api/v1/figures
```

### Create an Event for a Figure

```bash
curl -X POST http://localhost:3000/api/v1/events \
  -H "Content-Type: application/json" \
  -d '{
    "event": {
      "title": "Wins World Cup 2022",
      "eventable_type": "Figure",
      "eventable_id": 1
    }
  }'
```

## Polymorphic Associations

The API uses polymorphic associations for:

- **Events**: Can belong to any entity (Figure, Sport, SportRule, etc.)
- **Stories**: Can be about any entity
- **Tags**: Can tag any entity

This allows for flexible content management where any entity can have events, stories, and tags.

## Error Handling

The API returns appropriate HTTP status codes:

- `200` - Success
- `201` - Created
- `400` - Bad Request
- `404` - Not Found
- `422` - Unprocessable Entity
- `500` - Internal Server Error

Error responses include detailed error messages in JSON format.
# scorefeel-api
# scorefeel-api
# scorefeel-api
# scorefeel-api
# scorefeel-api
