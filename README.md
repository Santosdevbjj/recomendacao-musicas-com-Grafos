### Criando um Algoritmo de Recomendação de Músicas Com Base Em Grafos.


![neo4j0001](https://github.com/user-attachments/assets/c40fcde0-eaff-40c9-8e86-c4724c23dfcf)


**Bootcamp Neo4J - Análise de Dados com Grafos.**

---

🎵 **Sistema de Recomendação de Músicas com Grafos usando Neo4j**

**Visão Geral**

Este projeto implementa um sistema de recomendação de músicas baseado em grafos, utilizando Neo4j Aura e Graph Data Science (GDS) para identificar padrões de escuta, similaridade entre usuários e artistas, além de sugerir novas músicas de forma contextual, explicável e escalável.

O foco não está apenas nas tecnologias, mas na capacidade de modelar problemas reais usando grafos, explorando conexões diretas e indiretas entre usuários, músicas, artistas e gêneros.


---

**Problema que o projeto resolve**

• Plataformas de streaming musical enfrentam desafios como:

• Recomendar artistas relevantes mesmo quando não há interação direta

• Explorar gostos musicais indiretos (usuários similares, gêneros relacionados)

• Gerar recomendações explicáveis (por que algo foi recomendado?)

• Identificar artistas centrais e artistas de nicho


Este projeto resolve esses desafios utilizando modelagem orientada a grafos, algo difícil de capturar com bancos relacionais tradicionais.


---

**Objetivo do Projeto**

Aplicar conceitos de Ciência de Dados com Grafos

Utilizar Neo4j Aura (Free Tier) em um cenário real

Explorar algoritmos de grafos (PageRank, Similaridade, Comunidades)

Demonstrar pensamento crítico e intencionalidade técnica



---

**Modelagem do Grafo**

• Tipos de Nós (Nodes)

• User → Usuários da plataforma

• Music → Faixas musicais

• Artist → Artistas

• Genre → Gêneros musicais


**Tipos de Relacionamentos (Edges)**

(:User)-[:LISTENED {count}]->(:Music)

(:User)-[:LIKED]->(:Music)

(:Music)-[:PERFORMED_BY]->(:Artist)

(:Artist)-[:BELONGS_TO]->(:Genre)


**Essa modelagem permite análises por:**

• comportamento individual

• comportamento coletivo

• caminhos indiretos

• centralidade e influência

---



📌 **Diagrama visual da modelagem:**


<img width="1080" height="743" alt="Recomendacao_Grafo" src="https://github.com/user-attachments/assets/0b433da0-a642-4c97-8439-3900e118500c" />




---


**Estrutura do Repositório**


<img width="927" height="1407" alt="Screenshot_20251220-182803" src="https://github.com/user-attachments/assets/83df3628-eeea-44f6-959f-a55fe47fc5e8" />



---

**Explicação das Pastas e Arquivos**

📁 **data/**

raw/ → Dados brutos simulados (inspirados em datasets do Spotify/Kaggle)

processed/ → Dados tratados e normalizados para ingestão no grafo


📁 **model/**

Diagramas visuais da modelagem e do fluxo de recomendação


📁 **cypher/**

Scripts Cypher para:

carga de dados

consultas de recomendação

análises por gênero

recomendações baseadas em caminhos

algoritmos de similaridade e comunidades



📁 **gds/**

Projeção do grafo para GDS

Execução de algoritmos como PageRank


📁 **notebooks/**

Exploração inicial dos dados com Python



---

**Tecnologias Utilizadas**

• Neo4j Aura (Free)

• Cypher Query Language

• Neo4j Graph Data Science (GDS)

• Python

• Pandas

• Jupyter Notebook

• Git & GitHub



---

**Requisitos de Hardware e Software**

**Hardware (mínimo)**

• 4 GB RAM

• CPU Dual Core


**Software**

• Python 3.9+

• Conta gratuita no Neo4j Aura

• Jupyter Notebook

• Navegador Web



---

**Como Executar o Projeto**

1️⃣ Criar banco no Neo4j Aura

Acesse: https://neo4j.com/cloud/aura/

Crie uma instância Free

Salve URI, usuário e senha


2️⃣ **Carregar os dados**

Execute o script:

cypher/load_data.cypher

3️⃣ **Criar projeção do grafo (GDS)**

gds/graph_projection.cypher

4️⃣ **Executar algoritmos de recomendação**

gds/algorithms.cypher
cypher/pagerank.cypher
cypher/similaridade.cypher
cypher/comunidades.cypher


---

**Estratégias de Recomendação Implementadas**

🔹 **Recomendações por Queries**

• Artistas mais ouvidos por gênero

• Ranking por popularidade


🔹 **Recomendações por Caminhos**

**Arquivo:**

cypher/queries_caminhos_avancados.cypher

**Exemplos:**

• Descoberta de artistas a 2 ou mais saltos

• Recomendações explicáveis por caminho

• Conexões cross-genre

**Descoberta de artistas de nicho**


🔹 **Graph Data Science (GDS)**

• PageRank → artistas mais influentes

• Similaridade → artistas similares

• Comunidades (Louvain) → clusters musicais



---

**Aprendizados**

• Modelagem orientada a relacionamentos

• Uso prático de grafos para recomendação

• Diferença entre queries simples e algoritmos de grafos

• Importância da explicabilidade em sistemas de recomendação

• Organização e narrativa técnica em projetos de dados



---

**Próximos Passos**

• Adicionar fator temporal às interações

• Integrar Neo4j Bloom para visualização

• Criar API Python para recomendações em tempo real

• Expandir o dataset com dados reais do Kaggle



---

**Considerações Finais**

Este projeto demonstra como grafos podem ser usados para resolver problemas reais de recomendação, indo além de filtros tradicionais e explorando conexões, contexto e comportamento coletivo.






---



**Contato:**


[![Portfólio Sérgio Santos](https://img.shields.io/badge/Portfólio-Sérgio_Santos-111827?style=for-the-badge&logo=githubpages&logoColor=00eaff)](https://santosdevbjj.github.io/portfolio/)
[![LinkedIn Sérgio Santos](https://img.shields.io/badge/LinkedIn-Sérgio_Santos-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/santossergioluiz) 






---

