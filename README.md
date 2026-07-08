# Backend DevOps - Microservicios con Spring Boot y Docker

## Descripción

Este proyecto implementa una arquitectura de microservicios utilizando Spring Boot, Docker y MySQL.

El sistema está compuesto por dos APIs REST independientes:

* **MS Venta** → Gestión de ventas.
* **MS Despacho** → Gestión de despachos.

Ambos servicios se ejecutan en contenedores Docker y comparten un servidor MySQL mediante redes Docker separadas para la capa de aplicación y la capa de datos.

---

# Arquitectura del Proyecto

```text
backend devops/
│
├── API-REST-VENTA/               # Microservicio de ventas
├── API-REST-DESPACHO/            # Microservicio de despachos
├── Docker-compose.yml            # Orquestación de contenedores
└── mysql/                        # Configuración relacionada a MySQL
```
# Arquitectura del Clúster AWS (EKS)

## Infraestructura

La aplicación fue desplegada sobre Amazon Elastic Kubernetes Service (EKS) en la región **us-east-1**, utilizando una arquitectura basada en microservicios.

### Componentes principales

- Amazon EKS (Cluster: devopseks)
- Node Group administrado por EKS
- Amazon ECR para almacenar imágenes Docker
- Elastic Load Balancer (ELB) para exponer el Frontend
- Kubernetes Deployments
- Kubernetes Services
- Kubernetes Secrets
- Horizontal Pod Autoscaler (HPA)
- Metrics Server
- Amazon CloudWatch (logs del plano de control)

## Arquitectura

Internet
        │
        ▼
Elastic Load Balancer
        │
        ▼
Frontend (Deployment)
        │
        ▼
MS Venta (ClusterIP)
        │
        ▼
MS Despacho (ClusterIP)
        │
        ▼
MySQL (Namespace tienda)

```

## Red de Kubernetes

| Recurso | Función |
|---------|---------|
| Deployment | Administración de Pods |
| Service LoadBalancer | Exposición del Frontend |
| Service ClusterIP | Comunicación interna entre microservicios |
| Secret | Credenciales de la base de datos |
| HPA | Escalado automático |
| Metrics Server | Obtención de métricas CPU/Memoria |

## Seguridad

- Las credenciales de MySQL se almacenan mediante Kubernetes Secrets.
- Las imágenes Docker se almacenan en Amazon ECR.
- Los despliegues se realizan mediante GitHub Actions utilizando credenciales de AWS almacenadas como GitHub Secrets.

## Flujo CI/CD

1. Push a la rama deploy.
2. GitHub Actions compila el proyecto.
3. Se construye la imagen Docker.
4. La imagen se publica en Amazon ECR.
5. El pipeline se conecta al clúster EKS.
6. Kubernetes actualiza el Deployment.
7. Los Pods se recrean automáticamente.

## Escalabilidad

Cada microservicio posee un Horizontal Pod Autoscaler configurado utilizando métricas de CPU.

- ms-venta
- ms-despacho
- tienda-frontend

El escalado automático permite aumentar o disminuir la cantidad de Pods según la carga del sistema.
---

# Tecnologías Utilizadas

* Java 17+
* Spring Boot
* Spring Web
* Spring Data JPA
* MySQL 8
* Docker
* Docker Compose
* Swagger / OpenAPI
* Maven

---

# Microservicios

## 1. MS Venta

Microservicio encargado de la gestión de ventas.

### Funcionalidades

* Crear ventas
* Obtener ventas
* Actualizar ventas
* Eliminar ventas

### Endpoint Base

```http
http://localhost:8081/api/v1/ventas
```

---

## 2. MS Despacho

Microservicio encargado de la gestión de despachos.

### Funcionalidades

* Crear despachos
* Obtener despachos
* Actualizar despachos
* Eliminar despachos

### Endpoint Base

```http
http://localhost:8080/api/v1/despachos
```

---

# Docker Compose

El proyecto utiliza Docker Compose para levantar automáticamente:

* MySQL
* Microservicio de ventas
* Microservicio de despachos

## Servicios Definidos

| Servicio    | Puerto | Descripción           |
| ----------- | ------ | --------------------- |
| mysql       | 3306   | Base de datos MySQL   |
| ms-venta    | 8081   | API REST de ventas    |
| ms-despacho | 8080   | API REST de despachos |

---

# Bases de Datos

Al iniciar el contenedor MySQL se crean automáticamente:

* `venta_db`
* `despacho_db`

Las credenciales por defecto son:

```env
MYSQL_ROOT_PASSWORD=root
```

---

# Cómo Ejecutar el Proyecto

## Requisitos

Antes de comenzar asegúrate de tener instalado:

* Docker
* Docker Compose
* Git

---

## 1. Clonar el repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
cd backend-devops
```

---

## 2. Levantar los contenedores

```bash
docker compose up -d
```

---

## 3. Verificar contenedores

```bash
docker ps
```

Deberías ver:

* mysql_db
* ms_venta
* ms_despacho

---

# Detener los Servicios

```bash
docker compose down
```

---

# Endpoints Principales

## MS Venta

| Método | Endpoint              | Descripción              |
| ------ | --------------------- | ------------------------ |
| GET    | `/api/v1/ventas`      | Obtener todas las ventas |
| GET    | `/api/v1/ventas/{id}` | Obtener venta por ID     |
| POST   | `/api/v1/ventas`      | Crear venta              |
| PUT    | `/api/v1/ventas/{id}` | Actualizar venta         |
| DELETE | `/api/v1/ventas/{id}` | Eliminar venta           |

---

## MS Despacho

| Método | Endpoint                 | Descripción                 |
| ------ | ------------------------ | --------------------------- |
| GET    | `/api/v1/despachos`      | Obtener todos los despachos |
| GET    | `/api/v1/despachos/{id}` | Obtener despacho por ID     |
| POST   | `/api/v1/despachos`      | Crear despacho              |
| PUT    | `/api/v1/despachos/{id}` | Actualizar despacho         |
| DELETE | `/api/v1/despachos/{id}` | Eliminar despacho           |

---

# Redes Docker

El sistema utiliza dos redes:

| Red        | Función                           |
| ---------- | --------------------------------- |
| capa-app   | Comunicación entre microservicios |
| capa-datos | Comunicación con MySQL            |

---

# Persistencia de Datos

Los datos de MySQL se almacenan utilizando un volumen Docker:

```yaml
volumes:
  mysql_data:
```

Esto evita perder información cuando los contenedores son detenidos.

---

# Swagger / OpenAPI

Los microservicios incluyen documentación automática con Swagger.

## Acceso Swagger

### MS Venta

```http
http://localhost:8081/swagger-ui.html
```

### MS Despacho

```http
http://localhost:8080/swagger-ui.html
```

---

# Variables de Entorno

Las variables configuradas en Docker Compose:

```yaml
SPRING_DATASOURCE_URL
SPRING_DATASOURCE_USERNAME
SPRING_DATASOURCE_PASSWORD
```

---

# Comandos Útiles

## Ver logs

```bash
docker compose logs -f
```

## Reiniciar servicios

```bash
docker compose restart
```

## Eliminar contenedores y volúmenes

```bash
docker compose down -v
```

---

# Autor

Proyecto desarrollado con Spring Boot y Docker como práctica de arquitectura de microservicios y DevOps.
