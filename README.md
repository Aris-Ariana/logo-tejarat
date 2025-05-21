# logo-tejarat

## Dockerfile for OpenShift
```
RUN chgrp -R 0 /var/cache/nginx /var/run /etc/nginx /usr/share/nginx/html && \
    chmod -R g=u /var/cache/nginx /var/run /etc/nginx /usr/share/nginx/html
```

---

## With Docker Run
```bash
docker build -t seminar-web:v1 .

docker build -t seminar-web:v2 .

docker run -d -p 8080:8080 --name seminar-container seminar-web:v1
```

---

## With Docker Compose Volume
```bash
docker compose -f docker-compose-volume.yaml up -d

docker compose -f docker-compose-volume.yaml down
```

## With Docker Compose Production
```bash
docker compose -f docker-compose-prod.yaml up -d

docker compose -f docker-compose-prod.yaml down

nano docker-compose-prod.yaml # Change the image to v2

docker compose -f docker-compose-prod.yaml up -d
```

---

## Push to Registry
```bash
docker tag seminar-web:v1 registry.sarvrayaneh.com/test/seminar-web:v1
docker tag seminar-web:v2 registry.sarvrayaneh.com/test/seminar-web:v2

docker push registry.sarvrayaneh.com/test/seminar-web:v1
docker push registry.sarvrayaneh.com/test/seminar-web:v2
```

---

# OpenShift
1. Create deployment
2. Create Service
    ```bash
    oc expose deployment logo-tejarat --port=8080 --target-port=8080 --name=logo-tejarat-service -n seminar
    ```
3. Create Route
   ```bash
   oc expose service logo-tejarat-service -n seminar
   ```
4. Get URL
   ```bash
   oc get route logo-tejarat-route -n seminar -o jsonpath='{.spec.host}'
   ```

---

## Make sure Always get the latest image
```bash
imagePullPolicy: Always
```
### Maybe need to change the iamge tag
```bash
registry.sarvrayaneh.com/test/seminar-web:v3.1
```
## Check the created time of image
```bash
docker inspect registry.sarvrayaneh.com/test/seminar-web:v3 | grep -i created
```

---

# Check logs
```bash
oc logs deployment/logo-tejarat -n seminar
oc logs pod/<POD-NAME> -c nginx -n seminar
oc describe pod <POD-NAME> -n seminar
```

---

# Not recommended
```bash
oc adm policy add-scc-to-user anyuid -z default -n seminar
```
## Final proposed version for default SCC compatible securityContext:
```yaml
spec:
  containers:
    - name: your-container
      securityContext:
        allowPrivilegeEscalation: false
        capabilities:
          drop:
            - ALL
        seccompProfile:
          type: RuntimeDefault
```
