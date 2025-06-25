# API Routes & Management Instructions

These are the RESTful API endpoints for your sports journalism app. Use these routes in your frontend (e.g., Cursor) to build management views for each resource.

---

## Figures

| Action         | Method | Endpoint                       | Description                    |
| -------------- | ------ | ------------------------------ | ------------------------------ |
| List all       | GET    | `/figures`                     | Get all figures                |
| Get one        | GET    | `/figures/:id`                 | Get a specific figure          |
| Create         | POST   | `/figures`                     | Create a new figure            |
| Update         | PUT    | `/figures/:id`                 | Update a figure                |
| Delete         | DELETE | `/figures/:id`                 | Delete a figure                |
| Generate Story | POST   | `/figures/:id/generate_story`  | Generate AI story about figure |
| Upload Picture | POST   | `/figures/:id/upload_picture`  | Upload a picture for a figure  |
| Get Stories    | GET    | `/figures/:figure_id/stories`  | Get all stories for a figure   |
| Get Pictures   | GET    | `/figures/:figure_id/pictures` | Get all pictures for a figure  |

**Note**: Figures can include `birth_date` and `death_date` fields. If both dates are provided, death_date must be after birth_date.

---

## Sports

| Action           | Method | Endpoint                           | Description                       |
| ---------------- | ------ | ---------------------------------- | --------------------------------- |
| List all         | GET    | `/sports`                          | Get all sports                    |
| Get one          | GET    | `/sports/:id`                      | Get a specific sport              |
| Create           | POST   | `/sports`                          | Create a new sport                |
| Update           | PUT    | `/sports/:id`                      | Update a sport                    |
| Delete           | DELETE | `/sports/:id`                      | Delete a sport                    |
| Generate Figures | POST   | `/sports/:id/generate_figures`     | Generate AI figures for sport     |
| Generate Story   | POST   | `/sports/:id/generate_story`       | Generate AI story about sport     |
| Generate Rules   | POST   | `/sports/:id/generate_sport_rules` | Generate AI sport rules for sport |
| Generate Events  | POST   | `/sports/:id/generate_events`      | Generate AI events for sport      |
| Get Stories      | GET    | `/sports/:sport_id/stories`        | Get all stories for a sport       |
| Get Sport Rules  | GET    | `/sports/:sport_id/sport_rules`    | Get all sport rules for a sport   |

---

## Sport Rules

| Action   | Method | Endpoint           | Description               |
| -------- | ------ | ------------------ | ------------------------- |
| List all | GET    | `/sport_rules`     | Get all sport rules       |
| Get one  | GET    | `/sport_rules/:id` | Get a specific sport rule |
| Create   | POST   | `/sport_rules`     | Create a new sport rule   |
| Update   | PUT    | `/sport_rules/:id` | Update a sport rule       |
| Delete   | DELETE | `/sport_rules/:id` | Delete a sport rule       |

---

## Relationships

| Action   | Method | Endpoint             | Description                 |
| -------- | ------ | -------------------- | --------------------------- |
| List all | GET    | `/relationships`     | Get all relationships       |
| Get one  | GET    | `/relationships/:id` | Get a specific relationship |
| Create   | POST   | `/relationships`     | Create a new relationship   |
| Update   | PUT    | `/relationships/:id` | Update a relationship       |
| Delete   | DELETE | `/relationships/:id` | Delete a relationship       |

---

## Events

| Action         | Method | Endpoint                     | Description                      |
| -------------- | ------ | ---------------------------- | -------------------------------- |
| List all       | GET    | `/events`                    | Get all events (ordered by date) |
| Get one        | GET    | `/events/:id`                | Get a specific event             |
| Create         | POST   | `/events`                    | Create a new event               |
| Update         | PUT    | `/events/:id`                | Update an event                  |
| Delete         | DELETE | `/events/:id`                | Delete an event                  |
| Generate Story | POST   | `/events/:id/generate_story` | Generate AI story about event    |

**Note**: Events require a `start_date` field and are ordered by start_date (most recent first). Events also support an optional `end_date` field - if not provided, it defaults to the same as `start_date`. The model includes helper methods `duration_days` and `is_multi_day` for multi-day events.

---

## Tags

| Action   | Method | Endpoint    | Description        |
| -------- | ------ | ----------- | ------------------ |
| List all | GET    | `/tags`     | Get all tags       |
| Get one  | GET    | `/tags/:id` | Get a specific tag |
| Create   | POST   | `/tags`     | Create a new tag   |
| Update   | PUT    | `/tags/:id` | Update a tag       |
| Delete   | DELETE | `/tags/:id` | Delete a tag       |

