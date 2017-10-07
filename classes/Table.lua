Table = {}

  function Table.new(val)
    local this = type(val) == "table" and val or {}
    setmetatable(this, {
      __class = "Table",
      __index = Table,
      __tostring = Table.tostring,
    })
    return this
  end

  function Table:tostring()
    return tostring(self)
  end

  function Table:insert(key, value)
    table.insert(self, value)
    return self
  end

  function Table:add(key, value)
    if value == nil then
      value = key
      table.insert(self, value)
    else
      self[key] = value
    end
    return self
  end

  function Table:clone()
    local meta = getmetatable(self)
    local copy = {}
    for k, v in pairs(self) do
      if type(v) == "table" then
        copy[k] = Table:new(v):clone()
      else
        copy[k] = v
      end
    end
    setmetatable(copy, meta)
    return copy
  end

  -- stream

  function Table:map(callback)
    local new = {}
    for i, v in ipairs(self) do
      table.insert(new, callback(v, i))
    end
    return Table.new(new)
  end
  
  function Table:sort(comparator)
    local new = self:clone()
    table.sort(new, comparator)
    return Table.new(new)
  end

  function Table:filter(condition)
    local new = {}
    for i, v in pairs(self) do
      if condition(v, i) then
        table.insert(new, v)
      end
    end
    return Table.new(new)
  end

  function Table:foreach(callback)
    for i, v in ipairs(self) do
      callback(v, i)
    end
  end

  function Table:matchAll()
    local ret = true
    for i, v in pairs(self) do
      if not v then
        ret = false
        break
      end
    end
    return ret
  end

  function Table:sum()
    local sum = 0
    for i, v in pairs(self) do
      sum = sum + v
    end
    return sum
  end


-- Table Class


return Table