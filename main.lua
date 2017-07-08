-- Mini Projeto Jogo Pong em linguagem de Programação Lua - Utilizando o FrameWork: Love2D -
-- Aluno: Djair Vieira C de Sousa.
-- Disciplina: Jogos
-- Professor: Fabio Chicout  * 8 periodo * Curso: Bacharelado em Sistemas de Informação 2017.1
-- Faculdade: Facol Faculdade Escritor Osman Lins - Vitória de Santo Antão - Pe - Julho de 2017

-- DESCRIÇAO DO MINI PROJETO SIMPLES: CRIAÇÃO DO JOGO PONG, MAS QUE TENHA
-- SUPORTE A TECLADO E MOUSE, ONDE OS JOGADORES PODEM ESCOLHER COM
-- QUE CONTROLE (TECLADO OU MOUSE) VÃO USAR.

-- FINALIZADO 08/07/2017


function love.load()

    teclado_imagem = love.graphics.newImage("teclado150x150.png")  -- carregamento da imagem na tela Teclado
    mouse_imagem = love.graphics.newImage("mouse150x150.png")      -- carregamento da imagem na tela Mouse

    world = love.physics.newWorld(0, 0, true)

		-- definição dos elementos da tela "body"
    bolinha = {}
        bolinha.b = love.physics.newBody(world, 400, 300, "dynamic")
        bolinha.b:setMass(1)
        bolinha.s = love.physics.newCircleShape(12)
        bolinha.f = love.physics.newFixture(bolinha.b, bolinha.s)
        bolinha.f:setRestitution(1)    -- faz a bolinha saltar
        bolinha.f:setUserData("bolinha")

    painel1 = {}
    p1x = 40
    p1y = 300
        painel1.b = love.physics.newBody(world, p1x, p1y, "dynamic")
        painel1.s = love.physics.newRectangleShape(20, 75)
        painel1.f = love.physics.newFixture(painel1.b, painel1.s, 100000)
        painel1.f:setUserData("Block")

    painel2 = {}
    p2x = 760
    p2y = 300
        painel2.b = love.physics.newBody(world, p2x, p2y, "dynamic")
        painel2.s = love.physics.newRectangleShape(20, 75)
        painel2.f = love.physics.newFixture(painel2.b, painel2.s, 100000)
        painel2.f:setUserData("Block")

    topLimit = {}
        topLimit.b = love.physics.newBody(world, 400, 0, "static")
        topLimit.s = love.physics.newRectangleShape(800, 10)
        topLimit.f = love.physics.newFixture(topLimit.b, topLimit.s)
        topLimit.f:setUserData("Block")

    bottomLimit = {}
        bottomLimit.b = love.physics.newBody(world, 400, 600, "static")
        bottomLimit.s = love.physics.newRectangleShape(800, 20)
        bottomLimit.f = love.physics.newFixture(bottomLimit.b, bottomLimit.s)
        bottomLimit.f:setUserData("Block")

    pontoFont = love.graphics.newFont(90) -- fonte graphics
    centerFont = love.graphics.newFont(20) --centralizar a fonte graphics

    firstLaunch = true
    gameEnd1    = false
    gameEnd2    = false
    pontuacao1  = 0
    pontuacao2  = 0
    x           = 0
    y           = 0
    ponto       = ""
    endGame     = ""
    message     = "O jogo reiniciará em 7 segundos"
	  pausar = false


    controller1 = ""
    controller2 = ""
    mensagem1 = ""
    mensagem2 = ""
    questionOpcao = 0
    opcao = 0

    valor = ""
    estadoT = true
    estadoM = true
    jogador1 = true
    jogador2 = true

end

