![neo4j0001](https://github.com/user-attachments/assets/c40fcde0-eaff-40c9-8e86-c4724c23dfcf)

# 🎵 Sistema de Recomendação de Músicas com Grafos — Neo4j GDS

![Neo4j](https://img.shields.io/badge/Neo4j-AuraDB_Free-4581C3?style=flat&logo=neo4j&logoColor=white)
![GDS](https://img.shields.io/badge/Neo4j-Graph_Data_Science-00BCD4?style=flat)
![Python](https://img.shields.io/badge/Python-3.9%2B-blue?logo=python&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Status](https://img.shields.io/badge/Status-Concluído-success)
![Bootcamp](https://img.shields.io/badge/Bootcamp-Neo4j_Análise_de_Dados_com_Grafos-purple)

> Sistema de recomendação musical implementado sobre grafo Neo4j — três estratégias complementares: recomendação por gênero, filtro colaborativo por similaridade de comportamento e descoberta de artistas a múltiplos saltos. Algoritmos GDS (PageRank, Louvain, Node Similarity) identificam influência, clusters musicais e similaridade estrutural no grafo.

---

<img width="1080" height="743" alt="Recomendacao_Grafo" src="https://github.com/user-attachments/assets/0b433da0-a642-4c97-8439-3900e118500c" />

---

## 1. Problema de Negócio

Plataformas de streaming como Spotify e Deezer enfrentam um problema fundamental: **sistemas de recomendação baseados apenas em popularidade** recomendam os mesmos artistas para todos, ignorando preferências individuais e conexões indiretas no comportamento coletivo de escuta.

Três lacunas concretas que este projeto ataca:

- **Descoberta indireta:** um usuário pode adorar um artista que nunca ouviu, mas que é diretamente conectado a outro artista que ele ouve frequentemente — bancos relacionais não navegam esse caminho eficientemente.
- **Explicabilidade:** *"por que esse artista foi recomendado?"* é uma pergunta que filtros tradicionais não conseguem responder com o caminho exato no grafo.
- **Identificação de artistas de nicho:** artistas com poucos ouvintes mas alta centralidade em comunidades específicas são invisíveis em rankings de popularidade — PageRank sobre o grafo os expõe.

O objetivo é implementar as três estratégias de recomendação em um grafo Neo4j real, com dados, pipeline de ingestão e algoritmos GDS executáveis — não apenas modelagem conceitual.

---

## 2. Contexto

O projeto foi desenvolvido no **Bootcamp Neo4j – Análise de Dados com Grafos** (DIO), com dataset inspirado em padrões de escuta do Spotify contendo 4 usuários, 8 músicas, 8 artistas e 4 gêneros — escopo pequeno o suficiente para auditar cada relacionamento individualmente, mas representativo das estruturas de grafo que importam: comportamento de escuta ponderado por contagem, preferências explícitas (LIKED), pertencimento de artista a gênero e coatuação implícita por compartilhamento de gênero.

O pipeline segue três camadas:

- **Dados** (`data/raw/` → `data/processed/`) — CSV com histórico de escuta, normalizado para ingestão.
- **Grafo** (`cypher/`) — constraints, ingestão via `LOAD CSV`, queries de recomendação e caminhos avançados.
- **Algoritmos** (`gds/`) — projeção do grafo para GDS e execução de PageRank, Louvain e Node Similarity.

---

## 3. Premissas

- O relacionamento `LISTENED` carrega a propriedade `count` (número de escutas) — usada como peso no PageRank ponderado e no ranking de artistas por força de escuta.
- `LIKED` é um relacionamento separado de `LISTENED`, não uma propriedade — isso permite queries que distinguem "ouviu muito" de "aprovou explicitamente".
- A projeção GDS (`musicGraph`) inclui todos os labels e relacionamentos como `UNDIRECTED` — necessário para algoritmos como Node Similarity que operam em vizinhança bidirecional.
- Os scripts GDS requerem Neo4j GDS Plugin ativo; consultas de recomendação por caminho (`queries_caminhos_avancados.cypher`) funcionam em qualquer instância Neo4j sem plugins adicionais.
- O dataset é simulado mas estruturalmente fiel: padrões de escuta com contagens reais, mix de gêneros por usuário e artistas com diferentes graus de popularidade.

---

## 4. Estratégia da Solução

### Três estratégias de recomendação com lógicas distintas

**Estratégia 1 — Recomendação por gênero**

Navega diretamente do usuário aos gêneros que ele já consome e retorna artistas desses gêneros que ele ainda não ouviu.

```cypher
MATCH (u:User {name: "Ana"})
MATCH (target_g:Genre {name: "Rock"})
MATCH (novo_artista:Artist)-[:BELONGS_TO]->(target_g)
WHERE NOT (u)-[:LISTENED_TO]->(:Music)-[:PERFORMED_BY]->(novo_artista)
RETURN novo_artista.name AS Recomendacao, target_g.name AS Genero;
```

*Caso de uso:* nova sessão sem histórico suficiente para filtro colaborativo — o gênero é o sinal disponível.

**Estratégia 2 — Filtro colaborativo por caminho (2 saltos)**

Encontra usuários com comportamento de escuta similar (músicas em comum) e retorna músicas que eles ouviram mas o usuário-alvo ainda não.

```cypher
MATCH (u:User {id:'1'})-[:LISTENED]->(m1:Music)
      <-[:LISTENED]-(other:User)
      -[:LISTENED]->(m2:Music)
      -[:PERFORMED_BY]->(a:Artist)
WHERE NOT (u)-[:LISTENED]->(:Music)-[:PERFORMED_BY]->(a)
RETURN a.name AS RecommendedArtist, count(*) AS relevance
ORDER BY relevance DESC
LIMIT 5;
```

*Caso de uso:* usuário com histórico — a similaridade é calculada pela sobreposição de escutas, não por perfil demográfico.

**Estratégia 3 — Descoberta cross-genre por caminho de gênero**

Navega do usuário até um gênero através dos artistas que ele ouve e retorna artistas de outros gêneros conectados a esse mesmo gênero — descoberta de músicas fora da bolha.

```cypher
MATCH path = (u:User {id:'1'})-[:LISTENED]->(:Music)
             -[:PERFORMED_BY]->(:Artist)
             -[:BELONGS_TO]->(g:Genre)
             <-[:BELONGS_TO]-(:Artist)
             <-[:PERFORMED_BY]-(:Music)
WHERE length(path) = 6
RETURN DISTINCT g.name AS Genre, last(nodes(path)).name AS RecommendedArtist
LIMIT 10;
```

*Caso de uso:* evitar o problema de bolha de recomendação — encontrar artistas relevantes além do gênero principal do usuário.

### Algoritmos GDS

| Algoritmo | Arquivo | O que mede | Aplicação |
|---|---|---|---|
| PageRank ponderado | `gds/algorithms.cypher` | Influência estrutural dos artistas no grafo | Identificar artistas hub — muito ouvidos por usuários influentes |
| Node Similarity | `cypher/similaridade.cypher` | Similaridade de vizinhança entre artistas | Encontrar artistas com perfil de ouvintes parecido |
| Louvain (comunidades) | `cypher/comunidades.cypher` | Clusters de artistas por padrão coletivo de escuta | Segmentar o catálogo em comunidades musicais orgânicas |

---

## 5. Modelo de Dados

### Labels e propriedades

| Label | Propriedades | Constraint |
|---|---|---|
| `User` | `id`, `name` | `id` UNIQUE |
| `Music` | `id`, `name` | `id` UNIQUE |
| `Artist` | `name` | `name` UNIQUE |
| `Genre` | `name` | `name` UNIQUE |

### Relacionamentos

| Relacionamento | Origem → Destino | Propriedades | Semântica |
|---|---|---|---|
| `LISTENED` | `User → Music` | `count` | Número de escutas — peso para PageRank |
| `LIKED` | `User → Music` | — | Aprovação explícita — sinal de qualidade |
| `PERFORMED_BY` | `Music → Artist` | — | Autoria da faixa |
| `BELONGS_TO` | `Artist → Genre` | — | Classificação de gênero do artista |

### Por que `LIKED` é um relacionamento separado de `LISTENED`?

Em um banco relacional, isso seria uma coluna booleana. Em um grafo, relacionamentos separados permitem queries com semântica clara: `MATCH (u)-[:LIKED]->` retorna apenas aprovações explícitas sem precisar filtrar por propriedade. Além disso, no futuro, `LIKED` pode carregar suas próprias propriedades (`likedAt: datetime()`) independentemente de `LISTENED`.

---

## 6. Pipeline de Dados

```
data/raw/dataset_spotify.csv
         │
         ▼ (EDA: notebooks/exploracao_dados.ipynb)
data/processed/dataset_grafo.csv
         │
         ▼ cypher/01_constraints.cypher   (constraints UNIQUE)
         ▼ cypher/02_ingestion.cypher     (LOAD CSV → nós + relacionamentos)
         │
         ▼ gds/graph_projection.cypher    (projeção em memória para GDS)
         │
         ├──▶ gds/algorithms.cypher       (PageRank → escreve score no nó)
         ├──▶ cypher/similaridade.cypher  (Node Similarity)
         ├──▶ cypher/comunidades.cypher   (Louvain)
         └──▶ cypher/queries_caminhos_avancados.cypher (recomendações por caminho)
```

O notebook Python (`notebooks/exploracao_dados.ipynb`) serve para inspecionar a distribuição de escutas antes da ingestão — verificar se há usuários dominantes, gêneros desbalanceados ou artistas com contagem zero que invalidariam as queries de recomendação.

---

## 7. Decisões Técnicas e Trade-offs

**Por que três estratégias de recomendação em vez de uma?**

Cada estratégia cobre um cenário distinto: recomendação por gênero funciona com histórico mínimo (cold start); filtro colaborativo por caminho requer histórico suficiente para encontrar vizinhos similares; descoberta cross-genre é deliberadamente exploratória. Em produção, as três seriam combinadas com pesos ajustáveis por contexto de uso (nova sessão vs. usuário ativo vs. modo descoberta).

**Por que PageRank ponderado por `count` e não PageRank simples?**

PageRank simples trata todas as arestas como iguais — um usuário que ouviu uma música uma vez tem o mesmo peso que um que a ouviu 50 vezes. Com `relationshipWeightProperty: 'count'`, artistas frequentemente ouvidos por usuários com muitas escutas recebem score maior. A diferença é especialmente relevante para identificar artistas de nicho com público pequeno mas altamente engajado.

**Por que projeção `UNDIRECTED` no GDS?**

Node Similarity e Louvain operam sobre vizinhança — precisam ver que `Music → Artist` e `Artist → Music` são a mesma conexão para calcular similaridade corretamente. Se a projeção fosse `NATURAL` (direcional), dois artistas que compartilham músicas do mesmo usuário não seriam considerados similares pelo algoritmo.

**Trade-off aceito:** `CALL apoc.do.when()` no script de projeção GDS requer APOC Plugin, que não está disponível no AuraDB Free gratuito. Para AuraDB Free, substituir por checagem manual: `CALL gds.graph.exists('musicGraph') YIELD exists` seguido de `CALL gds.graph.drop('musicGraph')` condicional. O script foi mantido com APOC para documentar o padrão correto de produção.

---

## 8. Estrutura do Repositório

```
recomendacao-musicas-com-Grafos/
├── cypher/
│   ├── 01_constraints.cypher                # Constraints UNIQUE — executar primeiro
│   ├── 02_ingestion.cypher                  # LOAD CSV com MERGE de nós e relacionamentos
│   ├── 03_recommendations.cypher            # Recomendação por gênero e filtro colaborativo
│   ├── load_data.cypher                     # Script alternativo de carga (dataset_grafo.csv)
│   ├── pagerank.cypher                      # PageRank via GDS stream
│   ├── similaridade.cypher                  # Node Similarity via GDS
│   ├── comunidades.cypher                   # Louvain via GDS
│   ├── queries_recomendacao.cypher          # Ranking por gênero (Rock, Sertanejo)
│   └── queries_caminhos_avancados.cypher    # 7 queries de recomendação por caminho
├── gds/
│   ├── graph_projection.cypher              # Projeção do grafo em memória para GDS
│   └── algorithms.cypher                    # PageRank ponderado + write ao nó
├── data/
│   ├── raw/dataset_spotify.csv              # Dataset bruto com nomes de usuários
│   └── processed/dataset_grafo.csv          # Dataset normalizado para ingestão
├── notebooks/
│   └── exploracao_dados.ipynb               # EDA com Pandas antes da ingestão
├── model/
│   ├── graph_model.png                      # Diagrama do modelo de dados
│   └── Recomendacao_Grafo.png               # Diagrama do fluxo de recomendação
├── requirements.txt
├── .gitignore
└── README.md
```

---

## 9. Como Executar

**Pré-requisitos:** Python 3.9+, conta Neo4j AuraDB Free com GDS habilitado.

```bash
# 1. Clone o repositório
git clone https://github.com/Santosdevbjj/recomendacao-musicas-com-Grafos.git
cd recomendacao-musicas-com-Grafos

# 2. Instale as dependências Python
pip install -r requirements.txt
```

**No Neo4j Browser (ordem obrigatória):**

```
1. cypher/01_constraints.cypher          ← constraints antes de qualquer dado
2. cypher/02_ingestion.cypher            ← carrega dataset_spotify.csv
3. gds/graph_projection.cypher           ← projeta grafo em memória para GDS
4. gds/algorithms.cypher                 ← PageRank ponderado → escreve no nó
5. cypher/similaridade.cypher            ← Node Similarity entre artistas
6. cypher/comunidades.cypher             ← clusters Louvain
7. cypher/queries_caminhos_avancados.cypher ← recomendações por caminho
```

**Validação após ingestão:**

```cypher
-- Verificar estrutura do grafo
MATCH (n) RETURN labels(n) AS label, COUNT(n) AS total;

-- Verificar relacionamentos por tipo
MATCH ()-[r]->() RETURN type(r) AS tipo, COUNT(r) AS total;

-- Validar PageRank score nos artistas
MATCH (a:Artist) RETURN a.name, a.pagerank ORDER BY a.pagerank DESC;
```

---

## 10. Resultados e Aprendizados

**O que funcionou bem:**

A separação entre queries de caminho (`cypher/`) e algoritmos GDS (`gds/`) tornou o projeto executável em dois modos: sem GDS (apenas com Neo4j puro, usando as queries de caminho) e com GDS (acrescentando PageRank, Louvain e Similarity). Isso aumenta a portabilidade — quem tem AuraDB Free sem GDS ainda consegue executar as recomendações por caminho.

A query de filtro colaborativo por 2 saltos (estratégia 2) foi a mais reveladora: com apenas 4 usuários no dataset, já é possível ver como o grafo conecta Ana e Bruno via Queen e rota essa conexão para recomendar AC/DC para Ana — o mesmo padrão que o Spotify usa em escala de centenas de milhões de usuários.

**O que foi mais desafiador:**

Definir a orientação correta dos relacionamentos na projeção GDS. `NATURAL` (direcional) produz resultados incorretos em Node Similarity porque dois artistas conectados a músicas diferentes nunca se "enxergam" como vizinhos. `UNDIRECTED` resolve isso, mas altera a semântica de PageRank — artistas recebem influência de músicas, não apenas de usuários. A solução foi documentar o trade-off explicitamente em vez de esconder na configuração.

**O que faria diferente:**

Adicionaria `listenedAt: datetime()` no relacionamento `LISTENED` para habilitar recomendações temporais — *"artistas que usuários similares ouviram nas últimas 2 semanas"*. Recomendações sem dimensão temporal tendem a recomendar clássicos sempres em vez de descobertas recentes, o que reduz a percepção de personalização.

---

## 11. Próximos Passos

- [ ] Adicionar `listenedAt: datetime()` no relacionamento `LISTENED` para recomendações temporais
- [ ] Integrar Neo4j Bloom para visualização interativa das comunidades Louvain
- [ ] Criar API REST com FastAPI + driver `neo4j` Python para servir recomendações em tempo real
- [ ] Expandir dataset com dados reais do Kaggle (Spotify Million Playlist Dataset)
- [ ] Implementar A/B test framework para comparar as três estratégias por métrica de clique
- [ ] Adicionar `SKIP_GRAM` embeddings via GDS para recomendação baseada em representação vetorial dos nós

---

## Tecnologias Utilizadas

| Tecnologia | Uso no Projeto |
|---|---|
| Neo4j AuraDB Free | Banco de dados de grafos — execução do modelo |
| Cypher Query Language | Pipeline de ingestão e queries de recomendação |
| Neo4j Graph Data Science (GDS) | PageRank, Node Similarity, Louvain |
| Python 3.9+ / Pandas | EDA do dataset antes da ingestão |
| Jupyter Notebook | Exploração e validação dos dados brutos |

---

## Autor

**Sérgio Santos**
Senior Data Engineer & Cloud Architect

[![Portfólio](https://img.shields.io/badge/Portfólio-Sérgio_Santos-111827?style=for-the-badge&logo=githubpages&logoColor=00eaff)](https://portfoliosantossergio.vercel.app)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Sérgio_Santos-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/santossergioluiz)
[![GitHub](https://img.shields.io/badge/GitHub-Santosdevbjj-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Santosdevbjj)

---

## Licença

Distribuído sob licença MIT. Consulte o arquivo `LICENSE` para mais detalhes.