---

## Stories

| Action            | Method | Endpoint                         | Description                               |
| ----------------- | ------ | -------------------------------- | ----------------------------------------- |
| List all          | GET    | `/stories`                       | Get all stories                           |
| Get one           | GET    | `/stories/:id`                   | Get a specific story                      |
| Create            | POST   | `/stories`                       | Create a new story                        |
| Update            | PUT    | `/stories/:id`                   | Update a story                            |
| Delete            | DELETE | `/stories/:id`                   | Delete a story                            |
| Validate Story    | GET    | `/stories/:id/validate`          | Validate story accuracy using AI          |
| Generate Pictures | POST   | `/stories/:id/generate_pictures` | Generate AI picture suggestions for story |
| Upload Picture    | POST   | `/stories/:id/upload_picture`    | Upload a picture for a story              |
| Get Pictures      | GET    | `/stories/:story_id/pictures`    | Get all pictures for a story              |

---

## Pictures

| Action       | Method | Endpoint                       | Description                               |
| ------------ | ------ | ------------------------------ | ----------------------------------------- |
| List all     | GET    | `/pictures`                    | Get all pictures                          |
| Get one      | GET    | `/pictures/:id`                | Get a specific picture                    |
| Create       | POST   | `/pictures`                    | Create a new picture                      |
| Update       | PUT    | `/pictures/:id`                | Update a picture                          |
| Delete       | DELETE | `/pictures/:id`                | Delete a picture                          |
| Upload Image | POST   | `/pictures/:id/upload_picture` | Upload image file for an existing picture |

**Note**: Pictures are polymorphic and can be associated with stories, figures, sports, etc. They include caption, image_url, storage_key, and cover fields.

---

## Blurbs

| Action           | Method | Endpoint                                           | Description                             |
| ---------------- | ------ | -------------------------------------------------- | --------------------------------------- |
| List all         | GET    | `/blurbs`                                          | Get all blurbs                          |
| Get one          | GET    | `/blurbs/:id`                                      | Get a specific blurb                    |
| Create           | POST   | `/blurbs`                                          | Create a new blurb                      |
| Update           | PUT    | `/blurbs/:id`                                      | Update a blurb                          |
| Delete           | DELETE | `/blurbs/:id`                                      | Delete a blurb                          |
| Get by Blurbable | GET    | `/blurbs/for/:blurbable_type/:blurbable_id`        | Get blurbs for a specific blurbable     |
| Generate Blurbs  | POST   | `/blurbs/for/:blurbable_type/:blurbable_id/wizard` | Generate AI fact blurbs for a blurbable |

**Note**: Blurbs are polymorphic and can be associated with stories, figures, etc. They include title, description, starred (default: true), and blurbable_type/blurbable_id fields.

---

## How to Use in Your Frontend

- Use these endpoints to build CRUD (Create, Read, Update, Delete) management views for each resource.
- For each resource, create forms for creation and editing, tables or lists for viewing, and actions for deleting.
- Use the `id` parameter in the URL for show, update, and delete actions.
- All endpoints return JSON responses.

## Example Usage

