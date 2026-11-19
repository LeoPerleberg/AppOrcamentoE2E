# E2E Android - Robot Framework + Appium

Projeto de testes independente, fora de `AppOrcamento`. As suítes implementam os
casos CT-01 a CT-40 de precificação, resumo, aprovações, cadastros, modelos e
reinício do aplicativo.

## Estrutura

```text
AppOrcamentoE2E/
  .gitignore            # Dependencias, resultados e configuracoes locais
  requirements.txt
  resources/
    app.resource        # Conexao, navegacao, esperas e acoes comuns
    pricing.resource    # Precificacao e dados compartilhados
    catalog.resource    # Cadastro de materiais e servicos
    summary.resource    # Resumo e aprovacoes
    templates.resource  # Modelos
  tests/
    pricing.robot       # CT-01 a CT-14
    summary.robot       # CT-15 a CT-22
    catalog.robot       # CT-23 a CT-32
    templates.robot     # CT-33 a CT-39
    state.robot         # CT-40: reinicio do aplicativo
  results/              # Relatorios gerados (ignorado pelo Git)
```

Cada teste recebe uma tag com seu identificador (`ct-01`, por exemplo) e uma
prioridade (`p1` ou `p2`). Os testes básicos também recebem a tag `smoke`.

## 1. Preparar o ambiente

Pré-requisitos: Python 3.10+, Node.js 22.12+ (linha 22), npm 10+, JDK e Android
SDK configurados para o app. Defina `ANDROID_HOME` e inclua
`%ANDROID_HOME%\platform-tools` no `PATH` para usar `adb`.
Com UiAutomator2 6 ou posterior, use um dispositivo Android 8 ou superior
(API 26+).

No PowerShell, a partir desta pasta:

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
npm install --global appium@3
appium driver install uiautomator2
appium driver doctor uiautomator2
```

Não é necessário ativar o ambiente virtual. O servidor Appium e o driver são
instalados separadamente da biblioteca Python.

## 2. Preparar o aplicativo

Abra um emulador Android ou conecte um aparelho de teste com depuração USB
autorizada:

```powershell
adb devices
```

Este projeto contém apenas os testes. Instale o aplicativo `AppOrcamento`
separadamente e mantenha o Metro em execução, seguindo as instruções do README
do próprio aplicativo. O build debug depende do Metro. Para um dispositivo
conectado por USB ou emulador, encaminhe a porta, substituindo o identificador
pelo exibido em `adb devices`:

```powershell
adb -s emulator-5554 reverse tcp:8081 tcp:8081
```

Os testes abrem o app **já instalado**, usando o pacote `com.apporcamento` e a
activity `com.apporcamento.MainActivity`; não compilam nem instalam APKs.

> **Use um dispositivo de teste.** Cada caso reinicia o aplicativo e perde os
> dados que ele mantém em memória. Os casos também criam, alteram e excluem
> cadastros, modelos e aprovações durante a execução.

## 3. Iniciar o Appium

Em outro terminal, mantenha o servidor em primeiro plano:

```powershell
appium --address 127.0.0.1 --port 4723
```

É usado o endereço raiz do Appium 3, sem `/wd/hub`.

## 4. Executar

Nesta pasta, com app instalado, Metro, dispositivo e Appium disponíveis:

```powershell
.\.venv\Scripts\python.exe -m robot --outputdir results --variable UDID:emulator-5554 tests
```

Troque `emulator-5554` pelo identificador do seu dispositivo. Para outro servidor,
adicione `--variable APPIUM_URL:http://127.0.0.1:4723`.

Exemplos de seleção:

```powershell
# Somente cenarios basicos
.\.venv\Scripts\python.exe -m robot --outputdir results --variable UDID:emulator-5554 --include smoke tests

# Um caso especifico
.\.venv\Scripts\python.exe -m robot --outputdir results --variable UDID:emulator-5554 --include ct-08 tests

# Somente a suite de cadastros
.\.venv\Scripts\python.exe -m robot --outputdir results --variable UDID:emulator-5554 tests\catalog.robot
```

Relatórios: `results\report.html`, `results\log.html` e `results\output.xml`.
Quando há sessão disponível, a captura de uma falha é incorporada ao `log.html`.

Para validar imports, sintaxe e keywords **sem executar no dispositivo**:

```powershell
.\.venv\Scripts\python.exe -m robot --dryrun --outputdir results\dryrun tests
```

## Versionamento

Os testes, recursos, `requirements.txt`, README e `.gitignore` podem ser
versionados separadamente do aplicativo. O `.gitignore` exclui ambientes
virtuais, dependências locais, `results/`, os relatórios padrão do Robot na raiz,
logs, caches, configurações de editor e arquivos `.env`. Ele permite versionar um
eventual `.env.example`, que não deve conter segredos.

Antes de criar um commit, revise `git status --short` e confira se não há dados
sensíveis ou resultados gerados fora dos caminhos ignorados. O `.gitignore` não
remove arquivos que já estejam rastreados pelo Git.

## Observações

- Escopo somente Android; não há configuração de iOS.
- Cada teste abre uma sessão e força a reinicialização do app. `noReset` evita
  apagar dados persistentes, mas o estado atual do aplicativo é apenas em memória.
  Se isso mudar, a estratégia de isolamento precisará ser revista.
- Os testes usam textos e hierarquia da interface, sem modificar o aplicativo.
  Mudanças na interface podem exigir atualização dos localizadores nos recursos.
- No CT-26, o custo negativo é testado quando o teclado aceita o sinal; caso o
  próprio teclado o remova, o teste verifica essa restrição.
- Não foram automatizadas regras ainda não definidas para custo não numérico,
  quantidade zero em modelos e margem negativa.
- `Connection refused`: confira o Appium e `APPIUM_URL`.
- Dispositivo não encontrado: confira `adb devices` e `UDID`.
- Tela do Metro/erro de conexão: confira o Metro e `adb reverse`.
