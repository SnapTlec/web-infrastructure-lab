# LAB-01 — Ambiente Web Enterprise

![Story](https://img.shields.io/badge/type-Story-0052CC?style=flat-square)
![High Priority](https://img.shields.io/badge/priority-High-E5493A?style=flat-square)
![Infrastructure](https://img.shields.io/badge/epic-Infrastructure-6B48C7?style=flat-square)
![Status](https://img.shields.io/badge/status-Operational-2DA44E?style=flat-square)
![Sprint](https://img.shields.io/badge/sprint-Sprint%201-0052CC?style=flat-square)
![Estimate](https://img.shields.io/badge/estimate-3--4%20dias-555555?style=flat-square)

---

## Identificação

| Campo       | Valor                          |
|-------------|--------------------------------|
| ID          | `INFRA-001`                    |
| Epic        | Portfólio Enterprise           |
| Tipo        | Story                          |
| Prioridade  | High                           |
| Sprint      | Sprint 1                       |
| Estimativa  | 3–4 dias                       |
| Assignee    | @seu-usuario                   |
| Repositório | `web-infrastructure-lab`       |
| Status      | Operational                    |

---

## Objetivo

Construir um ambiente corporativo completo e funcional que simule uma stack de produção enterprise de ponta a ponta, desde o balanceamento de carga até a camada de dados. O ambiente deve ser reproduzível, documentado e capaz de demonstrar raciocínio operacional avançado sobre disponibilidade, roteamento e sustentação.

---

## Descrição

O lab provisiona, via Docker Compose, um ambiente com quatro camadas distintas e interligadas.

**Camada de entrada — Load Balancer**
HAProxy configurado com health checks ativos, algoritmo round-robin e failover automático para os nós NGINX. Stats page habilitada em porta separada para monitoramento operacional.

**Camada de reverse proxy**
Dois containers NGINX, cada um configurado com virtual hosts, SSL termination com certificado autoassinado via OpenSSL, e regras de `proxy_pass` direcionando para os nós WildFly. Headers de proxy preservados (`X-Real-IP`, `X-Forwarded-For`).

**Camada de aplicação — Middleware**
Dois containers WildFly com a mesma aplicação Java EE (`.war`) implantada, datasource configurado via CLI do WildFly apontando para o SQL Server, connection pool ajustado e logs de deploy acessíveis em volume externo.

**Camada de dados**
Container SQL Server com banco criado via script SQL de inicialização, usuário de aplicação com permissões mínimas e volume persistente para os dados.

Todo o ambiente sobe com um único `docker-compose up -d` e valida-se automaticamente via script de health check que verifica todas as camadas sequencialmente.

---

## Arquitetura

```
Requests Externos (HTTP / HTTPS)
           │
           ▼
    ┌─────────────┐
    │   HAProxy   │  ← Load Balancer · Health Check · Stats Page
    └──────┬──────┘
           │  round-robin
     ┌─────┴─────┐
     ▼           ▼
┌─────────┐ ┌─────────┐
│ NGINX ① │ │ NGINX ② │  ← Reverse Proxy · SSL · Virtual Hosts
└────┬────┘ └────┬────┘
     │           │  proxy_pass
  ┌──┴───┐  ┌───┴──┐
  │  WF  │  │  WF  │  ← WildFly · Java EE · Datasource
  │  ①   │  │  ②   │
  └──────┘  └──────┘
           │
           ▼
   ┌──────────────┐
   │  SQL Server  │  ← Primary · Volume Persistente
   └──────────────┘

Observabilidade: Grafana · Prometheus · Métricas · Alertas
Automação:       Shell Scripts · CI/CD · Health Check
```

---

## Stack técnica

![HAProxy](https://img.shields.io/badge/HAProxy-2.8-lightgrey?style=flat-square)
![NGINX](https://img.shields.io/badge/NGINX-1.25-009639?style=flat-square&logo=nginx&logoColor=white)
![WildFly](https://img.shields.io/badge/WildFly-30-EE0000?style=flat-square)
![SQL Server](https://img.shields.io/badge/SQL%20Server-2022-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white)
![Docker](https://img.shields.io/badge/Docker%20Compose-v3.9-2496ED?style=flat-square&logo=docker&logoColor=white)
![OpenSSL](https://img.shields.io/badge/OpenSSL-autoassinado-721817?style=flat-square)

---

## Pré-requisitos

- Docker Engine 24+ e Docker Compose v2
- Mínimo 4 GB de RAM disponível para os containers
- Portas livres: `80`, `443`, `8404` (HAProxy stats), `9990` (WildFly management), `1433` (SQL Server)
- OpenSSL instalado no host para geração do certificado

---

## Como executar

```bash
# 1. Clone o repositório
git clone https://github.com/SnapTlec/web-infrastructure-lab.git
cd web-infrastructure-lab

# 2. Copie e ajuste as variáveis de ambiente
cp .env.example .env

# 3. Gere o certificado SSL autoassinado
./scripts/gen-cert.sh

# 4. Suba o ambiente completo
docker-compose up -d

# 5. Aguarde os serviços ficarem saudáveis (~60s) e valide
./scripts/healthcheck.sh
```

Após a execução, os endpoints disponíveis são:

| Serviço              | URL                          |
|----------------------|------------------------------|
| Aplicação (HTTPS)    | https://localhost             |
| HAProxy Stats        | http://localhost:8404/stats   |
| WildFly Management   | http://localhost:9990         |

---

## Estrutura do repositório

```
web-infrastructure-lab/
├── haproxy/
│   └── haproxy.cfg
├── nginx/
│   ├── nginx.conf
│   ├── certs/          ← gerado por gen-cert.sh
│   └── conf.d/
│       └── default.conf
├── wildfly/
│   ├── Dockerfile
│   └── provision.sh    ← configura datasource via CLI
├── sqlserver/
│   └── init.sql        ← criação de banco, usuário e seed
├── app/
│   └── enterprise-app.war
├── scripts/
│   ├── gen-cert.sh
│   ├── healthcheck.sh
│   └── deploy-app.sh
├── docs/
│   ├── architecture.md
│   └── troubleshooting.md
├── docker-compose.yml
├── .env.example
└── README.md
```

---

## Tarefas de implementação

- [x] Criar estrutura de diretórios do repositório
- [x] Escrever `haproxy.cfg` com frontend HTTP/HTTPS, backend com dois servidores NGINX, health check ativo e stats page
- [ ] Gerar certificado SSL autoassinado e configurar nos dois nós NGINX
- [ ] Configurar `nginx.conf` com virtual host, upstream para WildFly e headers de proxy corretos
- [ ] Criar script de provisionamento WildFly via `jboss-cli.sh`: módulo JDBC, datasource, connection pool e teste de conectividade
- [ ] Escrever script SQL de inicialização do SQL Server: banco, usuário, tabela de exemplo e dados seed
- [ ] Montar `docker-compose.yml` com redes internas (`frontend-net`, `backend-net`, `db-net`), volumes nomeados e dependências
- [ ] Criar script `healthcheck.sh` que valide todas as camadas e retorne status consolidado
- [ ] Capturar screenshots: stats page HAProxy, resposta da aplicação, logs de deploy WildFly
- [ ] Escrever README enterprise com diagrama, pré-requisitos, instruções e troubleshooting

---

## Critérios de aceite

- [] Ambiente sobe completamente com `docker-compose up -d` sem erros manuais
- [ ] HAProxy distribui requisições entre os dois nós NGINX e detecta falha em menos de 10s
- [ ] NGINX redireciona corretamente para WildFly com headers de proxy preservados
- [ ] Aplicação Java EE responde com HTTP 200 e lê dados do SQL Server via datasource
- [ ] Todos os logs acessíveis em volumes externos sem entrar nos containers
- [ ] Script `healthcheck.sh` retorna status verde para todas as camadas
- [ ] README contém diagrama, instruções e seção de troubleshooting com pelo menos 5 cenários

---

## Troubleshooting

### Backend HAProxy marcado como DOWN
```bash
# Verifique a stats page
curl http://localhost:8404/stats

# Verifique o log do HAProxy
docker-compose logs haproxy | grep -E "DOWN|UP|health"

# Causa mais comum: NGINX não subiu ainda ou porta incorreta no haproxy.cfg
```

### Datasource SQL Server com connection refused
```bash
# Verifique se o SQL Server está aceitando conexões
docker-compose exec wildfly curl -v telnet://sqlserver:1433

# Verifique o log do WildFly
docker-compose logs wildfly | grep -E "ERROR|WARN|datasource"

# Teste a conexão via CLI do WildFly
docker-compose exec wildfly /opt/jboss/wildfly/bin/jboss-cli.sh \
  --connect \
  --command="/subsystem=datasources/data-source=AppDS:test-connection-in-pool"
```

### Aplicação retornando 502 Bad Gateway no NGINX
```bash
# Verifique se o WildFly está respondendo na porta correta
docker-compose exec nginx curl -v http://wildfly-01:8080/enterprise-app/

# Verifique o upstream no nginx.conf
docker-compose exec nginx nginx -t

# Recarregue a config sem downtime
docker-compose exec nginx nginx -s reload
```

### Deploy da aplicação com status .failed
```bash
# Verifique o log de deploy
docker-compose exec wildfly cat /opt/jboss/wildfly/standalone/log/server.log \
  | grep -A 10 "WFLYCTL"

# Causas comuns: driver JDBC ausente, datasource não configurado antes do deploy,
# versão da aplicação incompatível com a versão do WildFly
```

### SQL Server não inicia (erro de memória)
```bash
# SQL Server requer mínimo 2GB. Verifique o limite no docker-compose.yml
docker stats sqlserver

# Ajuste no docker-compose.yml:
# deploy:
#   resources:
#     limits:
#       memory: 2g
```

---

## Próximos passos

- Integrar com LAB-04 (Observabilidade) para monitorar esta stack via Prometheus + Grafana
- Adicionar pipeline CI/CD do LAB-06 para validar configurações a cada push
- Evoluir para cluster WildFly em modo domain para simular ambiente multi-nó real

---

## Referências

- [HAProxy Configuration Manual](https://www.haproxy.org/download/2.8/doc/configuration.txt)
- [NGINX Reverse Proxy Documentation](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
- [WildFly Admin Guide — Datasources](https://docs.wildfly.org/30/Admin_Guide.html#DataSource)
- [SQL Server on Docker — Official Image](https://hub.docker.com/_/microsoft-mssql-server)
