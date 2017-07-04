-- Mini Projeto Jogo Pong em Lua - Love2D -
-- Aluno Djair Vieira C de Sousa
-- Disciplina: Jogos   * 8 periodo * Curso: Bacharelado em Sistemas de Informação
-- FAculdade: Facol Faculdade Osman Lins - Vitória Pe


-- DESCRIÇAO DO MINI PROJETO: CRIAÇÃO DO JOGO PONG, MAS QUE TENHA
-- SUPORTE A TECLADO E MOUSE, ONDE OS JOGADORES PODEM ESCOLHER COM
-- QUE CONTROLE (TECLADO OU MOUSE) VÃO USAR.

-- ainda em desenvolvimento
function love.load()
    world = love.physics.newWorld(0, 0, true)

		-- definição dos elementos da bola. painel 1 e painel 2 limite de topo limite do botao fonte e variaveis
    bolinha = {}
        bolinha.b = love.physics.newBody(world, 400, 300, "dynamic")
        bolinha.b:setMass(1)
        bolinha.s = love.physics.newCircleShape(12)
        bolinha.f = love.physics.newFixture(bolinha.b, bolinha.s)
        bolinha.f:setRestitution(1)    -- faz a bolinha saltar
        bolinha.f:setUserData("bolinha")

    painel1 = {}
        painel1.b = love.physics.newBody(world, 40, 300, "dynamic")
        painel1.s = love.physics.newRectangleShape(20, 75)
        painel1.f = love.physics.newFixture(painel1.b, painel1.s, 100000)
        painel1.f:setUserData("Block")

    painel2 = {}
        painel2.b = love.physics.newBody(world, 760, 300, "dynamic")
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
    pontuacao1        = 0
    pontuacao2        = 0
    x           = 0
    y           = 0
    ponto       = ""
    endGame     = "" 
    message     = "O jogo reiniciará em 3 segundos"
	pausar = false
end

function love.update(dt)
    if not pausar then
	world:update(dt)

    if love.keyboard.isDown("w") then		-- Condição para w movimentação da barrinha
       
       painel1.b:setLinearVelocity(0, -400)
    elseif love.keyboard.isDown("s") then   -- Condição para s movimentação da barrinha
       
        painel1.b:setLinearVelocity(0, 400)
    end
    if love.keyboard.isDown("up") then		-- Condição para up movimentação da barrinha
       
        painel2.b:setLinearVelocity(0, -400)
    elseif love.keyboard.isDown("down") then -- Condição para down movimentação da barrinha
       
        painel2.b:setLinearVelocity(0, 400)
    end
	-- Condição para reiniciar a jogada apertar a letra r do teclado
    if love.keyboard.isDown("r") then
        bolinha.velocity = {x = 0, y = 0}
        newRound()
        firstLaunch = true
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
        	bolinha.b:setLinearVelocity(400, 0)
        	firstLaunch = false
    	end
    end
	
    ponto = pontuacao1.." "..pontuacao2	    -- resultado da pontuação
end
end

-- funcao de definição de desenho na tela
function love.draw()
    love.graphics.circle("fill", bolinha.b:getX(),bolinha.b:getY(), bolinha.s:getRadius(), 20)
    love.graphics.polygon("fill", painel1.b:getWorldPoints(painel1.s:getPoints()))
    love.graphics.polygon("fill", painel2.b:getWorldPoints(painel2.s:getPoints()))
    love.graphics.polygon("fill", topLimit.b:getWorldPoints(topLimit.s:getPoints()))
    love.graphics.polygon("fill", bottomLimit.b:getWorldPoints(bottomLimit.s:getPoints()))
    love.graphics.setFont(pontoFont)
	
    if (pontuacao1 ~= 5 or pontuacao2 ~= 5) then
    	love.graphics.printf(ponto, 0, 30, 800, 'center')
    elseif (pontuacao1 == 5) then
    	
	elseif (pontuacao2 == 5) then
		
	end
	
-- Mostra a pontuacao1 e pontuacao2 de cada jogador no centro da tela do Jogo
    love.graphics.setFont(centerFont)
	love.graphics.printf("|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|", 0, 12, 800, 'center')

	if (gameEnd2 == true) then
		love.timer.sleep(3)
		gameEnd2 = false
	end

	if (gameEnd1 == true) then
    	love.graphics.printf(endGame, 0, 10, 800, 'left')
    	love.graphics.printf(message, 0, 10, 800, 'right')
    	pontuacao1 = 0
    	pontuacao2 = 0
    	gameEnd1 = false
    	gameEnd2 = true
    end 
end


--A função keyreleased é disparada quando uma tecla do teclado é liberada.
function love.keyreleased(key)
    if (key == "w") or (key == "s") then
        painel1.b:setLinearVelocity(0,0)
    end

    if (key == "up") or (key == "down") then
        painel2.b:setLinearVelocity(0,0)
    end
	--pausar o jogo
	if (key == "p") or (key == "ç") then
		painel2.b:setLinearVelocity(0,0)  
		pausar = not pausar
	end
end

-- Função para definição dos elementos.
function newRound()
    bolinha.b:setLinearVelocity(0, 0)
    painel1.b:setLinearVelocity(0, 0)
    painel2.b:setLinearVelocity(0, 0)
    bolinha.b:setX(400)
    bolinha.b:setY(300)
    painel1.b:setX(40)
    painel1.b:setY(300)
    painel2.b:setX(760)
    painel2.b:setY(300)
    firstLaunch = true
end