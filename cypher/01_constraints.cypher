// -----------------------------------------------------------
// 01. CONFIGURAÇÃO DE RESTRIÇÕES E UNICIDADE
// -----------------------------------------------------------

// Garante que não existam IDs de usuários duplicados
CREATE CONSTRAINT IF NOT EXISTS FOR (u:User) REQUIRE u.id IS UNIQUE;

// Garante que não existam músicas duplicadas pelo ID
CREATE CONSTRAINT IF NOT EXISTS FOR (m:Music) REQUIRE m.id IS UNIQUE;

// Garante que o nome do artista seja único (chave de negócio)
CREATE CONSTRAINT IF NOT EXISTS FOR (a:Artist) REQUIRE a.name IS UNIQUE;

// Garante que o nome do gênero seja único
CREATE CONSTRAINT IF NOT EXISTS FOR (g:Genre) REQUIRE g.name IS UNIQUE;
