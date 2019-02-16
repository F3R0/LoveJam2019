function debug()
  --player position
  lg.print(math.floor(player.cx) .. ' ' .. math.floor(player.cy), 1, 1)

  --direction
  lg.print(player.direction, 1, 12)
  lg.print(player.state, 1, 23)

  --hitbox
  local hitState = ''
  if player.hit then hitState = 'true' else hitState = 'false' end 
  lg.print('hit: ' .. hitState, 1, 34)
  player.debug = true
end