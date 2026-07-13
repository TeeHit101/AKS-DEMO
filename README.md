# AKS-DEMO 🚀

Detta repository innehåller infrastrukturkod (Infrastructure as Code - IaC) i Terraform för att driftsätta resurser i Microsoft Azure. Projektet är uppsatt enligt bästa praxis med en modulariserad struktur, remote state-lagring och säker lösenordslös CI/CD via GitHub Actions (OIDC).

---

## 📁 Mappstruktur

* **`bootstrap/`**: Innehåller Terraform-koden som sätter upp grunden i Azure (skapar ett Storage Account för att spara Terraform State säkert, samt skapar Entra ID-rättigheter för GitHub Actions).
* **`modules/`**: Återanvändbara moduler (t.ex. nätverk/VNet, servrar, AKS-kluster).
* **`envs/`**: Konfiguration för specifika miljöer (t.ex. `test/` eller `prod/`).

---

## ⚙️ Kom igång (Lokalt)

### 1. Förutsättningar
Följande verktyg behöver vara installerade på din dator:
* **Azure CLI** (`az`)
* **Terraform** (v1.15.x eller nyare)
* **Python & pre-commit** (för automatisk kodvalidering)

### 2. Logga in på Azure
Öppna din terminal och kör:
```powershell
az login --tenant 0d2b28a5-7daa-4790-a925-22834f4ba55c
```

### 3. Aktivera pre-commit (Kodkontroll)
För att säkerställa att din kod alltid är välformaterad och säker innan du gör en commit:
```powershell
pre-commit install
```

---

## 🔒 Säkerhet & GitHub Actions (OIDC)
Detta projekt använder **OpenID Connect (OIDC)**. Det innebär att GitHub Actions kan logga in i Azure och köra `terraform apply` helt lösenordslöst.
Behörigheten är strikt låst så att endast körningar på **`main`**-branchen i repot **`Teehit101/AKS-DEMO`** har tillgång till ditt Azure-konto.
