## Criar script de provisionamento automatizado do WildFly utilizando o JBoss CLI

Desenvolver um script de provisionamento para padronizar e automatizar a configuração do servidor WildFly por meio do JBoss CLI, eliminando etapas manuais de configuração e garantindo reprodutibilidade entre ambientes.

O script deverá contemplar as seguintes atividades:

1. Instalação e registro do driver JDBC

Responsável por disponibilizar ao WildFly o driver necessário para comunicação com o banco de dados corporativo. Essa etapa deve garantir que o driver seja reconhecido pelo servidor de aplicação e possa ser utilizado por datasources e demais componentes que dependam de acesso a banco de dados.

Além da instalação, o processo deve validar a consistência do registro realizado, evitando duplicidade de configurações e assegurando compatibilidade com a versão do WildFly utilizada.

2. Criação e configuração do datasource

Responsável por cadastrar no WildFly uma fonte de dados gerenciada, centralizando os parâmetros de conexão utilizados pelas aplicações.

Essa configuração deve contemplar informações como:

- [x] Nome lógico do datasource.
- [x] Nome JNDI para disponibilização às aplicações.
- [x] Endereço do banco de dados.
- [x] Porta de comunicação.
- [x] Nome da base de dados.
- [x] Credenciais de acesso.
- [x] Configurações específicas do fabricante do banco, quando aplicáveis.

O objetivo é fornecer um ponto único e gerenciado de acesso ao banco de dados, reduzindo o acoplamento entre aplicação e infraestrutura.

3. Configuração do pool de conexões

Responsável por otimizar o uso das conexões com o banco de dados, evitando a abertura e fechamento excessivos de conexões durante a execução das aplicações.

A configuração deve estabelecer critérios relacionados a:

- [x] Quantidade mínima de conexões mantidas disponíveis.
- [x] Quantidade máxima de conexões simultâneas.
- [x] Estratégias de crescimento e redução do pool.
- [x] Controle de tempo ocioso das conexões.
- [x] Reutilização de conexões existentes.
- [x] Tratamento de conexões inválidas ou expiradas.

Essa etapa visa melhorar desempenho, escalabilidade e estabilidade operacional do ambiente.


4. Teste automatizado de conectividade

Ao final do provisionamento, o script deve executar verificações que confirmem o correto funcionamento da configuração realizada.

As validações devem garantir que:

- [x] O driver JDBC está disponível e carregado.
- [x] O datasource foi criado corretamente.
- [x] O datasource encontra-se habilitado.
- [x] O servidor consegue estabelecer comunicação com o banco de dados.
- [x] Não existem erros de autenticação, rede ou configuração.

Essa etapa deve servir como critério de sucesso do provisionamento, permitindo identificar problemas imediatamente após a execução.