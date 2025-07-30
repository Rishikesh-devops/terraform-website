
# 🌐 Terraform EC2 + Nginx Static Website Deployment

This project provisions a fully functional static website hosted on an EC2 instance using **Terraform**, **Amazon Linux 2023**, and **Nginx**.

![Screenshot](./screenshot.png)

## 🚀 Live Website

🔗 [http://<your-public-ip>](http://<your-public-ip>)

_Replace with your actual EC2 public IP address._

---

## 📦 Tech Stack

- **Terraform** – Infrastructure as Code (IaC)
- **AWS EC2** – Virtual Server Hosting
- **Amazon Linux 2023** – Lightweight and secure OS
- **Nginx** – High-performance web server

---

## 🔧 Features

- Custom VPC, Subnet, Route Table
- Internet Gateway and Security Group
- EC2 Instance Provisioned with Terraform
- Nginx installed and configured via `user_data`
- Static HTML Website with Navbar (Home, About, Contact)

---

## 📁 Folder Structure

```
terraform-website/
├── main.tf
├── variables.tf
├── outputs.tf
├── index.html
├── style.css
├── screenshot.png
└── README.md
```

---

## ⚙️ How to Deploy

1. **Clone this repo**

```bash
git clone https://github.com/your-username/terraform-website.git
cd terraform-website
```

2. **Update variables in `main.tf`** (if needed)

3. **Initialize Terraform**

```bash
terraform init
```

4. **Deploy infrastructure**

```bash
terraform apply
```

5. **Access your website**

Open your browser and visit the EC2 public IP from output.

---

## 📷 Screenshot

![Deployed Website](screenshot.png)

---

## 👤 Author

**Rishikesh Kumar** – [GitHub](https://github.com/Rishikesh-devops)

© 2025 Rishikesh | DevOps Practice

---

## 🧹 Cleanup

To destroy resources and avoid charges:

```bash
terraform destroy
```

---

## 🤝 Contributing

PRs and feedback are welcome!

---

## 📄 License

This project is licensed under the MIT License.
