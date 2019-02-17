function debug()
  --player position
  lg.print(math.floor(player.x) .. ' ' .. math.floor(player.y), 1, 1)

  --direction
  lg.print(player.direction, 1, 12)
  if player.walk then lg.print('Walking', 1, 23) end
  if player.drag then lg.print('Dragging', 50, 23) end

  --hitbox
  local hitState = ''
  if player.hit then hitState = 'true' else hitState = 'false' end 
  lg.print('hit: ' .. hitState, 1, 34)
  player.debug = true

  --horde
  lg.print('horde count: ' .. horde.count, 1, 45)

  --drag power
  lg.print('drag power: ' .. player.drag_power, 1, 56)
end

function debugCanvas()
  --enemy hitbox
  for i, enemy in ipairs(horde.enemies) do
    lg.rectangle("line", enemy.pos.x, enemy.pos.y, enemy.size.w, enemy.size.h)
  end

  --player hitbox
  if player.face == 1 then
    lg.rectangle("line", player.x, player.y - player.h / 2, player.w / 2, player.h)
  else
    lg.rectangle("line", player.x - player.w / 2, player.y - player.h / 2, player.w / 2, player.h)      
  end
end