function love.draw()

    infoFont = love.graphics.newFont(18)
    love.graphics.setFont(infoFont)
    if opcao == 0 then
      love.graphics.setColor(255, 127, 80)
      opcaoController()
      love.graphics.setColor(255, 255, 255)
    end

    love.graphics.setFont(pontoFont) -- volta para a fonte original

    love.graphics.circle("fill", bolinha.b:getX(),bolinha.b:getY(), bolinha.s:getRadius(), 20)
    love.graphics.polygon("fill", painel1.b:getWorldPoints(painel1.s:getPoints()))
    love.graphics.polygon("fill", painel2.b:getWorldPoints(painel2.s:getPoints()))
    love.graphics.polygon("fill", topLimit.b:getWorldPoints(topLimit.s:getPoints()))
    love.graphics.polygon("fill", bottomLimit.b:getWorldPoints(bottomLimit.s:getPoints()))
    love.graphics.setFont(pontoFont)



  -- Condição onde verifica a pontuacao1 e pontuacao2 de cada player e com o print mostra a pontuacao de cada um no centro da tela do jogo
  if (pontuacao1 ~= 5 or pontuacao2 ~= 5) then
    	love.graphics.printf(ponto, 0, 30, 800, 'center')
    elseif (pontuacao1 == 5) then
    elseif (pontuacao2 == 5) then
	end

  -- Mostra a pontuacao1 e pontuacao2 de cada jogador no centro da tela do Jogo
  love.graphics.setFont(centerFont)
	love.graphics.printf("|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|", 0, 12, 800, 'center')

  -- Condição para quando o Jogo acabar iniciar o Timer de 7 segundos para começar uma próxima partida
	if (gameEnd2 == true) then
		love.timer.sleep(7)
		gameEnd2 = false
	end

  -- Condição caso o gameEnd1 for verdadeiro mostre quem vencer e final da rodada atraves de uma mensagem na tela.
	if (gameEnd1 == true) then
    	love.graphics.printf(endGame, 0, 10, 800, 'left')
    	love.graphics.printf(message, 0, 10, 800, 'right')
    	pontuacao1 = 0
    	pontuacao2 = 0
    	gameEnd1 = false
    	gameEnd2 = true
  end

  -- Definição da pontuação dos player 1 e player 2
    x = bolinha.b:getX()
    if (x > 800) then
        pontuacao1 = pontuacao1 + 1
        newRound()
        firstLaunch = true
      elseif (x < 0) then
        pontuacao2 = pontuacao2 + 1
        newRound()
        firstLaunch = true
    end

  -- Condição para mostrar qual player é o vencedor da partida
    if (pontuacao1 == 5) then
      endGame = "Player 1 você é o Ganhador!"
      gameEnd1 = true
     elseif (pontuacao2 == 5) then
      endGame = "Player 2 você é o Ganhador!"
      gameEnd1 = true
    end

  -- Condição de velocidade do jogo
    if (gameEnd1 ~= true and gameEnd2 ~= true) then
        if (firstLaunch == true) then
            bolinha.b:setLinearVelocity(400, 60)
            firstLaunch = false
        end
    end
    ponto = pontuacao1.." "..pontuacao2	    -- resultado da pontuação


  end

function love.update(dt)

    if not pausar then   						-- Condição para pausar o jogo dentro da function love.uptade
    	  world:update(dt)
        controllers()

        if love.keyboard.isDown("r") then       -- Condição para reiniciar a jogada quando apertar a letra r do teclado
           bolinha.velocity = {x = 0, y = 0}    -- bolinha inicia a partir da coordenada do centro eixo X e do eixo y
           newRound()
           firstLaunch = true
        end
    end
end


-- Função para definição dos elementos.
function newRound()
    bolinha.b:setX(400)
    bolinha.b:setY(300)
    painel1.b:setX(40)
    painel1.b:setY(300)
    painel2.b:setX(760)
    painel2.b:setY(300)
    bolinha.b:setLinearVelocity(0, 0)
    painel1.b:setLinearVelocity(0, 0)
    painel2.b:setLinearVelocity(0, 0)
    firstLaunch = true
end

-- A função keyreleased é disparada quando uma tecla do teclado é liberada.
function love.keyreleased(key)
    if (key == "w") or (key == "s") then
        painel1.b:setLinearVelocity(0,0)
    end

    if (key == "up") or (key == "down") then
        painel2.b:setLinearVelocity(0,0)
    end
-- Condição se a tecla "p" for acionada eu quero que todo o jogo pare
	 if (key == "p") then
		   painel2.b:setLinearVelocity(0,0)
		   pausar = not pausar

	 end
end


function opcaoController()
    --[[
        usuario escolhe qual controle usar, optando entre jogar ou com o teclado, ou com o mouse,
        de modo que dois jogadores usem sempre um tipo de controle diferente, nunca o mesmo tipo
    ]]

pausar = true

