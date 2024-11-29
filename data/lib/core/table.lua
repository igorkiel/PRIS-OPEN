function table.size(t)
    local size = 0
    for i, n in pairs(t) do
      size = size + 1
    end
  
    return size
end

function table.dump(t, depth)
  if not depth then depth = 0 end
  for k,v in pairs(t) do
    str = (' '):rep(depth * 2) .. k .. ': '
    if type(v) ~= "table" then
      print(str .. tostring(v))
    else
      print(str)
      table.dump(v, depth+1)
    end
  end
end

function table.empty(t)
  if t and type(t) == 'table' then
    return next(t) == nil
  end
  return true
end