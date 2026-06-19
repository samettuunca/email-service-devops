# Email Service - DevOps Projesi

Google Cloud'un microservices-demo projesinden email servisini fork ettim ve üzerine tam bir production-grade DevOps altyapısı kurdum.

## Ne Yaptım?

- Multi-stage Dockerfile yazdım, security için non-root user ekledim
- GitHub Actions ile CI/CD pipeline kurdum, Trivy ile her build'de güvenlik taraması yaptım
- Kubernetes ile Deployment, Service, Ingress yazdım
- Resource limits ve health check (gRPC) ekledim
- Terraform ile Azure'da AKS cluster oluşturdum
- ArgoCD kurarak GitOps prensibini uyguladım
- Kendi Helm chart'ımı yazdım
- Prometheus + Grafana ile monitoring kurdum

<img width="1920" height="960" alt="argocd 2ncı" src="https://github.com/user-attachments/assets/084c9b8d-5d10-43c6-a644-775950d4b994" />


## Karşılaştığım Bir Sorun ve Çözümü

Helm chart kullanırken pod'lar sürekli CrashLoopBackOff durumuna düştü. Logları kontrol ettiğimde servisin sorunsuz çalıştığını gördüm, ama health check sürekli başarısız oluyordu.

Sebebini araştırınca: Helm chart'ın default health check'i HTTP protokolü kullanıyordu, ama benim email servisim gRPC protokolü ile çalışıyor. HTTP health check, gRPC servise bağlanamadığı için Kubernetes pod'u "sağlıksız" sanıp sürekli yeniden başlatıyordu.



**Çözüm:** `values.yaml` dosyasındaki `livenessProbe` ve `readinessProbe` ayarlarını HTTP'den gRPC'ye çevirdim:

```yaml
livenessProbe:
  grpc:
    port: 8080
readinessProbe:
  grpc:
    port: 8080
```

Bu değişiklikten sonra pod'lar stabil çalışmaya başladı.

<img width="1920" height="1032" alt="podss" src="https://github.com/user-attachments/assets/bde623b0-a080-4a61-b039-1451bd2cf101" />


## Teknolojiler

Docker, Kubernetes, Helm, ArgoCD, GitHub Actions, Trivy, Terraform, Azure AKS, Prometheus, Grafana

<img width="1920" height="1032" alt="helm list" src="https://github.com/user-attachments/assets/feea34f3-f172-4cf5-a6e1-1a0ad1985c42" />


## Monitoring

<img width="1920" height="951" alt="grafana " src="https://github.com/user-attachments/assets/7b45c3dc-b07f-43c7-93a2-93e57fdb68f3" />


## Erişim

```bash
helm install email-service ./email-chart



```