if valor == "m" or valor == "k" or valor == "" then -- se foi pressionado a tecla k ou m ou nenhuma delas


          if estadoT then
            love.graphics.printf("selecione clicando abaixo com o mouse\n em uma opção de controle", 0, 120, 800, 'center')
            love.graphics.setColor(255, 255, 0)
            love.graphics.printf("Mapas de Teclas do Jogo:\n\n'w', scroll do mouse para cima, seta pra cima -> CIMA\n's',  scroll do mouse para baixo,  e seta pra baixo -> BAIXO\n'r' - REINICIA A JOGADA\n'p' - PAUSAR O JOGO", 80, 410, 800, 'left')
            love.graphics.setColor(255, 127, 80)
            love.graphics.draw(teclado_imagem, 225, 175)
          end

          if estadoM then
            love.graphics.printf("selecione clicando abaixo com o mouse\n em uma opção de controle", 0, 120, 800, 'center')
            love.graphics.setColor(255, 255, 0)
            love.graphics.printf("Mapas de Teclas do Jogo:\n\n'w', scroll do mouse para cima, seta pra cima -> CIMA\n's',  scroll do mouse para baixo,  e seta pra baixo -> BAIXO\n'r' - REINICIA A JOGADA\n'p' - PAUSAR O JOGO", 80, 410, 800, 'left')
            love.graphics.setColor(255, 127, 80)
                love.graphics.draw(mouse_imagem, 425, 175)
          end

          if not estadoT  and  estadoM then -- se opcao teclado foi clicado
            love.graphics.printf("Jogador 1 ficou com o\n TECLADO", -200, 350, 800, 'center')
            love.graphics.printf("Jogador 2 ficou com o\n MOUSE", 200, 350, 800, 'center')
            love.graphics.printf("Clique na imagem do\nMOUSE ao lado para começar ", -150, 220, 800, 'center')
            controller1 = "k"
            controller2 = "m"
          end

          if estadoT and not estadoM then -- se opcao mouse foi clicado
            love.graphics.printf("Jogador 1 ficou com o\n MOUSE", -200, 350, 800, 'center')
            love.graphics.printf("Jogador 2 ficou com o\n TECLADO ", 200, 350, 800, 'center')
            love.graphics.printf("Clique na imagem do\nTECLADO ao lado para começar ", 150, 220, 800, 'center')
            controller1 = "m"
            controller2 = "k"
          end

          if not jogador1 and not jogador2 then -- manter o jogo pausado ate a tela de opçao de controle sair
            pausar = false
            opcao = 1

          end
    end

end


function controllers()
  if controller1 == "k" then

        if love.keyboard.isDown("w") then		     -- Condição para w movimentação da barrinha
           painel1.b:setLinearVelocity(0, -400)
        elseif love.keyboard.isDown("s") then    	 -- Condição para s movimentação da barrinha
            painel1.b:setLinearVelocity(0, 400)
        end
  end

  if controller2 == "k" then

        if love.keyboard.isDown("up") then		   -- Condição para up movimentação da barrinha
            painel2.b:setLinearVelocity(0, -400)
        elseif love.keyboard.isDown("down") then   -- Condição para down movimentação da barrinha
            painel2.b:setLinearVelocity(0, 400)
        end
  end

  if controller1 == "m" then
    -- FUNÇÃO QUE HABILITA O JOGADOR UTILIZAR O MOUSE : esse botão de scroll no meio do mous
        function love.wheelmoved(x, y)
            if y > 0 then  -- move para cima
                painel1.b:setLinearVelocity(0, -400)
                painel1.b:setLinearDamping(1.1)
            elseif y < 0 then -- move para baixo
                painel1.b:setLinearVelocity(0, 400)
                painel1.b:setLinearDamping(1.1)
            end

        end
  end
--[[]]
  if  controller2 == "m" then
    -- FUNÇÃO QUE HABILITA O JOGADOR UTILIZAR O MOUSE : esse botão de scroll no meio do mous
        function love.wheelmoved(x, y)
            if y > 0 then -- move para cima
                painel2.b:setLinearVelocity(0, -400)
                painel2.b:setLinearDamping(1.1)
            elseif y < 0 then -- move para baixo
                painel2.b:setLinearVelocity(0, 400)
                painel2.b:setLinearDamping(1.1)
            end

        end
  end
end

function love.mousepressed(x, y, button, istouch)

   if button == 1 then
     if (x >= 225 and x <= 375 and y >= 175 and y <= 325) and estadoT then

         valor = "k"
         estadoT = false
         jogador1 = false

         end
     if (x >= 425 and x <= 575 and y >= 175 and y <= 325) and estadoM then

         valor = "m"
         estadoM = false
         jogador2 = false

         end
   end
end
