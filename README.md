# KWIC - Keyword-In-Context
## Implementação em Haskell seguindo o Estilo "The One"

### Descrição do Projeto

Este projeto implementa o algoritmo KWIC (Keyword in Context) utilizando a linguagem Haskell e seguindo o estilo de programação "The One", conforme descrito no livro "Exercises in Programming Style" da Professora Crista Lopes. O algoritmo KWIC recebe uma lista de títulos ou frases e gera uma lista alfabetizada de todas as palavras-chave contidas nesses títulos, apresentando cada palavra junto com seu contexto circundante através de deslocamento circular.

O programa processa um arquivo de texto de entrada contendo frases ou títulos, uma por linha, e produz uma saída ordenada alfabeticamente onde cada palavra-chave significativa é apresentada no início de sua linha através de rotação circular, mantendo o contexto original.

### Funcionalidades

O sistema implementa as seguintes funcionalidades principais:

- Leitura de arquivo de texto de entrada
- Filtragem de palavras vazias (stop words) em português e inglês
- Geração de contextos de palavras-chave através de deslocamento circular
- Ordenação alfabética dos resultados
- Formatação da saída com indicação da frase original

### Como Executar

#### Pré-requisitos

Para executar este programa, é necessário ter o GHC (Glasgow Haskell Compiler) instalado no sistema. O GHC pode ser obtido através do Haskell Platform ou instalado individualmente.

#### Compilação

Para compilar o programa, execute o seguinte comando no terminal:

```bash
ghc -o kwic Main.hs
```

#### Execução

Após a compilação, execute o programa fornecendo o caminho para o arquivo de entrada:

```bash
./kwic arquivo_entrada.txt
```

O programa exibirá os resultados diretamente no terminal.

#### Exemplo de Uso

Considere um arquivo de entrada `exemplo.txt` com o seguinte conteúdo:

```
The quick brown fox
A brown cat sat
The cat is brown
```

A execução do programa produzirá a seguinte saída:

```
brown The cat is (from "The cat is brown")
brown cat sat A (from "A brown cat sat")
brown fox The quick (from "The quick brown fox")
cat is brown The (from "The cat is brown")
cat sat A brown (from "A brown cat sat")
fox The quick brown (from "The quick brown fox")
quick brown fox The (from "The quick brown fox")
```

### Arquitetura do Código

A implementação segue uma arquitetura modular organizada em torno do padrão "The One", estruturada da seguinte forma:

#### Abstração Principal (TFTheOne)

O núcleo da implementação é a estrutura `TFTheOne`, que encapsula valores e fornece operações para encadeamento de funções. Esta abstração implementa o padrão Identity Monad através das seguintes operações:

- `wrap`: Função construtora que encapsula um valor na abstração
- `bind`: Operação que aplica uma função ao valor encapsulado e reencapsula o resultado
- `unwrap`: Extrai o valor final da abstração
- `printResult`: Operação específica para exibição dos resultados

#### Funções de Processamento

O programa é composto por funções puras que processam os dados sequencialmente:

- `readFileContent`: Realiza a leitura do arquivo de entrada
- `splitIntoLines`: Divide o conteúdo em linhas individuais
- `cleanAndSplitWords`: Limpa e separa palavras, removendo caracteres especiais
- `generateKeywordContexts`: Cria pares de palavra-chave e contexto original
- `createCircularShift`: Implementa o deslocamento circular das palavras
- `sortKeywordContexts`: Ordena os contextos alfabeticamente
- `formatOutput`: Formata a saída final com informações de contexto

#### Pipeline Principal

A função `processKWIC` demonstra o estilo "The One" através do encadeamento de operações:

```haskell
let result = wrap content
            `bind` splitIntoLines
            `bind` generateAllKeywordContexts
            `bind` applyCircularShifts
            `bind` sortKeywordContexts
            `bind` formatOutput
```

### O Estilo "The One"

O estilo "The One" é uma variação na composição de funções que estabelece uma abstração que serve como elo entre valores e funções. Este estilo origina-se do Identity Monad em Haskell e apresenta as seguintes características distintivas:

#### Princípios Fundamentais

O estilo baseia-se em três operações essenciais: a operação de encapsulamento (wrap) que converte valores simples na abstração, a operação de ligação (bind) que alimenta valores encapsulados para funções, e a operação de desencapsulamento que extrai o resultado final.

#### Vantagens do Estilo

A principal vantagem deste estilo é a capacidade de escrever cadeias de funções da esquerda para a direita, em contraste com a composição tradicional de funções que ocorre da direita para a esquerda. Isso resulta em código mais legível e intuitivo, especialmente para operações sequenciais de transformação de dados.

#### Características na Implementação

Na implementação KWIC, o estilo "The One" manifesta-se através do encadeamento linear de transformações, onde cada função recebe o resultado da função anterior através da operação `bind`. Isso cria um pipeline claro e expressivo que reflete diretamente o fluxo lógico do algoritmo KWIC.

### Tratamento de Stop Words

O programa inclui uma lista predefinida de palavras comuns em português e inglês que são filtradas durante o processamento. Esta lista pode ser facilmente expandida conforme necessário para diferentes domínios ou idiomas.

### Considerações de Implementação

A implementação em Haskell aproveita as características funcionais da linguagem, mantendo todas as funções puras exceto pelas operações de entrada e saída. O tratamento de casos especiais, como palavras não encontradas durante o deslocamento circular, é realizado através de pattern matching e tipos Maybe, garantindo robustez do programa.

O programa demonstra como o estilo "The One" pode ser naturalmente implementado em Haskell, aproveitando o sistema de tipos da linguagem e sua orientação funcional para criar uma solução elegante e expressiva para o problema KWIC.

### Testes Automatizados

A avaliação também requer a implementação de **testes unitários** para as principais funções do algoritmo KWIC. Esses testes foram desenvolvidos com a biblioteca [HUnit](https://hackage.haskell.org/package/HUnit), compatível com a linguagem Haskell.

#### Estilo "The One" nos Testes

Seguindo o estilo de programação *The One*, os testes utilizam a mesma abstração `wrap`, `bind` e `unwrap` aplicada na lógica principal do programa. Essa abordagem reforça a consistência de estilo em todo o projeto, inclusive nos testes.

Exemplo:

```haskell
testSplitIntoLines = TestCase $
  let input = "The quick brown fox\nA brown cat sat\nThe cat is brown\n"
      expected = ["The quick brown fox", "A brown cat sat", "The cat is brown"]
      result = unwrap (wrap input `bind` splitIntoLines)
  in assertEqual "Split lines using The One" expected result
```

#### Como Executar os Testes

1. Certifique-se de ter a biblioteca `HUnit` instalada.
2. Compile o arquivo de testes com o seguinte comando:

```bash
ghc -o test TestKWIC.hs -main-is TestKWIC.main -package HUnit
```

3. Execute os testes no terminal:

```bash
./test
```

A saída exibirá os resultados de cada verificação feita.

---

### Arquivos Entregues

- `Main.hs`: Contém a função principal que chama o módulo KWIC
- `Kwic.hs`: Implementação do algoritmo KWIC utilizando o estilo The One
- `TestKWIC.hs`: Testes automatizados que seguem o mesmo estilo
- `README.md`: Documentação detalhada do projeto e instruções de execução

---