-- protocoldeletecharacter.lua

-- @docclass
ProtocolDeleteCharacter = extends(Protocol, "ProtocolDeleteCharacter")

function ProtocolDeleteCharacter:deleteCharacter(host, port, characterName, recoveryKey)
  if string.len(host) == 0 or port == nil or port == 0 then
    signalcall(self.onDeleteCharacterError, self, tr("You must enter a valid server address and port."))
    return
  end

  self.characterName = characterName
  self.recoveryKey = recoveryKey
  self.connectCallback = self.sendDeleteCharacterPacket
  self:connect(host, port)
end

function ProtocolDeleteCharacter:cancelDeleteCharacter()
  self:disconnect()
end

function ProtocolDeleteCharacter:sendDeleteCharacterPacket()
  local msg = OutputMessage.create()

  print("Sending delete character packet for:", self.characterName)  -- Add print statement

  msg:addU8(ClientOpcodes.ClientDeleteCharacter)
  msg:addU16(g_game.getOs())
  msg:addU16(g_game.getProtocolVersion())

  if g_game.getFeature(GameClientVersion) then
    msg:addU32(g_game.getClientVersion())
  end

  if g_game.getFeature(GameContentRevision) then
    msg:addU16(g_things.getContentRevision())
    msg:addU16(0)
  else
    msg:addU32(g_things.getDatSignature())
  end
  msg:addU32(g_sprites.getSprSignature())
  msg:addU32(PIC_SIGNATURE)

  if g_game.getFeature(GamePreviewState) then
    msg:addU8(0)
  end

  local offset = msg:getMessageSize()

  if g_game.getFeature(GameLoginPacketEncryption) then
    msg:addU8(0) -- first RSA byte must be 0

    -- xtea key
    self:generateXteaKey()
    local xteaKey = self:getXteaKey()
    msg:addU32(xteaKey[1])
    msg:addU32(xteaKey[2])
    msg:addU32(xteaKey[3])
    msg:addU32(xteaKey[4])
  end
  
  msg:addString(self.characterName)
  msg:addString(self.recoveryKey)

  local paddingBytes = g_crypt.rsaGetSize() - (msg:getMessageSize() - offset)

  assert(paddingBytes >= 0)
  for i = 1, paddingBytes do
    msg:addU8(math.random(0, 0xff))
  end

  if g_game.getFeature(GameLoginPacketEncryption) then
    msg:encryptRsa()
  end

  if g_game.getFeature(GameProtocolChecksum) then
    self:enableChecksum()
  end

  self:send(msg)
  if g_game.getFeature(GameLoginPacketEncryption) then
    self:enableXteaEncryption()
  end
  self:recv()
end

function ProtocolDeleteCharacter:onConnect()
  self.gotConnection = true
  self:connectCallback()
  self.connectCallback = nil
end

function ProtocolDeleteCharacter:onRecv(msg)
  while not msg:eof() do
    local opcode = msg:getU8()

    if opcode == 0xB then
      self:parseError(msg)
    elseif opcode == 255 then
      self:parseSuccess(msg)  
    end
  end
  self:disconnect()
end

function ProtocolDeleteCharacter:parseSuccess(msg)
  local successMessage = msg:getString()
  self.onDeleteCharacterSuccess(successMessage)
end

function ProtocolDeleteCharacter:parseError(msg)
  local errorMessage = msg:getString()
  signalcall(self.onDeleteCharacterError, self, errorMessage)
end
