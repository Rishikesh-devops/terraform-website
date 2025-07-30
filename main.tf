# ----------------------------
# Networking
# ----------------------------
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a" # ✅ Fix for EC2 error
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ----------------------------
# EC2 + Website (Nginx)
# ----------------------------
resource "aws_instance" "web" {
  ami                         = "ami-0d0ad8bb301edb745" # Amazon Linux 2023 (Mumbai)
  instance_type               = "t2.micro"
  key_name                    = "rishi-keypair"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOT
              #!/bin/bash
              set -e
              sudo dnf update -y
              sudo dnf install -y nginx
              sudo mkdir -p /usr/share/nginx/html/assets

              # index.html
              cat > /usr/share/nginx/html/index.html <<'HTML'
              <!doctype html>
              <html lang="en">
              <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width,initial-scale=1">
                <title>Rishikesh | Home</title>
                <link rel="stylesheet" href="/assets/style.css">
              </head>
              <body>
                <header>
                  <h1>🚀 Deployed by Terraform</h1>
                  <nav>
                    <a href="/">Home</a>
                    <a href="/about.html">About</a>
                    <a href="/contact.html">Contact</a>
                  </nav>
                </header>
                <main>
                  <section class="hero">
                    <h2>Welcome!</h2>
                    <p>This website is fully provisioned with Terraform on AWS (EC2 + Nginx).</p>
                    <ul>
                      <li>Custom VPC, Subnet, Route & Security Group</li>
                      <li>Amazon Linux 2023 + Nginx</li>
                      <li>Static pages written by user_data</li>
                    </ul>
                  </section>
                </main>
                <footer>© 2025 Rishikesh | DevOps Practice</footer>
              </body>
              </html>
              HTML

              # about.html
              cat > /usr/share/nginx/html/about.html <<'HTML'
              <!doctype html>
              <html lang="en">
              <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width,initial-scale=1">
                <title>About | Rishikesh</title>
                <link rel="stylesheet" href="/assets/style.css">
              </head>
              <body>
                <header>
                  <h1>About this Project</h1>
                  <nav>
                    <a href="/">Home</a>
                    <a class="active" href="/about.html">About</a>
                    <a href="/contact.html">Contact</a>
                  </nav>
                </header>
                <main>
                  <p>This mini-site demonstrates a real DevOps workflow using Terraform and AWS. No Docker/Jenkins required yet.</p>
                  <p>Next steps will add CI/CD and more cloud services.</p>
                </main>
                <footer>© 2025 Rishikesh | DevOps Practice</footer>
              </body>
              </html>
              HTML

              # contact.html
              cat > /usr/share/nginx/html/contact.html <<'HTML'
              <!doctype html>
              <html lang="en">
              <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width,initial-scale=1">
                <title>Contact | Rishikesh</title>
                <link rel="stylesheet" href="/assets/style.css">
              </head>
              <body>
                <header>
                  <h1>Contact</h1>
                  <nav>
                    <a href="/">Home</a>
                    <a href="/about.html">About</a>
                    <a class="active" href="/contact.html">Contact</a>
                  </nav>
                </header>
                <main>
                  <p>You can reach me via GitHub or email. (Form coming later.)</p>
                </main>
                <footer>© 2025 Rishikesh | DevOps Practice</footer>
              </body>
              </html>
              HTML

              # assets/style.css
              cat > /usr/share/nginx/html/assets/style.css <<'CSS'
              * { box-sizing: border-box; }
              body { font-family: Arial, sans-serif; margin:0; color:#0f172a; background:#f8fafc; }
              header { background:#0ea5e9; color:white; padding:16px; }
              header h1 { margin:0 0 8px 0; font-size:22px; }
              nav a { color:white; margin-right:12px; text-decoration:none; padding:6px 10px; border-radius:6px; }
              nav a.active, nav a:hover { background:rgba(255,255,255,.2); }
              main { max-width:900px; margin:24px auto; background:white; padding:24px; border-radius:12px; box-shadow:0 4px 18px rgba(0,0,0,.06); }
              .hero h2 { margin-top:0; }
              ul { line-height:1.8; }
              footer { text-align:center; padding:20px; color:#475569; }
              CSS

              sudo systemctl enable --now nginx
              EOT

  tags = {
    Name = "tf-website"
  }
}
