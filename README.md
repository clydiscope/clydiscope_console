# Clydiscope Console

**A Ruby on Rails application for conversational AI, local language model integration, and natural-language-driven fabrication workflows.**

Clydiscope Console is the central application in Clydiscope AI Studio, an independent software engineering portfolio exploring local AI infrastructure, API integration, and automation.

The application provides a browser-based interface for interacting with a locally hosted language model, saving conversations, and coordinating external services.

## Features

- Conversational AI interface built with Ruby on Rails
- Integration with locally hosted Qwen language models through LM Studio
- Persistent conversations and messages using PostgreSQL
- Conversation history and response continuity
- Response latency measurement
- Model availability checks
- Markdown rendering support
- Natural-language fabrication command interpretation
- Integration with an external Python fabrication API
- STL file download workflow

## Technology Stack

| Component | Technology |
|---|---|
| Backend | Ruby on Rails 8.1 |
| Programming language | Ruby |
| Database | PostgreSQL |
| Frontend | Hotwire, Turbo, Stimulus |
| AI inference | LM Studio, Qwen3 1.7B |
| HTTP integration | Net::HTTP, JSON |
| Markdown | CommonMarker |
| Fabrication integration | Python, FastAPI, Blender |
| Version control | Git, GitHub |

## Architecture

Clydiscope Console separates application logic into controllers, models, and service objects.

### Conversational AI

`ConsoleController` manages conversation creation, message submission, and conversation retrieval.

`ConsoleResponder` communicates with a locally hosted Qwen model using HTTP requests and JSON responses.

`Conversation` and `Message` models provide persistent conversation storage through Active Record.

### AI Service Monitoring

`HilbertStatus` checks the availability of the configured language model endpoint and handles connection failures.

### Fabrication Workflow

Console also contains a separate fabrication pipeline.

- `FabricationInterpreter` translates natural-language requests into structured fabrication commands.
- `FabricationCommandValidator` validates operation types and dimensional parameters.
- `FabricationOrchestrator` coordinates interpretation, validation, and API submission.
- `FabricationService` communicates with the Python fabrication backend.
- `FabricationsController` handles fabrication requests and download actions.

## Conversational AI Pipeline

```text
Browser
   |
   v
Rails ConsoleController
   |
   v
Conversation / Message
   |
   v
ConsoleResponder
   |
   v
LM Studio API
   |
   v
Qwen Language Model
   |
   v
AI Response
   |
   v
PostgreSQL + Browser
```

### Conversation Persistence

Each conversation stores its messages in PostgreSQL.

The application also saves a model response identifier and supplies it to subsequent requests to support conversation continuity.

The responder measures elapsed request time and returns metadata including model identity, timestamp, and latency.

## Natural-Language Fabrication

The fabrication feature demonstrates communication between multiple independent software components.

```text
Natural-Language Request
          |
          v
FabricationInterpreter
          |
          v
Local Qwen Model
          |
          v
Structured JSON Command
          |
          v
FabricationCommandValidator
          |
          v
FabricationOrchestrator
          |
          v
FabricationService
          |
          v
FastAPI Fabrication Backend
          |
          v
Blender / STL Generation
```

For example, a user can request a cube with a specified size.

The interpreter converts the request into a structured command, and the validator checks that the operation is supported and the size is within the allowed range.

The current implementation supports the `create_cube` operation with dimensions greater than zero and up to 200 mm.

This pipeline demonstrates an important engineering principle: **language models can interpret requests while deterministic application code validates and executes the resulting commands.**

## Application Routes

| Method | Route | Purpose |
|---|---|---|
| GET | `/` | Main conversational interface |
| POST | `/console/submit` | Submit a conversation prompt |
| GET | `/conversations/:id` | Retrieve a conversation |
| GET | `/fabrication` | Fabrication interface |
| POST | `/fabrication` | Submit a fabrication request |
| GET | `/fabrication/download` | Fabrication download action |
| GET | `/up` | Rails health check |

## Local Development

### Requirements

- Ruby version specified in `.ruby-version`
- Rails 8.1
- PostgreSQL
- Bundler
- LM Studio with Qwen3 1.7B
- Python fabrication backend for fabrication features

Install dependencies:

```bash
bundle install
```

Prepare the database:

```bash
bin/rails db:prepare
```

Start the Rails server:

```bash
bin/rails server
```

Open:

`http://localhost:3000`

### Local AI Configuration

The conversational responder currently uses:

`http://127.0.0.1:1235/api/v1/chat`

The fabrication interpreter uses:

`http://127.0.0.1:1234/v1/chat/completions`

These endpoints are currently configured directly in their respective service classes.

Start LM Studio, load the configured model, and enable its API server before making AI requests.

The fabrication backend must also be running separately for fabrication operations.

## Testing

Run the Rails test suite:

```bash
bin/rails test
```

The repository includes Rails testing infrastructure. Additional integration tests for language model responses, network failures, fabrication commands, and external API behavior would strengthen coverage.

## Current Limitations and Future Development

Potential improvements include:

- Environment-based configuration of service endpoints
- More comprehensive HTTP error handling and timeout policies
- Expanded automated service tests
- Persistent fabrication job records
- Additional fabrication operations
- Background processing for long-running tasks
- Improved response parsing and validation
- Model selection and routing based on task complexity
- Deployment and operational documentation

The fabrication integration currently contains an STL download request that needs alignment with the job-specific download endpoint in the Python backend.

## Related Projects

**Clydiscope AMA** — Ruby on Rails document question-answering prototype with PDF extraction and Bloom's Taxonomy-based question analysis.

https://github.com/clydiscope/clydiscope_ama

**Clydiscope Fabricator** — Python FastAPI service for Blender-based geometry generation and STL export.

https://github.com/clydiscope/clydiscope_fabricator

## Project Goals

Clydiscope Console explores how a web application can coordinate language models, databases, and external software services through a modular architecture.

The long-term direction includes efficient model routing, reliable system integration, and practical AI-assisted workflows.

**Developed by Clydiscope AI Studio**

[GitHub Profile](https://github.com/clydiscope)