```javascript
// Get all figures
fetch("/figures")
  .then((response) => response.json())
  .then((data) => console.log(data));

// Create a new figure
fetch("/figures", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    figure: {
      title: "New Athlete",
      summary: "A legendary athlete",
      birth_date: "1985-03-15",
      death_date: "2020-12-10",
      sport_id: 1,
      position: 1,
    },
  }),
});

// Generate figures for a sport using AI
fetch("/sports/1/generate_figures", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
})
  .then((response) => response.json())
  .then((data) => console.log(data));

// Generate sport rules for a sport using AI
fetch("/sports/1/generate_sport_rules", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
})
  .then((response) => response.json())
  .then((data) => console.log(data));

// Generate events for a sport using AI
fetch("/sports/1/generate_events", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
})
  .then((response) => response.json())
  .then((data) => console.log(data));

// Generate story for a sport using AI
fetch("/sports/1/generate_story", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
})
  .then((response) => response.json())
  .then((data) => console.log(data));

// Get all stories for a specific sport
fetch("/sports/1/stories")
  .then((response) => response.json())
  .then((data) => console.log(data));

// Get all sport rules for a specific sport
fetch("/sports/1/sport_rules")
  .then((response) => response.json())
  .then((data) => console.log(data));

// Generate story for a figure using AI
fetch("/figures/1/generate_story", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
})
  .then((response) => response.json())
  .then((data) => console.log(data));

// Get all stories for a specific figure
fetch("/figures/1/stories")
  .then((response) => response.json())
  .then((data) => console.log(data));

// Create a new event
fetch("/events", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    event: {
      title: "Championship Win",
      start_date: "2024-06-15",
      end_date: "2024-06-17",
      eventable_type: "Figure",
      eventable_id: 1,
    },
  }),
});

// Generate story for an event using AI
fetch("/events/1/generate_story", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
})
  .then((response) => response.json())
  .then((data) => console.log(data));

// Generate picture suggestions for a story using AI
fetch("/stories/1/generate_pictures", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
})
  .then((response) => response.json())
  .then((data) => console.log(data));

// Get all pictures for a specific story
fetch("/stories/1/pictures")
  .then((response) => response.json())
  .then((data) => console.log(data));

// Get all pictures for a specific figure
fetch("/figures/1/pictures")
  .then((response) => response.json())
  .then((data) => console.log(data));

// Upload a picture for a story
const formData = new FormData();
formData.append("file", fileInput.files[0]);
formData.append("caption", "Story cover image");
formData.append("cover", "true");

fetch("/stories/1/upload_picture", {
  method: "POST",
  body: formData,
})
  .then((response) => response.json())
  .then((data) => console.log(data));

// Upload a picture for a figure
const formData = new FormData();
formData.append("file", fileInput.files[0]);
formData.append("caption", "Lewis Hamilton portrait");
formData.append("cover", "true");

fetch("/figures/1/upload_picture", {
  method: "POST",
  body: formData,
})
  .then((response) => response.json())
  .then((data) => console.log(data));

// Create a new picture
fetch("/pictures", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    picture: {
      caption: "Lewis Hamilton Turkish Grand Prix 2020",
      image_url: "https://example.com/image.jpg",
      cover: true,
      picturable_type: "Story",
      picturable_id: 1,
    },
  }),
});

// Upload image for an existing picture
const formData = new FormData();
formData.append("file", fileInput.files[0]);

fetch("/pictures/1/upload_picture", {
  method: "POST",
  body: formData,
})
  .then((response) => response.json())
  .then((data) => console.log(data));

// Validate story accuracy using AI
fetch("/stories/1/validate")
  .then((response) => response.json())
  .then((data) => console.log(data));
// Response includes: is_accurate, confidence_score, issues_found, verification_notes, recommendations

// Create a new blurb
fetch("/blurbs", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    blurb: {
      title: "Quick Fact",
      description: "This is a quick fact about the story or figure",
      blurbable_type: "Story",
      blurbable_id: 1,
      starred: true,
    },
  }),
});

// Get all blurbs for a specific story
fetch("/blurbs/for/Story/1")
  .then((response) => response.json())
  .then((data) => console.log(data));

// Get all blurbs for a specific figure
fetch("/blurbs/for/Figure/1")
  .then((response) => response.json())
  .then((data) => console.log(data));

// Update a blurb
fetch("/blurbs/1", {
  method: "PUT",
  headers: {
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    blurb: {
      title: "Updated Quick Fact",
      description: "Updated description",
      starred: false,
    },
  }),
});

// Generate fact blurbs for a story using AI
fetch("/blurbs/for/Story/1/wizard", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
})
  .then((response) => response.json())
  .then((data) => console.log(data));

// Generate fact blurbs for a figure using AI
fetch("/blurbs/for/Figure/1/wizard", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
})
  .then((response) => response.json())
  .then((data) => console.log(data));

## AI-Powered Features

- **Generate Figures**: Use `/sports/:id/generate_figures` to automatically generate 5 famous figures for a sport using AI
- **Generate Sport Rules**: Use `/sports/:id/generate_sport_rules` to automatically generate 5 important rules for a sport using AI
- **Generate Events**: Use `/sports/:id/generate_events` to automatically generate upcoming events for a sport using AI
- **Generate Stories**: Use `/sports/:id/generate_story`, `/figures/:id/generate_story`, or `/events/:id/generate_story` to automatically generate engaging stories using AI
- **Generate Pictures**: Use `/stories/:id/generate_pictures` to automatically generate picture suggestions for stories using AI
- **Generate Blurbs**: Use `/blurbs/for/:blurbable_type/:blurbable_id/wizard` to automatically generate fact blurbs for stories or figures using AI
- **Validate Stories**: Use `/stories/:id/validate` to check story accuracy and truthfulness using AI analysis
- The system avoids creating duplicate figures or rules that already exist
- Returns the newly created figures, rules, events, stories, or picture suggestions with their details

If you need example request/response payloads or want to see how to wire up forms, tables, or CRUD actions for any of these, just ask!
```
