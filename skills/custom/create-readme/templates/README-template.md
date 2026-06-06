# {Project Title}

{One-sentence description — what problem does this solve?}

[![Build Status](badge-url)](link) [![License](badge-url)](link) [![Coverage](badge-url)](link)

## Features

- Feature 1 (key capability)
- Feature 2 (key capability)
- Feature 3 (key capability)
- Feature 4 (key capability)

## Tech Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| Compute | Apache Spark 4.x | Distributed processing |
| Storage | Delta Lake 4.x | ACID transactions, time travel |
| Container | Docker / Docker Compose | Infrastructure as code |
| Language | Python 3.10 / Scala 2.13 | Job implementation |
| Monitoring | Prometheus + Grafana (optional) | Observability |

## Quick Start

```bash
# 1. Prerequisites
# - Docker 20+
# - Docker Compose 2+

# 2. Start cluster
docker-compose up -d

# 3. Run example job
make shell
spark-submit /path/to/job.py

# 4. Verify output
ls data/output/
```

**First-time setup:** See [Installation Guide](docs/INSTALL.md) for detailed steps.

## Directory Structure

```
.
├── conf/               # Spark config (spark-defaults.conf, log4j2.properties)
├── docs/               # Documentation (ADRs, guides, troubleshooting)
├── work-dir/           # Jobs, examples, notebooks
│   ├── jobs/           # Production Spark jobs
│   ├── examples/       # Quick-start examples
│   └── notebooks/      # Jupyter notebooks
├── data/               # Data storage (Delta tables, checkpoints)
├── scripts/            # Setup scripts
├── tests/              # Unit + integration tests
└── docker-compose.yml  # Infrastructure definition
```

## Architecture

```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│   Master    │──────▶│   Workers   │──────▶│ Delta Lake  │
│  Port 7077  │       │  4-core 30G │       │   Storage   │
└─────────────┘       └─────────────┘       └─────────────┘
       │
       ▼
┌─────────────┐
│  History    │
│ Port 18080  │
└─────────────┘
```

**Details:** See [Architecture Decision Records](docs/adr/) and [CONTEXT.md](CONTEXT.md)

## Configuration

**Environment Variables:**
```bash
# Copy template
cp config/example.env config/local.env

# Edit credentials
vim config/local.env
```

**Key settings:**
- `SPARK_MASTER_HOST` — Master node hostname (default: spark-master)
- `SPARK_WORKER_MEMORY` — Worker memory allocation (default: 30g)
- `DELTA_STORAGE_PATH` — Delta table storage path (default: /opt/spark/data/delta-tables)

**Full config reference:** [docs/CONFIGURATION.md](docs/CONFIGURATION.md)

## Development

```bash
# Run tests
make test

# Lint code
make lint

# Enter container shell
make shell
```

**Testing guide:** [tests/USAGE.md](tests/USAGE.md)

## Deployment

**Local development:** `docker-compose.yml`  
**Distributed mode:** `docker-compose.distributed.yml`  
**Production:** See [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)

## Troubleshooting

**Common issues:**
- Connection errors → [docs/troubleshooting/db2-connection-testing.md](docs/troubleshooting/db2-connection-testing.md)
- Memory errors → Check `SPARK_WORKER_MEMORY` in docker-compose.yml
- Delta Lake errors → Verify JAR versions in `jars.txt`

**Full guide:** [docs/troubleshooting/](docs/troubleshooting/)

## Contributing

1. Read [CONTRIBUTING.md](CONTRIBUTING.md)
2. Check [open issues](https://github.com/org/repo/issues)
3. Create feature branch: `git checkout -b feature/my-feature`
4. Submit PR with tests

**Code style:** Follow [CONTEXT.md](CONTEXT.md) guidelines

## License

[Apache 2.0](LICENSE) © {Year} {Copyright Holder}

---

## Documentation Index

- [Installation Guide](docs/INSTALL.md)
- [Configuration Reference](docs/CONFIGURATION.md)
- [Architecture Decision Records](docs/adr/)
- [Troubleshooting](docs/troubleshooting/)
- [API Reference](docs/API.md)
- [Changelog](CHANGELOG.md)

**Template based on:** Standard Readme Specification + Google README Guide + CNCF Template
