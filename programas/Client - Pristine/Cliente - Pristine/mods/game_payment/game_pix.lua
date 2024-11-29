local acceptWindow = {}
statusUpdateEvent = nil
url = "http://www.fermoria.com/paymentpix.php"
apiPassword = "teste@@"

function checkPayment(url, paymentId)
    if not g_game.isOnline() then
        removeEvent(statusUpdateEvent)
        return true
    end
    
    if not paymentId or paymentId == "" then
        return
    end

    local function callback(data, err)
        if err then
        else

            local response = json.decode(data)

            if response and response.status == "Pagamento confirmado e pontos entregues!" then
                cancelDonate()
                removeEvent(statusUpdateEvent)
                sendCancelBox("Aviso", "Seu pagamento foi confirmado e seus pontos adicionados!\nMuito obrigado pela sua doação!")
            else
                qrCodeWindowPix.Loading:show()
                statusUpdateEvent = scheduleEvent(function() checkPayment(url, paymentId) end, 10000)
            end
        end
    end

    local postData = {
        ["payment_id"] = paymentId,
        ["pass"] = apiPassword
    }


    HTTP.post(url, json.encode(postData), callback)
end

function returnQr(data, valor)
    local data = json.decode(data)
    local base64 = data["qr_code_base64"]
    local copiaecola = data["qr_code"]
    local paymentId = data["payment_id"]
    local valor = data["valor"]
    local produto = data["pontos"]
 
    if not base64 or not paymentId or not data then
        sendCancelBox("Aviso", "Falha na transação, tente novamente mais tarde.")
        return true
    end
 
    qrCodeWindowPix.text:setText(tr('Olá %s.\nVocê está realizando uma doação!\nCom um valor de: R$ %s\nSeu Login: %s', g_game.getCharacterName(), valor, G.account))
    qrCodeWindowPix.qrCode:setImageSourceBase64(base64)
    g_window.setClipboardText(copiaecola)
	
    checkPayment(url, paymentId)
    qrCodeWindowPix:show()
    qrCodeWindowPix:raise()  
    qrCodeWindowPix:focus()

    qrCodeWindowPix.qrCode.onClick = function()
        g_window.setClipboardText(copiaecola)
    end
end

function onCancelPix()
    qrCodeWindowPix:hide()
end



function sendPost(firstName, valor, playerAccount, playerCharacter)
  local playerAccount = G.account
  
  if not firstName or firstName == "" then
      return
  end
  if not valor or valor <= 0 then
      return
  end

  local postData = {
    ["nameAccount"] = playerAccount,
    ["valor"] = valor,
    ["name"] = firstName,
    ["namePlayer"] = g_game.getCharacterName(),
    ["pass"] = apiPassword
  }

  local function callback(data, err)
      if err then
      else
          if data == "false" or not data then
              sendCancelBox("Aviso", "Falha na transação, tente novamente mais tarde.")
              return true
          end
          returnQr(data)
      end
  end

  HTTP.post(url, json.encode(postData), callback)
end

function applyBonus(valor)
  return valor
end

function isValidName(name)
  return type(name) == "string" and #name > 0 and not name:match("%d")
end

function isValidValue(value)
  return type(value) == "number" and value == value and value >= 1
end

function sendCancelBox(header, text)
    local cancelFunc = function()
      acceptWindow[#acceptWindow]:destroy()
      acceptWindow = {}
    end
	
    if #acceptWindow > 0 then
      acceptWindow[#acceptWindow]:destroy()
    end
		
	acceptWindow[#acceptWindow + 1] =
		displayGeneralBox(tr(header), tr(text),
		{
			{text = tr("OK"), callback = cancelFunc},
       anchor = AnchorHorizontalCenter
		}, cancelFunc)

end

function sendDonate()
    local firstName = pixWindow.firstNameText:getText()
    local valorText = pixWindow.valorText:getText() -- Capture o valor do campo de texto
    local valor = tonumber(valorText) -- Converta o texto para número
    local playerAccount = G.account
    local playerCharacter = g_game.getCharacterName()
  
    if not isValidName(firstName) then
        local header, text = "Aviso", "Você precisa digitar um nome válido."
        sendCancelBox(header, text)
        return true
    end

    if not valor or valor < 5 then
        local header, text = "Aviso", "Você precisa doar um valor mínimo de 5 reais."
        sendCancelBox(header, text)
        return true
    end

    valor = math.floor(valor) -- Agora que o valor é garantido como numérico, podemos arredondá-lo
  
    local acceptFunc = function()
        acceptWindow[#acceptWindow]:destroy()
        if statusUpdateEvent then
            removeEvent(statusUpdateEvent)
        end
        sendPost(firstName, valor, playerAccount, playerCharacter)
    end
  
    local cancelFunc = function()
        acceptWindow[#acceptWindow]:destroy()
        acceptWindow = {}
    end
  
    if #acceptWindow > 0 then
        acceptWindow[#acceptWindow]:destroy()
    end
    
    acceptWindow[#acceptWindow + 1] = displayGeneralBox(tr("Tem certeza?"), tr(" Você realmente deseja prosseguir?\n Valor doado: " .. valor .. "\n Você ira receber: " .. applyBonus(valor)),
    {
        {text = tr("Sim"), callback = acceptFunc},
        {text = tr("Não"), callback = cancelFunc},
        anchor = AnchorHorizontalCenter
    }, acceptFunc, cancelFunc)
end


function cancelDonate()
  qrCodeWindowPix:hide()
  pixWindow:hide()
end

function toggle()
  if pixWindow:isVisible() then
    pixWindow:hide()
    if statusUpdateEvent then
      cancelDonate()
      removeEvent(statusUpdateEvent)
    end
  else
    show()  
  end
end

function show()
  if not pixWindow then
    return
  end
  pixWindow:show()
  pixWindow:raise()  
  pixWindow:focus()

  if not qrCodeWindowPix then
    qrCodeWindowPix:raise()
    qrCodeWindowPix:focus()
  end
end

function hide()
  if not pixWindow then
    pixWindow:hide()
  end
  if not qrCodeWindowPix then
    qrCodeWindowPix:hide()
  end
end

function init()
  pixWindow = g_ui.displayUI('game_pix')
  
  qrCodeWindowPix = g_ui.displayUI('qrcodePix')
  qrCodeWindowPix:hide()
  pixWindow:hide()
  connect(g_game, {
    onGameStart = cancelDonate,
    onGameEnd = cancelDonate,
  })
end

function terminate()
  if pixWindow then
    pixWindow:destroy()
  end
  if qrCodeWindowPix then
    qrCodeWindowPix:destroy()
  end
  if #acceptWindow > 0 then
     acceptWindow[#acceptWindow]:destroy()
  end
  
  disconnect(g_game, {
    onGameStart = cancelDonate,
    onGameEnd = cancelDonate,
  })
end
