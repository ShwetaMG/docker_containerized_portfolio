# Cloud & DevOps Portfolio

A personal portfolio website — containerized, provisioned as Infrastructure-as-Code, deployed through an automated CI/CD pipeline, and served over free auto-renewing HTTPS.

**Live site:** https://shwetamg.duckdns.org

---

## Overview

This isn't just a static website — it's a small, complete demonstration of a real DevOps workflow: build → containerize → provision infrastructure → automate deployment → secure with HTTPS. Every piece below was built, tested, and debugged by hand as part of an intentional transition from an ERP/enterprise systems background into Cloud/DevOps engineering.

## Architecture

```
 Developer (git push)
        │
        ▼
 GitHub Actions (CI/CD)
        │
        ├── Build Docker image (Nginx + static site)
        ├── Push image to Docker Hub
        │
        ▼
   SSH into EC2 instance
        │
        ├── Pull latest image
        ├── Stop old container / start new one
        │
        ▼
  EC2 (Ubuntu, Terraform-provisioned)
        │
        ├── Nginx serves site on :80 → redirects to :443
        └── HTTPS via Let's Encrypt / Certbot (auto-renewing)
        │
        ▼
   shwetagarawad.duckdns.org
```

## Tech Stack

| Layer | Technology |
|---|---|
| Site | HTML, CSS, JavaScript (no framework — kept lightweight) |
| Web server | Nginx (Alpine-based image) |
| Containerization | Docker |
| Image registry | Docker Hub |
| Infrastructure | AWS EC2, provisioned via Terraform (IaC) |
| CI/CD | GitHub Actions |
| HTTPS | Let's Encrypt + Certbot (free, auto-renewing) |
| DNS | DuckDNS (free dynamic DNS) |

## Repository Structure

```
.
├── index.html, style.css, script.js   # The site itself
├── assets/                            # Resume PDF, static assets
├── Dockerfile                         # Nginx-based container image
├── nginx.conf                         # Web server config (gzip, caching, HTTPS)
├── docker-compose.yml                 # For local testing
├── .github/workflows/deploy.yml       # CI/CD pipeline
└── terraform/                         # AWS infrastructure as code
    ├── main.tf                        # EC2 instance, Security Group, key pair
    ├── variables.tf
    ├── outputs.tf
    ├── provider.tf                    # AWS provider configuration
    ├── terraform.tf                   # Terraform/provider version constraints
    └── user_data.sh                   # Bootstrap script — installs Docker on first boot
```

## Running Locally

Requires [Docker Desktop](https://www.docker.com/products/docker-desktop/).

```bash
git clone https://github.com/ShwetaMG/docker_containerized_portfolio.git
cd docker_containerized_portfolio
docker compose up --build
```

Visit `http://localhost:8080`.

## Deploying Your Own Copy

1. **Provision infrastructure:**
   ```bash
   cd terraform
   cp terraform.tfvars.example terraform.tfvars   # fill in your key pair name, region, etc.
   terraform init
   terraform plan
   terraform apply
   ```
2. **Set up GitHub Secrets** for CI/CD (repo → Settings → Secrets and variables → Actions):
   `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`, `EC2_HOST`, `EC2_SSH_PRIVATE_KEY`
3. **Push to `main`** — GitHub Actions builds the image, pushes to Docker Hub, and deploys to the EC2 instance automatically.
4. **Point a domain** (a free option like [DuckDNS](https://www.duckdns.org/)) at the instance's public IP, then set up HTTPS:
   ```bash
   sudo apt-get install -y certbot
   docker stop portfolio-site
   sudo certbot certonly --standalone -d your-domain.duckdns.org --agree-tos -m your-email@example.com
   ```

## Challenges & Debugging

A few real issues hit and resolved during this build — noted here since debugging is as much a part of DevOps work as writing the config in the first place:

- **GitHub Actions unable to SSH into the EC2 instance (`i/o timeout`)** — caused by restricting the Security Group's port 22 to a single home IP, which blocked GitHub's CI runners (which don't have a fixed IP). Resolved by relying on key-based auth as the actual security boundary instead of IP restriction.
- **Site reachable locally but not for other users** — an AWS Security Group rule for port 80 had been accidentally scoped to a single IP instead of `0.0.0.0/0` while editing an unrelated rule.

## License

This project is for personal/portfolio use. Feel free to reference the structure, but please don't republish the content as your own.
