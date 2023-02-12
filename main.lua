font = love.graphics.newFont("AlexBrush-Regular.ttf",25)
love.graphics.setFont(font)


pad1 = {}
pad1.x = 0
pad1.y = 15
pad1.width = 20
pad1.height = 80

pad2 = {}
pad2.x = 780
pad2.y = 400
pad2.width = 20
pad2.height = 80

ball = {}
ball.x = love.graphics.getWidth()/2
ball.y = love.graphics.getHeight()/2
ball.width = 20
ball.height = 20
ball.speed_x = 3
ball.speed_y = 3

score_player1 = 0
score_player2 = 0


function ball_to_center()
    ball.x = love.graphics.getWidth()/2 - ball.width/2
    ball.y = love.graphics.getHeight()/2 - ball.height/2
    ball.speed_x = 3
    ball.speed_y = 3
end

function pad1_move()
    if love.keyboard.isDown("s") and pad1.y < love.graphics.getHeight() - 80 then 
        pad1.y = pad1.y + 2
    end
    if love.keyboard.isDown("z") and pad1.y > 0 then 
        pad1.y = pad1.y - 2
    end
end

function pad2_move()
    if love.keyboard.isDown("down") and pad2.y < love.graphics.getHeight() - 80 then 
        pad2.y = pad2.y + 2
    end
    if love.keyboard.isDown("up") and pad2.y > 0 then 
        pad2.y = pad2.y - 2
    end
end

function ball_move()
    ball.x = ball.x + ball.speed_x
    ball.y = ball.y + ball.speed_y

    -- gestion de la collision du bas
    if ball.y > love.graphics.getHeight() - ball.height then
        ball.speed_y = -ball.speed_y
    end

    -- gestion de la collision de droite
    if ball.x > love.graphics.getWidth() - ball.width then
        ball.speed_x = -ball.speed_x
        score_player2 = score_player2 + 1
        ball_to_center()
    end

    -- gestion de la collision du haut
    if ball.y < 0 then
        ball.speed_y = -ball.speed_y
    end

    -- gestion de la collision de gauche
    if ball.x < 0 then
        ball.speed_x = -ball.speed_x
        score_player1 = score_player1 + 1
        ball_to_center()
    end
end

function collision()
    -- 1ère condition qui gère les collisions du côté du pad1 (celui de gauche)
    if ball.x <= pad1.x + pad1.width then
        if ball.y + ball.height > pad1.y and ball.y < pad1.y + pad1.height then
            ball.speed_x = -ball.speed_x
            love.audio.play(sound)
        end
    end

    -- 2ème condition qui gère les collisions du côté du pad2 (celui de droite)
    if ball.x + ball.height > pad2.x  then
        if ball.y + ball.height > pad2.y and ball.y < pad2.y + pad2.height then
            ball.speed_x = -ball.speed_x
            love.audio.play(sound)
        end
    end
end

function love.load()
    sound = love.audio.newSource("pong_sound.mp3", "static")

    love.graphics.setBackgroundColor(50/255,205/255,50/255)
    ball_to_center()

    --partie du code qui gère la musique de fond
    music = love.audio.newSource("instru.mp3","stream")
    music:setVolume(0.3) 
    music:setPitch(0.8)  --gestion des octaves
    love.audio.play(music) --j'ai mis la musique ici pour éviter de saturer la mémoire dans update
end

function love.update()
    pad1_move()
    pad2_move()
    ball_move()
    collision()
end

function love.draw()
    -- Ces 2 lignes servent à dessiner l'aspect terrain de foot
    love.graphics.line(love.graphics.getWidth()/2,0,love.graphics.getWidth()/2,love.graphics.getHeight())
    love.graphics.circle("line",love.graphics.getWidth()/2 , love.graphics.getHeight()/2, 75)
    
    --graphics settings for pad1
    color = love.graphics.setColor(255/255,0/255,0/255)
    love.graphics.rectangle("fill", pad1.x, pad1.y, pad1.width, pad1.height)
    
    --graphics settings for pad2
    color = love.graphics.setColor(0/255,0/255,255/255)
    love.graphics.rectangle("fill", pad2.x, pad2.y, pad2.width, pad2.height)
    
    --graphics settings for the ball
    color = love.graphics.setColor(250/255,235/255,215/255)
    love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)
    
    local score = score_player1.." - "..score_player2
    love.graphics.print(score, love.graphics.getWidth()/2 -20, 10)
end